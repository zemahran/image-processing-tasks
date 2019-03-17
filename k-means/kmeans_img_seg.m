%% Part I

clear;
X=[1 1;1 2;2 1;10 10;10 11;11 10];
[idx, centroids] = kmeans(X, 2)
[idx, centroids] = kmeans(X, 3)
%% Part II
%%
clear;
img = double(imread('Objects.bmp'));
segment(img, 2, 'grayscale')
segment(img, 3, 'grayscale')
segment(img, 4, 'grayscale')
segment(img, 5, 'grayscale')
% segment(img, 2, 'colored')
% segment(img, 3, 'colored')
% segment(img, 4, 'colored')
% segment(img, 5, 'colored')
%% Part III
%%
clear;
img = double(imread('Objects.bmp'));
K = compute_best_k(img, [2:10]);
segment(img, K, 'grayscale')
%% External Functions
%%
function segment(img, K, color)
% Segmnent an image into K cluster of pixel values and display
% its compressed colored/grayscale output. img must be an rgb image,
% K must be an integer, and color is either "colored" or "grayscale".

% Divide by 255 so that all values are in the range 0:1
img = img / 255;
img_size = size(img);

% Reshape the image into an Nx3 matrix where N = number of pixels
% Each row will contain the Red, Green and Blue pixel values
% This gives us our dataset matrix X that we will use K-Means on
X = reshape(img, img_size(1) * img_size(2), 3);

[idx, centroids, dist] = kmeans(X, K, 'EmptyAction', 'singleton');

% now that we have represented the image X in terms of the values in idx,
% we can now recover the image from the indices (idx) by mapping each pixel
% (specified by its index in idx) to the centroid value
X_recovered = centroids(idx,:);

% Reshape the recovered image into proper dimensions (r,g,b)
X_recovered = reshape(X_recovered, img_size(1), img_size(2), 3);

% Display the original & compressed images side-by-side
switch color
    
    case 'colored'
        figure();
        subplot(1, 2, 1);
        imshow(img);
        title('Original');
        subplot(1, 2, 2);
        imshow(X_recovered);
        title(sprintf('Compressed with %d colors', K));
        
    case 'grayscale'
        figure();
        subplot(1, 2, 1);
        imshow(rgb2gray(img));
        title('Original');
        subplot(1, 2, 2);
        imshow(rgb2gray(X_recovered));
        title(sprintf('Compressed with %d colors', K));
        
end

% Compute Q:
Q = compute_Q(centroids, dist, K)

end

function Q = compute_Q(centroids, dist, K)
% Quantify the quality of clustering by measuring the ratio between the inter-cluster
% distances and the intra-cluster distances. The best segmentation output is the one
% that gives the minimum Q. This is because a good clustering output should satisfy
% two conditions:
% 1. Small difference between points in the same cluster (compact clusters)
% 2. Large difference between points across different clusters (distant clusters)
% Thus we aim to minimize the numerator and maximize the denominator.

% inter-cluster mean square distances
inter_dists = sum(dist)/K;

% intra-cluster mean square distances
intra_dists = 0;
for i=1:K-1
    for j=i+1:K
        intra_dists = intra_dists + pdist2(centroids(i,:), centroids(j,:));
    end
end

Q = inter_dists/intra_dists;

end

function K = compute_best_k(img, K_arr)
% Compute the best value for K to for img segmentation given an array of different
% possible K values. K_arr must be a uniformally stepped array of integers with step=1.

% Preprocessing
img = img / 255;
img_size = size(img);
X = reshape(img, img_size(1) * img_size(2), 3);

% Get K value that corresponds to lowest Q
Q = inf; K_temp=0;
for k=K_arr(1):1:K_arr(end)
    [~, centroids, dist] = kmeans(X, k, 'EmptyAction', 'singleton');
    Q_temp = compute_Q(centroids,dist,k);
    if Q_temp < Q
        Q = Q_temp
        K_temp = k;
    end
end

disp("Best K:")
K = K_temp

end