function [resArr] = dynamic_background_model(n, pngFiles, threshold, folder_name)

resArr = cell(1, length(pngFiles));

for i=1:length(pngFiles)
   if(i > n) % for every frame that after the first specified n reference frames
       % assign the last one of the reference frames inside a matrix
       refAvgFrame = rgb2gray(imread(strcat(folder_name ,pngFiles(i-1).name)));
       
       % then add to it the rest of the n reference frames to compute the average
       for j=i-n:i-1
           refAvgFrame = double(refAvgFrame) + double(rgb2gray(imread(strcat(folder_name,pngFiles(j).name))));
       end
       
       refAvgFrame = refAvgFrame / n;
       
       % assign the current i(th) frame inside a matrix
       currentImage = double(rgb2gray(imread(strcat(folder_name,pngFiles(i).name))));
       [x,y] = size(currentImage);
       
       % comparing the current frame and the average of the n reference frames
       frame_diff = zeros(x,y);
       diff = imabsdiff(refAvgFrame, currentImage);

       for a=1:x
           for b=1:y
               if(diff(a,b) > threshold)
                   frame_diff(a,b) = 255;
               end
           end
       end
       
       % storing the resulted difference frame
       resArr{1, i} = frame_diff;
   end
end
