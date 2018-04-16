function [C, label] = kmeans_manifold2(path, k, type)


%   ...Dimensions...    %
N = length(path.Y);


%   ...Initialize point labels...    %
idx = randperm(N);
label = zeros(N, 1);

start = 1;
for i = 1 : k
    last = start + floor(N/ k) - 1;
    label(idx(start : last)) = i;
    start = last + 1;
end
label(idx(start : end)) = randperm(k, N - last);


%   ...Size of the data...	%
%   ...Read i-th data point...  %
fid = fopen(char(path.Y(i)), 'r');
n = fread(fid, 1, 'int');
m = fread(fid, 1, 'int');
fclose(fid);


%   ...Initialize cluster centers...    %
C = zeros(n, m, k);
for i = 1 : k
    C(:, :, i) = karcher_mean_iterative(path.Y(label == i), type)';
end


%   ...k-means clustering...    %
flag = 1;
while flag == 1
    %   ...Re-label the points...   %
    for i = 1 : N
        %   ...Read i-th data point...  %
        fid = fopen(char(path.Y(i)), 'r');
        fread(fid, 2, 'int');
        y = fread(fid, [n, m], 'float32');
        fclose(fid);
        
        dist = zeros(1, k);
        for j = 1 : k
            dist(j) = distance(C(:, :, j), y, type);
        end
	
        [~, j] = min(dist);
        dist
        fprintf('Point: %d  from cluster: %d    to cluster: %d\n', i, label(i), j);
        label(i) = j;
    end
    
    %   ...Re-compute cluster centers...    %
    change = 0;
    for i = k : -1 : 1
        idx = find(label == i);
        
        if ~isempty(idx)
            center = karcher_mean_iterative(path.Y(idx), type)';
            change = change + distance(center, C(:, :, i), type) ^ 2;
            C(:, :, i) = center;
        else
            C(:, :, i) = [];
            idx = label > i;
            label(idx) = label(idx) - 1;
            k = k - 1;
        end
    end
    fprintf('change: %f\n', change);
    
    %   ...Stop if there is negligible change...    %
    if change < 1e-4
        flag = 0;
    end
end


end

