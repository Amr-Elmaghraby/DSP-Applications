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
PWR=zeros(1,n_frames);

for i=1:n_frames
 
    % get a frame from the data
    frame=data( ((i-1)*frame_size)+1 :i*frame_size);
    AC = xcorr(frame);
    AC= AC(160:end);
    if(i==100)
        PWR(i)=sum(frame.^2);
        [~, idx] = sort(AC,'descend');
        plot(AC);
        figure;
        plot(frame);
        for j=1:length(idx)
            if(idx(j+1)>idx(j)+1)
                pitch = idx(j+1);
                break;
            end
        end 

 
        % check pitch period is within average range for being voiced  
        pitch_T = ((pitch/frame_size)*frame_time)*1e3;
        if(pitch_T>2.5) 
            disp("voiced");
            %Long-term LPC parameters for voiced & unvoiced
            x= [frame(1) frame(pitch:end)];
            L_LPC = lpc(x,12);
            z=filter(L_LPC,1,frame);
            w=xcorr(z);
            S_LPC= lpc(frame,12);
            z2 = filter(S_LPC,1,z);
            w2=xcorr(z2);
            
        else
            disp("Unvoiced");
            S_LPC= lpc(frame,12);
        end
            
        break;
    end
    % decide whether the frame is voiced or unvoiced
    
end


%%
plot(w(160:end));
figure;
plot(w2(160:end));






