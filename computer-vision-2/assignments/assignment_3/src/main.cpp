/*
 * main.cpp
 *
 *  Created on: 28 May 2016
 *      Author: Minh Ngo @ 3DUniversum
 */
#include <iostream>
#include <boost/format.hpp>
#include <pcl/point_types.h>
#include <pcl/point_cloud.h>
#include <pcl/features/integral_image_normal.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <pcl/common/transforms.h>
#include <pcl/kdtree/kdtree_flann.h>
#include <pcl/surface/marching_cubes.h>
#include <pcl/surface/marching_cubes_hoppe.h>
#include <pcl/filters/passthrough.h>
#include <pcl/surface/poisson.h>
#include <pcl/surface/impl/texture_mapping.hpp>
#include <pcl/features/normal_3d_omp.h>
#include <pcl/filters/filter.h>
#include <pcl/io/pcd_io.h>
#include <pcl/filters/extract_indices.h>
#include <pcl/features/normal_3d.h>
#include <pcl/surface/gp3.h>
#include <pcl/search/kdtree.h>
#include <eigen3/Eigen/Core>
#include <pcl/surface/marching_cubes_rbf.h>
#include <pcl/io/pcd_io.h>
#include <pcl/io/ply_io.h>
#include <pcl/features/normal_3d_omp.h>
#include <pcl/surface/mls.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/mat.hpp>
#include <opencv2/core/eigen.hpp>
#include <vtkFillHolesFilter.h>
#include "Frame3D/Frame3D.h"
#include "pcl/surface/vtk_smoothing/vtk_utils.h"
#include <vtkPolyData.h>

pcl::PointCloud<pcl::PointXYZ>::Ptr mat2IntegralPointCloud(const cv::Mat &depth_mat, const float focal_length, const float max_depth) {
    // This function converts a depth image to a point cloud
    assert(depth_mat.type() == CV_16U);
    pcl::PointCloud<pcl::PointXYZ>::Ptr point_cloud(new pcl::PointCloud<pcl::PointXYZ>());
    const int half_width = depth_mat.cols / 2;
    const int half_height = depth_mat.rows / 2;
    const float inv_focal_length = 1.0 / focal_length;
    point_cloud->points.reserve(depth_mat.rows * depth_mat.cols);
    for (int y = 0; y < depth_mat.rows; y++)
    {
        for (int x = 0; x < depth_mat.cols; x++)
        {
            float z = depth_mat.at<ushort>(cv::Point(x, y)) * 0.001;
            if (z < max_depth && z > 0)
            {
                point_cloud->points.emplace_back(static_cast<float>(x - half_width) * z * inv_focal_length,
                                                 static_cast<float>(y - half_height) * z * inv_focal_length,
                                                 z);
            }
            else
            {
                point_cloud->points.emplace_back(x, y, NAN);
            }
        }
    }
    point_cloud->width = depth_mat.cols;
    point_cloud->height = depth_mat.rows;
    return point_cloud;
}

pcl::PointCloud<pcl::PointNormal>::Ptr computeNormals(pcl::PointCloud<pcl::PointXYZ>::Ptr cloud) {
    // This function computes normals given a point cloud
    // !! Please note that you should remove NaN values from the pointcloud after computing the surface normals.
    pcl::PointCloud<pcl::PointNormal>::Ptr cloud_normals(new pcl::PointCloud<pcl::PointNormal>); // Output datasets
    pcl::IntegralImageNormalEstimation<pcl::PointXYZ, pcl::PointNormal> ne;
    ne.setNormalEstimationMethod(ne.AVERAGE_3D_GRADIENT);
    ne.setInputCloud(cloud);
    ne.compute(*cloud_normals);
    pcl::copyPointCloud(*cloud, *cloud_normals);
    return cloud_normals;
}

pcl::PointCloud<pcl::PointXYZRGB>::Ptr transformPointCloud(pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud, const Eigen::Matrix4f &transform) {
    pcl::PointCloud<pcl::PointXYZRGB>::Ptr transformed_cloud(new pcl::PointCloud<pcl::PointXYZRGB>());
    pcl::transformPointCloud(*cloud, *transformed_cloud, transform);
    return transformed_cloud;
}

