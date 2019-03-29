clear all; clc;

% load the input image
x = imread('sample.png');

%Define Parameters
K = 3;  % # of color clusters
nPixels = size(x,1)*size(x,2);    % # of pixels
maxIterations = 3; %maximum number of iterations allowed for EM algorithm.
nColors = 3;
e = 2.17;

%reshape the image into a single vector of pixels for easier loops
pixels = reshape(x,nPixels,nColors,1);
pixels = double(pixels);

% initialize probs vector and mu mat
probs = ones(1,K); 
mu = ones(1,K);
        
% declare mu input values
for j = 1:K
    if(mod(j,2)==1)
        increment = normrnd(0,.0001);
    end
    for k = 1:nColors
        if(mod(j,2)==1)
            mu(j,k) = mean(pixels(:,k)) + increment;
        else
            mu(j,k) = mean(pixels(:,k)) - increment;
        end
        if(mu(j,k) < 0)
            mu(j,k) = 0;
        end
    end
end

last_mu = mu;
last_probs = probs;

for iteration = 1:maxIterations
    
    disp('iteration: ');
    disp(iteration);
    
   % E-Step    
    
    % Weights that describe the likelihood that probsxel "i" belongs to a color cluster "j"
    w = ones(nPixels,K);  % temporarily reinitialize all weights to 1, before they are recomputed
    
    for i = 1:nPixels
        % Calculate Ajs
        logAjVec = zeros(1,K);
        for j = 1:K
            logAjVec(j) = log(probs(j)) - .5*((pixels(i,1)-mu(j,:))*((pixels(i,1)-mu(j,:)))');
        end
        
        % the max of the three classes for every pixel
        [logAmax,ind] = max(logAjVec(:));
        
        % Calculate the third term from the final eqn in the above link
        thirdTerm = 0;
        for l = 1:K
            thirdTerm = thirdTerm + exp(logAjVec(l)-logAmax);
        end
        
        % Calculate weights(i,j)
        for j = 1:K
            logY = logAjVec(j) - logAmax - log(thirdTerm);
            w(i,j) = exp(logY);
        end
    end
    
    % M-Step
    
    % temporarily reinitialize mu and probs to 0, before they are recomputed
    mu = zeros(K,nColors);
    probs = zeros(K,1);
    
    % new probs and meus
    for j = 1:K
        
        denominatorSum = 0;
        for i = 1:nPixels
            mu(j,:) = mu(j,:) + pixels(i,:).*w(i,j);
            denominatorSum = denominatorSum + w(i,j);
        end
        
        % Update mu
        mu(j,:) =  mu(j,:) ./ denominatorSum;
        
        % Update probs
        probs(j) = sum(w(:,j)) / nPixels;
    end
    
    disp('The new probabilites for each class: ');
    disp(probs');
    
    muDiffSq = sum(sum((mu - last_mu).^2));
    probsDiffSq = sum(sum((probs - last_probs).^2));
    
    if (muDiffSq < e && probsDiffSq < e)
        disp('Convergence criteria met at iteration: ');
        disp(iteration);
        break;
    end
    
    last_mu = mu;
    last_probs = probs;    
    
    % draw the segmented image using the mean of the color cluster such as the
    % pixel value for all pixels in that cluster.
    
    segpixels = pixels;
    cluster = 0;
    for i = 1:nPixels
        cluster = find(w(i,:) == max(w(i,:)));
        segpixels(i,:) = (mu(cluster,:));
    end
    
    segpixels = reshape(segpixels,size(x,1),size(x,2),nColors);
    segpixels = segpixels ./255; %normalize each pixel value
    imwrite(segpixels, 'segmented_img.png');
    
end

disp('The segmented image is saved at the path of this file.');