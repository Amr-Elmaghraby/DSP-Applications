% Read in the grayscale image
data = imread('gray2.jpg'); 

% Create a new figure with 2 rows and 2 columns of subplots
figure
subplot(2, 2, 1)

% Display the original image in the first subplot
imshow(data)
title('original');

% Loop over different values of n which represent the number of bits
dataq = data;
    
for n = 1:3
    
    % Calculate the number of levels and the step size for this iteration
    L = 2^n;
    stepSize = 255 / L;  
    
           
    % Determine the index of the nearest level 
    level_index = floor(double(data) ./ stepSize);
            
    % Set the  value to the nearest level
    dataq = uint8(level_index .* stepSize); 
      
    
    % Display the quantized image in the subplot
    subplot(2, 2, 1 + n)   
    imshow(dataq)
    title(['Quantized Image (n=' num2str(n) ')']);
    
end