template <class T>
typename pcl::PointCloud<T>::Ptr transformPointCloudNormals(typename pcl::PointCloud<T>::Ptr cloud, const Eigen::Matrix4f &transform) {
    typename pcl::PointCloud<T>::Ptr transformed_cloud(new typename pcl::PointCloud<T>());
    pcl::transformPointCloudWithNormals(*cloud, *transformed_cloud, transform);
    return transformed_cloud;
}

pcl::PointCloud<pcl::PointXYZRGBNormal>::Ptr mergingPointClouds(std::vector<Frame3D> frames)
{
    std::cout << "Merging point clouds" << std::endl;
    pcl::PointCloud<pcl::PointXYZRGBNormal>::Ptr modelCloud(new pcl::PointCloud<pcl::PointXYZRGBNormal>);

    for (Frame3D frame: frames)
    {
        cv::Mat depthImage = frame.depth_image_;
        double focalLength = frame.focal_length_;
        const Eigen::Matrix4f cameraPose = frame.getEigenTransform();

        pcl::PointCloud<pcl::PointXYZ>::Ptr pointCloud = mat2IntegralPointCloud(depthImage, focalLength, 1);
        pcl::PointCloud<pcl::PointNormal>::Ptr pointCloudWithNormals = computeNormals(pointCloud);

        // remove NaNs from normals
        std::vector<int> indices_normals;
        pcl::PointCloud<pcl::PointNormal>::Ptr pointCloudWithNormalsFiltered(new pcl::PointCloud<pcl::PointNormal>);
        pcl::removeNaNNormalsFromPointCloud<pcl::PointNormal>(*pointCloudWithNormals, *pointCloudWithNormalsFiltered, indices_normals);

        pointCloudWithNormalsFiltered = transformPointCloudNormals<pcl::PointNormal>(pointCloudWithNormalsFiltered, cameraPose);
        pcl::PointCloud<pcl::PointXYZRGBNormal>::Ptr cloud_xyzrgbnormal(new pcl::PointCloud<pcl::PointXYZRGBNormal>);
        copyPointCloud(*pointCloudWithNormalsFiltered, *cloud_xyzrgbnormal);

        *modelCloud += *cloud_xyzrgbnormal;
    }

    return modelCloud;
}

// Different methods of constructing mesh
enum CreateMeshMethod {
    PoissonSurfaceReconstruction = 0,
    MarchingCubes = 1
};

// Create mesh from point cloud using one of above methods
pcl::PolygonMesh createMesh(pcl::PointCloud<pcl::PointXYZRGBNormal>::Ptr pointCloud, CreateMeshMethod method) {
    std::cout << "Creating meshes" << std::endl;

    // The variable for the constructed mesh

    pcl::PolygonMesh::Ptr triangles(new pcl::PolygonMesh);

    // TODO(Student): Call Poisson Surface Reconstruction. ~ 5 lines.
    // TODO: Experiment with different depth
    if (method == PoissonSurfaceReconstruction)
    {
        pcl::Poisson<pcl::PointXYZRGBNormal>::Ptr poisson(new pcl::Poisson<pcl::PointXYZRGBNormal>);
        poisson->setDepth(5);
        // poisson->setSamplesPerNode(5);

        poisson->setInputCloud(pointCloud);
        poisson->reconstruct(*triangles);
    }
    else if (method == MarchingCubes)
    {

        // TODO(Student): Call Marching Cubes Reconstruction. ~ 5 lines.
        // TODO: Experiment with different versions and parameters of marching cubes
        pcl::search::KdTree<pcl::PointXYZRGBNormal>::Ptr tree(new pcl::search::KdTree<pcl::PointXYZRGBNormal>);
        tree->setInputCloud(pointCloud);

        pcl::MarchingCubesHoppe<pcl::PointXYZRGBNormal> mc;
        mc.setInputCloud(pointCloud);
        // mc.setPercentageExtendGrid(0.1);
        mc.setGridResolution(100, 100, 100);
        mc.setSearchMethod(tree);
        mc.reconstruct(*triangles);
    }

    return *triangles;
}

int median(std::vector<int> &v) {
    size_t n = v.size() / 2;
    std::nth_element(v.begin(), v.begin() + n, v.end());
    return v[n];
}

