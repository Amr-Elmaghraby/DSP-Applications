%% 1.Get the data ready for analysis
close all ; clear ; clc 
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
lpc_taps=12;
L_intial=zeros(lpc_taps,1);
S_intial=zeros(lpc_taps,1);
L_lar = zeros(lpc_taps,1);
S_lar = zeros(lpc_taps,1);

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
        for j=1:length(idx)-1
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
            frame_x = [ frame(1:5); frame(pitch-5:end)];
            L_lpc = lpc(frame_x,lpc_taps);
            [frame_x ,L_final ]=filter(L_lpc,1,frame_x,L_intial);
            L_intial=L_final;
            frame(1:5) = frame_x(1:5);
            frame(pitch-5:pitch+5)= frame_x(6:end);
            frame_ac=xcorr(frame);
            figure
            plot(frame_ac)
            
        end
        
        %short term lpc for both voiced and unvoiced frame 
        S_lpc = lpc(frame,lpc_taps);
        [frame , S_final ]=filter(S_lpc,1,frame,S_intial);
        S_intial=S_final;
        frame_ac=xcorr(frame);
        figure
        plot(frame_ac)
        
        % Get log area ratio of coff LPC
        L_lar = rc2lar(L_lpc);
        S_lar = rc2lar(S_lpc);
        
    end
    
    
end










