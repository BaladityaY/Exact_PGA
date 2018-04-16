function [center, label] = kmeans_manifold(Y, k, nn, pp, type)


%   ...Dimensions...    %
sz = size(Y);
if length(sz) == 2
    Y = reshape(Y, [sz(1), 1, sz(2)]);
end
[n, m, N] = size(Y);


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


%   ...Initialize cluster centers...    %
center = zeros(n, m, k);
for i = 1 : k
    if type==1
        center(:, :, i) = karcher_mean_Stiefel_recursive(Y(:, :, label == i),nn,pp);
    else
        center(:, :, i) = karcher_mean_Stiefel(Y(:, :, label == i),nn,pp);
    end;
end


%   ...k-means clustering...    %
flag = 1;
while flag == 1
    center_old = center;
    
    %   ...Re-label the points...   %
    for i = 1 : N
        dist = zeros(k, 1);
        for j = 1 : k
            dist(j) = distance_stiefel(center(:, :, j), Y(:, :, i), nn,pp);
        end
        [~, j] = min(dist);
        label(i) = j;
    end
    
    %   ...Re-compute cluster centers...    %
    center = zeros(n, m, k);
    for i = k : -1 : 1
        idx = find(label == i);
        if ~isempty(idx)
            if type==1  
                center(:, :, i) = karcher_mean_Stiefel_recursive(Y(:, :, idx), nn, pp);
            else
                center(:, :, i) = karcher_mean_Stiefel(Y(:, :, idx), nn, pp);
            end;
        else
            center(:, :, i) = [];
            center_old(:, :, i) = [];
            
            idx = label > i;
            label(idx) = label(idx) - 1;
            k = k - 1;
        end
    end
    
    %   ...Check the changes in cluster centers...  %
    change = 0;
    for i = 1 : k
        change = change + distance_stiefel(center(:, :, i), center_old(:, :, i), nn, pp) ^ 2;
    end
    
    %   ...Stop if there is negligible change...    %
    if change < 1e-3
        flag = 0;
    end
end


end

