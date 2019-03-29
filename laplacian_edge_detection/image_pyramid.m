clear;
img = imread('cameraman.tif');

% Gussian Filter
g_filtered = imgaussfilt(img, 1.6, 'FilterSize', 5);
figure; imshow(g_filtered)
title('Gaussian-filtered Cameraman')
m_pyramid(g_filtered, 'gaussian')

% Average Filter
m_filtered = uint8(mean_filter(img, 3));
figure; imshow(m_filtered)
title('Mean-filtered Cameraman')
m_pyramid(m_filtered, 'mean')

% Laplacian Filter
laplacian_pyramid(g_filtered, 'laplacian');
%% External Functions
%%
function m_pyramid(arg, arg2)

[x, y] = size(arg);

if x~=y
    error('Image is not square.');
end

out = uint8(impyramid(arg, 'reduce'));
imwrite(out, strcat(arg2, int2str(x/2), 'x', int2str(x/2),'.bmp'));
disp(strcat(arg2, int2str(x/2), 'x', int2str(x/2),'.bmp'))
disp('Saved in the working directory.')

if size(out, 1) > 1
    m_pyramid(out, arg2)
end

end

function out = mean_filter(arg, kernel_size)

kernel = ones(kernel_size, kernel_size) ./ (kernel_size*kernel_size);
out = conv2(arg, kernel, 'same');

end

function laplacian_pyramid(arg, arg2)

[x, y] = size(arg);

if x~=y
    error('Image is not square.');
end

reduced = uint8(impyramid(arg, 'reduce'));
upsampled = uint8(imresize(reduced,[x y]));
out = arg - upsampled;

imwrite(out, strcat(arg2, int2str(x/2), 'x', int2str(x/2),'.bmp'));
disp(strcat(arg2, int2str(x/2), 'x', int2str(x/2),'.bmp'))
disp('Saved in the working directory.')

if size(out, 1) > 1
    laplacian_pyramid(reduced, arg2)
end

end