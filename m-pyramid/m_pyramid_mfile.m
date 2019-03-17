clear; cameraman = imread('cameraman.tif');
m_pyramid(cameraman);

%% External Functions

function m_pyramid(arg)

[x, y] = size(arg);

if x~=y
    error('Image is not square.');
end

m = arg;

for i=1:log2(x)
    m = uint8(m(1:2:end, 1:2:end));
    imwrite(m, strcat('m', int2str(i),'.bmp'));
end

disp('8 images are saved in the working directory.')

end