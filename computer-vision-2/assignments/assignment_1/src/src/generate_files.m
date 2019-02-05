function generate_files()
    files = dir(fullfile('../data/data_mat/', '*.mat'));
    basic_files = dir(fullfile('../data', '*.mat'));
    files = [files, basic_files];
    for i =1:size(files,1)
        name=strcat(files(i).folder, '/', files(i).name);
        x = load(name);
        is_points = isfield(x, 'points');
        
        if isfield(x, 'normal')
            x = x.normal;
        elseif isfield(x, 'points')
            x = x.points;
        end
        
        if is_points
            txtname = extractBefore(name,size(name,2) - 3);
            txtname = strcat(txtname,'.txt');
            txtname = strrep(txtname, 'data_mat', 'transformed_data');
            f=fopen(txtname,'w');
            x = x';
            fprintf(f,'%6f %6f %6f \n',x);

            fclose(f);
        end

    end
end