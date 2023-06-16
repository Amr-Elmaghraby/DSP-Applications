%% 1.Get the data ready for analysis

% get a record from user
recobj=audiorecorder;
recDuration= 3;
disp('start recording..')
recordblocking(recobj,recDuration);
disp('stop recording')
% play the record
play(recobj);
% get the data form the record
data = getaudiodata(recobj);
%plot the data 
plot(data)
title('original speech')
% Define the frame size
frame_time=20e-3;
frame_size=(frame_time/recDuration)*length(data);
frame=zeros(frame_size,1);
n_frames=length(data)/frame_size;

%% 2.Start Analysis

%loop to simulate the data come in stream (realtime)
zcr=zeros(1,n_frames);

for i=0:n_frames
    
    % get a frame from the data
    frame=data( (i*frame_size)+1 :(i+1)*frame_size);
    
    zcr(i)=zerocrossrate(frame);
    
    % decide whether the frame is voiced or unvoiced
    
    
    
    
   
    
    
    
    
end    

