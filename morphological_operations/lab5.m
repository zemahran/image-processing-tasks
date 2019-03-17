%% Part I

clear;
img = imbinarize(imread('Cameraman_bin.jpg'), 0.5);

% Dilate img with 3x3 square structuring element
dilate_1 = dilate(img, ones(3,3));
figure; imwrite(dilate_1, 'Dilation 3x3.png');
imshow(dilate_1); title('Dilation 3x3')

% Dilate img with 7x7 square structuring element
dilate_2 = dilate(img, ones(7,7));
figure; imwrite(dilate_2, 'Dilation 7x7.png');
imshow(dilate_2); title('Dilation 7x7')
%% The impact of increasing the size of the structuring element on the output dilated image:
% Increasing the structuring element from 3x3 to 7x7 affected the appearance 
% of the fine lines in the image. Now the background and foreground are both more 
% melted together and the image is visually disturbed.
%% Part II
%%
clear;
img = imbinarize(imread('Cameraman_bin.jpg'), 0.5);

% Erode img with 3x3 square structuring element
erode_1 = erode(img, ones(3,3));
figure; imwrite(erode_1, 'Erosion 3x3.png');
imshow(erode_1); title('Erosion 3x3')

% Erode img with 7x7 square structuring element
erode_2 = erode(img, ones(7,7));
figure; imwrite(erode_2, 'Erosion 7x7.png');
imshow(erode_2); title('Erosion 7x7')

% Obtain contours for both eroded images
padded_img1 = padarray(img,[3 3],0,'both');
contours_1 = padded_img1 - erode_1;
figure; imwrite(contours_1, 'Contours 3x3.png');
imshow(contours_1); title('Contours 3x3')

padded_img2 = padarray(img,[7 7],0,'both');
contours_2 = padded_img2 - erode_2;
figure; imwrite(contours_2, 'Contours 7x7.png');
imshow(contours_2); title('Contours 7x7')
%% Part III
%%
clear;
img = imcomplement(imbinarize(imread('Fingerprint.jpg'), 0.5));

% Perform morphological opening & closing using a 3x3 SE
morph_open_close = imcomplement(morphological_open_close(img, ones(3,3)));
figure;imwrite(morph_open_close, 'Morph Open & Close 3x3.png');
imshow(morph_open_close); title('Morph Open & Close 3x3')

% Perform morphological opening & closing using a 7x7 SE
morph_open_close = imcomplement(morphological_open_close(img, ones(7,7)));
figure;imwrite(morph_open_close, 'Morph Open & Close 7x7.png');
imshow(morph_open_close); title('Morph Open & Close 7x7')
%% The impact of increasing the size of the structuring element on the output:
% Increasing the size of the SE from 3 to 7 resulted in canceling most of the 
% important segments (one-values) in the image and the result is a complete differently-structured 
% image because the original fingerprint image contained many small segments that 
% barely contained several one-values in their neighbourhood.
%%
% Test Module

% a = [1 0 0 0; 1 0 0 0; 0 1 1 0; 0 1 0 0; 0 1 0 0];
% b = [1 1]; 
% dilation = dilate(a,b)
% c = [0 1 0 0; 1 1 1 1; 0 1 0 0; 0 1 0 0; 0 1 0 0];
% d = [1 1]; 
% erosion = erode(c,d)

% Use built-in functions

% dilation = imdilate(a,b)
% erosion = imerode(a,b)
% open = imopen(a,b)
% close = imclose(a,b)

% url: https://www.mathworks.com/help/images/operations-that-combine-dilation-and-erosion.html
%% External Functions
%%
function out = dilate(img, arg2)
    % Dilation
    
[m, n] = size(img);
[x, y] = size(arg2);
img = padarray(img,[x y],0,'both');
out = zeros(m+2*x, n+2*y);

for i=1:m
    for j=1:n
        if img(i, j) == 1
            out(i:i+x-1, j:j+y-1) = bsxfun(@or, img(i:i+x-1, j:j+y-1), arg2);
        end
    end
end

end

function out = erode(img, arg2)
    % Erosion
    
[m, n] = size(img);
[x, y] = size(arg2);
img = padarray(img,[x y],0,'both');
out = zeros(m+2*x, n+2*y);

for i=1:m
    for j=1:n
        if img(i, j) == 1
            out(i:i+x-1, j:j+y-1) = min(min( bsxfun(@and, img(i:i+x-1, j:j+y-1), arg2) ));
        end
    end
end

end

function out = morphological_open_close(img, arg2)
    % Opening then closing img with the same structuring element
    
% Opening - erosion then dilation
eroded_img = erode(img, arg2);
dilated_img = dilate(eroded_img, arg2);

% Closing - dilation then erosion
dilated_img = dilate(dilated_img, arg2);
out = erode(dilated_img, arg2);

end