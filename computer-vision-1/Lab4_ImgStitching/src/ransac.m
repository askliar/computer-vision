function [M, T, inliers] = ransac(f1, f2, matches, confidence)
    sample_size = 7;
    
    % calculate number of iterations
    N = log(1-confidence)/log(1 - 0.5^sample_size); 
    
    num_inliers = 0;
    M = zeros(2, 2);
    T = zeros(2, 1);
    
    for p=1:N
        sample = randsample(size(matches, 2), sample_size);
        matches_sampled = matches(:, sample);
        
        xa = f1(1,matches_sampled(1,:));
        xb = f2(1,matches_sampled(2,:));
        ya = f1(2,matches_sampled(1,:));
        yb = f2(2,matches_sampled(2,:));
        
        A = zeros(2*size(xa, 2), 6);
        b = zeros(2*size(xa, 2), 1);
        
        for i=1:2:2*size(xa, 2)
            A(i:i+1, :) = [xa(ceil(i/2)) ya(ceil(i/2)) 0 0 1 0; 0 0 xa(ceil(i/2)) ya(ceil(i/2)) 0 1];
            b(i:i+1) = [xb(ceil(i/2)); yb(ceil(i/2))];
        end
        
        x = pinv(A) * b;
        temp = num2cell(x);
        
        [m1, m2, m3, m4, t1, t2] = deal(temp{:});
        distance = [m1 m2; m3 m4] * [xa; ya] + [t1;t2] - [xb; yb];
        
        % get points having coordinates within circle of radius 10 with
        % original points
        inliers_bool = sum(distance .^ 2) <= 100;
        % number of inliers
        inliers_total = sum(inliers_bool);
        
        if inliers_total > num_inliers
            num_inliers = inliers_total;
            inliers = [matches_sampled(:, inliers_bool); xa(inliers_bool); xb(inliers_bool); ya(inliers_bool); yb(inliers_bool)];
            M = [m1 m2; m3 m4];
            T = [t1;t2];
        end
    end
end

