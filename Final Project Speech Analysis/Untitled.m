% % Load the speech signal
% % get a record from user
% % recobj=audiorecorder;
% % recDuration= 3;
% % disp('start recording..')
% % recordblocking(recobj,recDuration);
% % disp('stop recording')
% % play the record
% % play(recobj);
% % pause(recDuration);
% % 
% % get the data form the record
% % y = getaudiodata(recobj);

y= data;
fs=8000;
frameLength=160;
% Split the speech signal into frames with overlap
hopSize = round(frameLength * (1 - overlapRatio));
numFrames = floor((length(y) - frameLength) / hopSize) + 1;

% Create a matrix to store the windowed frames
frames = zeros(frameLength, numFrames);

% Apply the Hamming window to each frame
for i = 1:numFrames
    startIdx = (i - 1) * hopSize + 1;
    endIdx = startIdx + frameLength - 1;
    
    frame = y(startIdx:endIdx);
    window = hamming(frameLength);
    
    frames(:, i) = frame .* window;
end
% Assuming 'frames' contains the windowed frames

% Calculate the total length of the concatenated signal
totalLength = (numFrames - 1) * hopSize + frameLength;

% Initialize the reconstructed signal
reconstructedSignal = zeros(totalLength, 1);

% Reconstruct the signal by overlapping and adding the frames
for i = 1:numFrames
    startIdx = (i - 1) * hopSize + 1;
    endIdx = startIdx + frameLength - 1;
    
    frame = frames(:, i);
    
    reconstructedSignal(startIdx:endIdx) = reconstructedSignal(startIdx:endIdx) + frame;
end

% Perform further analysis on the windowed frames
% (e.g., Fourier Transform, feature extraction, etc.)

% Display the spectrogram of the first frame for visualization
spectrogram(frames(:, 1), hamming(frameLength/4), [], [], fs, 'yaxis');


