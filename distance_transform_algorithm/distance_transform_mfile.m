clear;
dolphin = imread('Dolphin.bmp');
stars = imread('Stars.bmp');

create_distance_transform(dolphin, 'chessboard');
create_distance_transform(dolphin, 'cityblock');
create_distance_transform(dolphin, 'euclidean');
create_distance_transform(stars, 'chessboard');
create_distance_transform(stars, 'cityblock');
create_distance_transform(stars, 'euclidean');

%% External Functions
%%
function create_distance_transform(arg, method)

switch method
    
    case 'chessboard'
        % Prepare image:
        tic; converted = arrayfun(@convert, arg); toc
        disp('Converted every 1 to 0 and every 0 to ?.')
        
        % First pass:
        tic; transform_kernel_tl = d8_transform_tl(converted); toc
        imwrite(uint8(transform_kernel_tl), strcat(inputname(1),'_1_chess.bmp'))
        disp('First pass success: the .bmp file is saved in the working directory.')
        
        % Second pass:
        tic; transform_kernel_br = d8_transform_br(transform_kernel_tl); toc
        imwrite(uint8(transform_kernel_br), strcat(inputname(1),'_final_chess.bmp'))
        disp('Second pass success: the .bmp file is saved in the working directory.')
        
    case 'cityblock'
        % Prepare image:
        tic; converted = arrayfun(@convert, arg); toc
        disp('Converted every 1 to 0 and every 0 to ?.')
        
        % First pass:
        tic; transform_kernel_tl = d4_transform_tl(converted); toc
        imwrite(uint8(transform_kernel_tl), strcat(inputname(1),'_1_city.bmp'))
        disp('First pass success: the .bmp file is saved in the working directory.')
        
        % Second pass:
        tic; transform_kernel_br = d4_transform_br(transform_kernel_tl); toc
        imwrite(uint8(transform_kernel_br), strcat(inputname(1),'_final_city.bmp'))
        disp('Second pass success: the .bmp file is saved in the working directory.')
        
    case 'euclidean'
        % Prepare image:
        tic; converted = arrayfun(@convert, arg); toc
        disp('Converted every 1 to 0 and every 0 to ?.')
        
        % First pass:
        tic; transform_kernel_tl = ec_transform_tl(converted); toc
        imwrite(uint8(transform_kernel_tl), strcat(inputname(1),'_1_euclidean.bmp'))
        disp('First pass success: the .bmp file is saved in the working directory.')
        
        % Second pass:
        tic; transform_kernel_br = ec_transform_br(transform_kernel_tl); toc
        imwrite(uint8(transform_kernel_br), strcat(inputname(1),'_final_euclidean.bmp'))
        disp('Second pass success: the .bmp file is saved in the working directory.')

end

end

function out = convert(arg)
    % Convert every 1 (object of interest) to 0 and every 0 to ?
if arg==0
    out=inf;
else
    out=0;
end

end

function arg = d8_transform_tl(arg)
    % top left corner D8 transform kernel
[x, y] = size(arg);
tmp = zeros(4);

for i=2:x-1
    for j=2:y
        tmp = [arg(i-1,j-1) arg(i-1,j) arg(i,j-1) arg(i+1,j-1)];
        arg(i,j) = arrayfun(@(x)min_value(tmp,x), arg(i,j));
    end
end

end

function arg = d8_transform_br(arg)
    % bottom right corner D8 transform kernel
[x, y] = size(arg);
tmp = zeros(4);

for i=x-1:-1:2
    for j=y-1:-1:1
        tmp = [arg(i-1,j+1) arg(i,j+1) arg(i+1,j) arg(i+1,j+1)];
        arg(i,j) = arrayfun(@(x)min_value(tmp,x), arg(i,j));
    end
end

end

function arg = d4_transform_tl(arg)
    % top left corner D4 transform kernel
[x, y] = size(arg);
tmp = zeros(2);
tmp2 = zeros(2);

for i=2:x-1
    for j=2:y
        tmp = [arg(i-1,j) arg(i,j-1)];
        tmp2 = [arg(i-1,j-1) arg(i+1,j-1)];
        arg(i,j) = arrayfun(@(x)min_value(tmp,x), arrayfun(@(y)min_value2(tmp2,y), arg(i,j)));
    end
end

end

function arg = d4_transform_br(arg)
    % bottom right corner D4 transform kernel
[x, y] = size(arg);
tmp = zeros(2);
tmp2 = zeros(2);

for i=x-1:-1:2
    for j=y-1:-1:1
        tmp = [arg(i,j+1) arg(i+1,j)];
        tmp2 = [arg(i-1,j+1) arg(i+1,j+1)];
        arg(i,j) = arrayfun(@(x)min_value(tmp,x), arrayfun(@(y)min_value2(tmp2,y), arg(i,j)));
    end
end

end

function arg = ec_transform_tl(arg)
    % top left corner euclidean transform kernel
[x, y] = size(arg);
tmp = zeros(2);
tmp2 = zeros(2);

for i=2:x-1
    for j=2:y
        tmp = [arg(i-1,j) arg(i,j-1)];
        tmp2 = [arg(i-1,j-1) arg(i+1,j-1)];
        arg(i,j) = arrayfun(@(x)min_value(tmp,x), arrayfun(@(y)min_value3(tmp2,y), arg(i,j)));
    end
end

end

function arg = ec_transform_br(arg)
    % bottom right corner euclidean transform kernel
[x, y] = size(arg);
tmp = zeros(2);
tmp2 = zeros(2);

for i=x-1:-1:2
    for j=y-1:-1:1
        tmp = [arg(i,j+1) arg(i+1,j)];
        tmp2 = [arg(i-1,j+1) arg(i+1,j+1)];
        arg(i,j) = arrayfun(@(x)min_value(tmp,x), arrayfun(@(y)min_value3(tmp2,y), arg(i,j)));
    end
end

end

function min_val = min_value(arr, val)
    min_val = min(val, min(arr)+1);
end

function min_val = min_value2(arr, val)
    min_val = min(val, min(arr)+2);
end

function min_val = min_value3(arr, val)
    min_val = min(val, min(arr)+1.414); % sqrt(2)=1.414
end