pcl::PolygonMesh addTexture(std::vector<Frame3D> frames, pcl::PolygonMesh triangles, int average_colors, bool reverse)
{
    // average_colors = 0:
    // average_colors = 1: average color for every vertex
    // average_colors = 2: median color for every vertex
    // reverse is used for processing frames in reversed order - useful when average_colors = 0

    Eigen::Vector2f uv_coordinates;

    pcl::PointCloud<pcl::PointXYZ>::Ptr point_cloud(new pcl::PointCloud<pcl::PointXYZ>());
    pcl::PointCloud<pcl::PointXYZRGB>::Ptr point_cloud_coloured(new pcl::PointCloud<pcl::PointXYZRGB>());

    pcl::fromPCLPointCloud2(triangles.cloud, *point_cloud);
    pcl::fromPCLPointCloud2(triangles.cloud, *point_cloud_coloured);

    pcl::TextureMapping<pcl::PointXYZ> texture;

    int n_vertices = point_cloud_coloured->points.size();
    // sum of color intensities. first index: 0->b, 1->g, 2->r, 3->count
    // second index: vertex index.
    // In this way we can cumulate pixel intensities by channel and calculate an average
    // WARNING!!! the number of points may be too high, and the huge dimension of the array could cause the program to crash
    int* sums[4];//[point_cloud_coloured->points.size()];
    // std::vector<int> r[n_vertices], g[n_vertices], b[n_vertices];
    std::vector<int> *r, *g, *b;
    if (average_colors == 1){
        for(int i = 0; i < 4; i++){
            sums[i] = new int[point_cloud_coloured->points.size()];
        }
    }
    else if (average_colors == 2){
        // allocate only when needed, otherwise risk crashing
        r = new std::vector<int>[n_vertices];
        g = new std::vector<int>[n_vertices];
        b = new std::vector<int>[n_vertices];
        for(int i = 0; i < n_vertices; i++){
            b[i] = std::vector<int>(0);
            g[i] = std::vector<int>(0);
            r[i] = std::vector<int>(0);
        }
    }

    if (reverse){ // we might want to process frames in reverse order, as without averaging this impacts the final coloring
        std::reverse(frames.begin(), frames.end());
    }
    for (Frame3D frame: frames)
    {
        const Eigen::Matrix4f cameraPose = frame.getEigenTransform();

        cv::Mat rgbImage;
        cv::resize(frame.rgb_image_, rgbImage, frame.depth_image_.size());

        const Eigen::Matrix4f cameraPoseInv = cameraPose.inverse().eval();
        pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_inv(new pcl::PointCloud<pcl::PointXYZ>());
        pcl::transformPointCloud(*point_cloud, *cloud_inv, cameraPoseInv);

        pcl::TextureMapping<pcl::PointXYZ>::Octree::Ptr octree(new pcl::TextureMapping<pcl::PointXYZ>::Octree(0.01));
        octree->setInputCloud(cloud_inv);
        octree->addPointsFromInputCloud();

        pcl::texture_mapping::Camera camera;
        camera.focal_length = frame.focal_length_;
        camera.height = rgbImage.size().height;
        camera.width = rgbImage.size().width;

        // iterate over every vertex, and color the point cloud accordingly (or save results for averaging later)
        for (int k = 0; k < n_vertices; k++) {
            const pcl::PointXYZ vertices_points = cloud_inv->points.at(k);
            if (!texture.isPointOccluded(vertices_points, octree)) {
                texture.getPointUVCoordinates(vertices_points, camera, uv_coordinates);
                if (uv_coordinates[0] >= 0 && uv_coordinates[1] >= 0) {
                    int cols = round(uv_coordinates.x() * camera.width);
                    int rows = round(camera.height - uv_coordinates.y() * camera.height);

                    cv::Vec3b source_pixel = rgbImage.at<cv::Vec3b>(rows, cols);

                    if (average_colors == 0){ // replace the colors; sensitive to frame processing order
                        point_cloud_coloured->points.at(k).b = source_pixel[0];
                        point_cloud_coloured->points.at(k).g = source_pixel[1];
                        point_cloud_coloured->points.at(k).r = source_pixel[2];
                    }
                    else if (average_colors == 1){ // for calculating the mean colors
                        sums[0][k] += source_pixel[0];
                        sums[1][k] += source_pixel[1];
                        sums[2][k] += source_pixel[2];
                        sums[3][k] += 1;
                    }      
                    else if (average_colors == 2){ // append to a vector to calculate the median
                        b[k].push_back(source_pixel[0]);
                        g[k].push_back(source_pixel[1]);
                        r[k].push_back(source_pixel[2]);
                    }                 
                }
            }
        }
    
    }
    // calculate average colors for every point
    if (average_colors == 1){
        for(int i = 0; i < point_cloud_coloured->points.size(); i++){
            if (sums[3][i] > 0){ // check the vertex has been processed
                point_cloud_coloured->points.at(i).b = (u_int8_t)(sums[0][i] / sums[3][i]);
                point_cloud_coloured->points.at(i).g = (u_int8_t)(sums[1][i] / sums[3][i]);
                point_cloud_coloured->points.at(i).r = (u_int8_t)(sums[2][i] / sums[3][i]);
            }
        }
    }
    // calculate median colors for every point
    else if (average_colors == 2){
         for(int i = 0; i < point_cloud_coloured->points.size(); i++){
            if (b[i].size() > 0){ // check the vertex has been processed
                // if (b[i].size() > 2) // for printing the number of views that see the same vertex
                    // std::cout << b[i].size() << std::endl;
                point_cloud_coloured->points.at(i).b = median(b[i]);
                point_cloud_coloured->points.at(i).g = median(g[i]);
                point_cloud_coloured->points.at(i).r = median(r[i]);
            }
        }
    }

    pcl::toPCLPointCloud2(*point_cloud_coloured, triangles.cloud);
    return triangles;
}

