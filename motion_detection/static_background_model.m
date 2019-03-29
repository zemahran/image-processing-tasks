function [resArr] = static_background_model(refFrame, pngFiles, threshold, folder_name)

resArr = cell(1, length(pngFiles));

for i=1:length(pngFiles)
   currentImage = rgb2gray(imread(strcat(folder_name, pngFiles(i).name)));
   [x,y] = size(currentImage);
   
   % comparing the current frame and the reference frame
   frame_diff = zeros(x,y);
   diff = imabsdiff(refFrame, currentImage);
   
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

