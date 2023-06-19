function [frame] = Hamming_Window(y,hopSize,frameLength,i)
%_________________________________________________________________
%Applying hamming window to the speech data

% inputs :
    % data
    % hopSize
    % frameLength
    % idx of iteration 

% outputs :
    % frame : block of the data
%_________________________________________________________________

% Apply the Hamming window to each frame

% Calculate the starting index of the current frame
startIdx = (i - 1) * hopSize + 1;  
% Calculate the ending index of the current frame
endIdx = startIdx + frameLength - 1;
% Extract the current frame from the signal
frame = y(startIdx:endIdx);  
% Create a Hamming window of length frameLength
window = hamming(frameLength);  
% Apply the Hamming window to the frame
frame = frame .* window;  


end

