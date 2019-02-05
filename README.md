# Computer Vision

[![License](http://img.shields.io/:license-mit-blue.svg)](LICENSE)

## Description

Labs and presentation of the [Computer Vision 1](http://coursecatalogue.uva.nl/xmlpages/page/2017-2018-en/search-course/course/36147) and [Computer Vision 2](http://coursecatalogue.uva.nl/xmlpages/page/2017-2018-en/search-course/course/35404) courses of the MSc in Artificial Intelligence at the University of Amsterdam. Labs in Computer Vision 1 are joint work with [Gabriele Bani](https://github.com/Hiryugan). For Computer Vision 2, work was done together with [Gabriele Bani](https://github.com/Hiryugan) and [Andreas Hadjipieri](https://github.com/antreashp).

## Computer Vision 1

### Labs

#### Photometric Stereo & Color
[Problem statement](computer-vision-1/Lab1_Photometric_Color/Lab01_Instruction.pdf) and [Solution](computer-vision-1/Lab1_Photometric_Color/report/hw1.pdf)

<p align="center">
  <img src="https://cdn.pbrd.co/images/HZKtcFq.png" width="600" /><br />
  <i>Face heightmap for different conﬁgurations</i>
</p>

#### Neighborhood Processing & Filters
[Problem statement](computer-vision-1/Lab2_Filters/Lab02_Instruction.pdf) and [Solution](computer-vision-1/Lab2_Filters/report/hw2.pdf)

<p align="center">
  <img src="https://cdn.pbrd.co/images/HZKvkVw.png" width="600" /><br />
  <i>Gabor segmentation applied to images with and without smoothing</i>
</p>


#### Harris Corner Detector & Optical Flow
[Problem statement](computer-vision-1/Lab3_OpticalFlow_Harris/Lab03_Instruction.pdf) and [Solution](computer-vision-1/Lab3_OpticalFlow_Harris/report/hw3.pdf)


<p align="center">
  <img src="https://cdn.pbrd.co/images/HZKzJaz.png" width="650" /><br />
  <i>Corner detection with varying sigma and threshold</i>
</p>

<p align="center">
  <img src="https://media.giphy.com/media/4abnLLgLYMarKv5aNG/giphy.gif" width="650" /><br />
  <i>Feature Tracking</i>
</p>


#### Image Alignment and Stitching
[Problem statement](computer-vision-1/Lab4_ImgStitching/Lab04_Instruction.pdf) and [Solution](computer-vision-1/Lab4_ImgStitching/report/hw4.pdf)


<p align="center">
  <img src="https://cdn.pbrd.co/images/HZKxWjs.png" width="650" /><br />
  <i>Original and stitched bus images</i>
</p>

#### Final Project: Bag-of-Words based Image Classiﬁcation (part 1) and Convolutional Neural Networks for Image Classiﬁcation (part 2)

[Problem statement for part 1](computer-vision-1/Lab5_Project/FinalProject_part_1_bow.pdf), [Problem statement for part 2](computer-vision-1/Lab5_Project/FinalProject_part_2_cnn.pdf) and [Solution](computer-vision-1/Lab5_Project/report/hw5.pdf)

<p align="center">
  <img src="https://cdn.pbrd.co/images/HZKChIE.png" width="650" /><br />
  <i>Performance of Bag-of-Words model</i>
</p>

<p align="center">
  <img src="https://cdn.pbrd.co/images/HZKCSea.png" width="650" /><br />
  <i>T-SNE Visualizations of CNN model features</i>
</p>

---

### Dependencies
- Matlab 2017a

## Computer Vision 2

### Labs

#### Iterative Closest Point
[Problem statement](computer-vision-2/assignments/assignment_1/lab1.pdf) and [Solution](computer-vision-2/assignments/assignment_1/lab1-sol.pdf)

<p align="center">
  <img src="https://cdn.pbrd.co/images/HZL0LBH.png" width="800" /><br />
  <i>Result of Scene Merging</i>
</p>


#### Structure from Motion
[Problem statement](computer-vision-2/assignments/assignment_2/lab2.pdf) and [Solution](computer-vision-2/assignments/assignment_2/lab2-sol.pdf)

Feature Matching             |  Point-View Matrices
:-------------------------:|:-------------------------:
<img src="https://cdn.pbrd.co/images/HZKVcen.png" width="400"/>  |  <img src="https://cdn.pbrd.co/images/HZKVHYY.png" width="400"/>


<p align="center">
  <img src="https://cdn.pbrd.co/images/HZKWS6W.png" width="400" /><br />
  <i>Result of the Structure from Motion algorithm</i>
</p>

#### 3D Mesh Generation and Texturing
[Problem statement](computer-vision-2/assignments/assignment_3/lab3.pdf) and [Solution](computer-vision-2/assignments/assignment_3/lab3-sol.pdf)

<p align="center">
  <img src="https://cdn.pbrd.co/images/HZKTMM0.png" width="400" /><br />
  <i> Reconstruction using Poisson with texture </i>
</p>

---

### Dependencies
To run each file, take a look at following files:

- [Instructions](computer-vision-2/assignments/assignment_1/src/README.md) for Lab 1.
- [Instructions](computer-vision-2/assignments/assignment_2/src/README.md) for Lab 2. 
- Preparation section in [Problem statement](computer-vision-2/assignments/assignment_3/lab3.pdf) for Lab 3.

---

### Paper Presentation

Paper [Learning to Reason: End-to-End Module Networks for Visual Question Answering](https://arxiv.org/abs/1704.05526) by Hu et al. is trying to tackle problem of question answering. As questions are inherently compositional, authors argue that they can be answered easier if decomposed into modular sub-problems. They propose End-to-End Module Networks, which learn to reason by directly predicting instance-specific network layouts without the aid of a parser.

Slides presenting paper can be found [here](computer-vision-2/presentation/Learning_to_Reason__End_to_End_Module.pdf).

## Copyright

Copyright © 2017-2018 Andrii Skliar.

<p align="justify">
This project is distributed under the <a href="LICENSE">MIT license</a>. This was developed as part of the courses Computer Vision 1 and Computer Vision 2 taught by Theo Gevers at the University of Amsterdam. Please follow the <a href="http://student.uva.nl/en/content/az/plagiarism-and-fraud/plagiarism-and-fraud.html">UvA regulations governing Fraud and Plagiarism</a> in case you are a student.
</p>