// Given a PolygonMesh input, fills its holes using vtk functions
// The input mesh is modified as it is passed by reference
void fillPolygonMeshHoles(pcl::PolygonMesh &triangles, float holeSize)
{
    vtkSmartPointer<vtkPolyData> vtkMesh = vtkSmartPointer<vtkPolyData>::New();
    pcl::VTKUtils::mesh2vtk(triangles, vtkMesh);

    vtkSmartPointer<vtkFillHolesFilter> fillHolesFilter = vtkSmartPointer<vtkFillHolesFilter>::New();
    fillHolesFilter->SetInputData(vtkMesh);
    fillHolesFilter->SetHoleSize(holeSize);
    fillHolesFilter->Update();

    pcl::VTKUtils::vtk2mesh(fillHolesFilter->GetOutput(), triangles);
}
// to run the file, use 
// make -j2 && ./final ../../3dframes 1 t
// where first parameter is 0 for poisson, 1 for marching cubes
// second parameter is t for adding texture (color), any other value for not adding texture
int main(int argc, char *argv[])
{
    if (argc != 4)
    {
        std::cout << "./final [3DFRAMES PATH] [RECONSTRUCTION MODE] [TEXTURE_MODE]" << std::endl;

        return 0;
    }

    const CreateMeshMethod reconMode = static_cast<CreateMeshMethod>(std::stoi(argv[2]));

    // Loading 3D frames
    std::vector<Frame3D> frames = Frame3D::loadFrames(boost::str(boost::format("%s") % argv[1]));

    pcl::PointCloud<pcl::PointXYZRGBNormal>::Ptr texturedCloud;
    pcl::PolygonMesh triangles;

    // Create one point cloud by merging all frames with texture using
    // the rgb images from the frames
    texturedCloud = mergingPointClouds(frames);

    // Create a mesh from the textured cloud using a reconstruction method,
    // Poisson Surface or Marching Cubes
    triangles = createMesh(texturedCloud, reconMode);

    fillPolygonMeshHoles(triangles, 100.0f); // the hole size parameter is almost insignificant, in our case all values > 1 lead to the same results
    
    if (argv[3][0] == 't')
    {
        // SECTION 4: Coloring 3D Model
        std::cout << "Start adding color to the model" << std::endl;
        triangles = addTexture(frames, triangles, 0, 0);

    }

    // Sample code for visualization.

    // Show viewer
    std::cout << "Finished adding color to the model" << std::endl;
    boost::shared_ptr<pcl::visualization::PCLVisualizer> viewer(new pcl::visualization::PCLVisualizer("3D Viewer"));

    // Add mesh
    viewer->setBackgroundColor(1, 1, 1);
    viewer->addPolygonMesh(triangles, "meshes", 0);
    viewer->addCoordinateSystem(1.0);
    viewer->initCameraParameters();

    // Keep viewer open
    while (!viewer->wasStopped())
    {
        viewer->spinOnce(100);
        boost::this_thread::sleep(boost::posix_time::microseconds(100000));
    }

    return 0;
}
