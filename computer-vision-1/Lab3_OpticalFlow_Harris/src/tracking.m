function tracking(folder, K, sigma, threshold, N, format, visible)
    outputVideo = VideoWriter(sprintf('results/%s.avi', folder));
    outputVideo.FrameRate = 10;
    open(outputVideo)
    
    files = dir(fullfile(folder,sprintf('*.%s', format)));

    for i=1:length(files)-1
        close all;
        baseI1Name = files(i).name;
        display(baseI1Name);
        fullI1Name = fullfile(folder, baseI1Name);
        baseI2Name = files(i+1).name;
        fullI2Name = fullfile(folder, baseI2Name);
        I1 = imread(fullI1Name);
        I2 = imread(fullI2Name);
        
        gcf = figure;
        if ~visible
            set(gcf, 'Visible', 'off');
        end
        imshow(I1);
        hold on;
        
        if i == 1
            % in the first iteration get corner points
            [~, r, c] = harris_corner_detector(I1, K, sigma, threshold, N);
        else
            % move points using optical flow (scaled in order to make
            % optical flow values large enough)
            r = min(size(I1, 1), max(1, r + v_y*10));
            c = min(size(I1, 2), max(1, c + v_x*10));
        end
        
        s = scatter(c, r, 20, 'r');
        s.LineWidth = 0.6;
        s.MarkerEdgeColor = 'r';
        s.MarkerFaceColor = [1 0 0];
        
        [~, ~, v_x, v_y] = lucas_kanade(I1, I2, [round(r), round(c)]);
        quiver(c, r, v_x, v_y);

        [~,name,~] = fileparts(baseI1Name);
        saveas(gcf,sprintf('results/%s/%s', folder, name), 'jpg');
        drawnow;
        frame = getframe;
        hold off
        writeVideo(outputVideo,frame);
    end
    close(outputVideo)
end