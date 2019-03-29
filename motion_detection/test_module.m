% 1.1 Frame Difference Test

% Load images
img1 = imread('frame1.jpg');
img2 = imread('frame2.jpg');
% showing the difference frame
imshow(uint8(frame_diff(img1,img2,30)));


% 1.2a Static Background Modeling Test

% Load your sequence of images
folder_name = 'C:\Users\Yomna\Desktop\sem 9\avp_dataset\';
pngFiles = dir(fullfile(folder_name, '*.jpg'));
% Load your reference frame
refFrame = rgb2gray(imread(strcat(folder_name, pngFiles(1).name)));

result_array = static_background_model(refFrame, pngFiles, 45, folder_name);
% showing the difference frames for the first dataset
for i=1:5
    figure, imshow(result_array{1,i});
end

% Load another sequence of images
folder_name2 = 'C:\Users\Yomna\Desktop\sem 9\my_avp_dataset\';
pngFiles2 = dir(fullfile(folder_name2, '*.png'));
% Load your reference frame
refFrame2 = rgb2gray(imread(strcat(folder_name2, pngFiles2(1).name)));

result_array2 = static_background_model(refFrame2, pngFiles2, 150, folder_name2);
% showing the difference frames for the second dataset
for i=1:5
    figure, imshow(result_array2{1,i});
end


% 1.2b Dynamic Background Modeling Test

result_array3 = dynamic_background_model(5, pngFiles, 40, folder_name);
result_array4 = dynamic_background_model(7, pngFiles2, 130, folder_name2);
% showing the difference frames for the first dataset
for i=50:54
    figure, imshow(result_array3{1,i});
end
% showing the difference frames for the second dataset
for i=16:20
    figure, imshow(result_array4{1,i});
end

% for testing, change the i interval based on the number of reference frames passed
% such that the start >= n+1, this is because any index before n will be unassigned
% also make sure the end is <= the number of images in your image sequence - 1
