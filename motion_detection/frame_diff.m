function [output_image] = frame_diff(img1, img2, threshold)
    [x,y,z] = size(img1);
    
    % check if the images were not in grayscale
    if (z>1)
        img1 = rgb2gray(img1);
        img2 = rgb2gray(img2);
    end
    
    % create a matrix of zeros the same size of the original images
    output_image = zeros(x,y);
    diff = imabsdiff(img1, img2);
    
    % converting the resulted image to binary based on the passed threshold
    for i=1:x
        for j=1:y
            if(diff(i,j) > threshold)
                output_image(i,j) = 255;
            end
        end
    end
end

