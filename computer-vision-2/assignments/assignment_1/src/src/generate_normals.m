function generate_normals()
    files = dir(fullfile('../data/data_mat/', '*.mat'));

    for i =1:size(files,1)
        name = strcat(files(i).folder, '/', files(i).name);
        x = load(name);
        is_normal = isfield(x, 'normal');
        if isfield(x, 'normal')
            x = x.normal;
        elseif isfield(x, 'points')
            x = x.points;
        end

        txtname = extractBefore(name,size(name,2) - 3);
        if ~is_normal
            x = findPointNormals(x);
            txtname = strcat(txtname, '_normal','.txt');
            txtname = strrep(txtname, 'data_mat', 'transformed_data');
            f=fopen(txtname,'w');
            x = x';
            fprintf(f,'%6f %6f %6f \n',x);

            fclose(f);
        end
    
    
    end
end
