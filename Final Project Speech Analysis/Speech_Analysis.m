%% 1.Get the data ready for analysis
% close all ; clear ; clc

% % get a record from user
% recobj=audiorecorder;
% recDuration= 3;
% disp('start recording..')
% recordblocking(recobj,recDuration);
% disp('stop recording')
% % play the record
% play(recobj);

% get the data form the record
data = getaudiodata(recobj);
%plot the data
plot(data)
title('original speech')
% Define the frame size
frame_time=20e-3;
Frame_size=(frame_time/recDuration)*length(data);
TX_frame=zeros(Frame_size,1);
N_frames=length(data)/Frame_size;


%% 2.Generate codebooks

% generate coodbook
    [CB_noise, CB_size] = Codebook(TX_frame , Frame_size);
    

%% 3.Start Analysis (TX)


PWR = zeros(1,N_frames);
LPC_taps = 12;
L_initial = zeros(LPC_taps,1);
S_initial = zeros(LPC_taps,1);
L_lar = zeros(LPC_taps,1);
S_lar = zeros(LPC_taps,1);
Lx_initial = zeros(LPC_taps,1);
Sx_initial = zeros(LPC_taps,1);

% Preallocate RX_data
RX_data = zeros(N_frames * Frame_size, 1);
% RX_data = 0;

%loop to simulate the data come in stream (realtime)
for i=1:N_frames
    
    % get a frame from the data
    TX_frame = data( ((i-1)*Frame_size)+1 :i*Frame_size);
    
    % Apply Hamming window to the frame
    hamming_window = hamming(Frame_size);
    TX_frame = TX_frame .* hamming_window;
    
    % Auto_Corr for frame to detect have pitch period or not
    frame= TX_frame;
    AC = xcorr(TX_frame);
    AC = AC(160:end);
    PWR(i) = sum(TX_frame.^2)/Frame_size;
    
    % Sorting pitch periods (peaks) in signal
    [~, idx] = sort(AC,'descend');
    
    % Detect pitch periods in frame 
    for j=1:length(idx)-1
        if(idx(j+1)>idx(j)+1)
            pitch = idx(j+1);
            break;
        end
    end
    
    
    % check pitch period is within average range for being voiced
    PP = ((pitch/Frame_size)*frame_time)*1e3;
    if(PP > 2.5)
        disp("voiced");
        Received = "voiced";
        
        %Long-term LPC parameters for voiced & unvoiced
        frame_x = [TX_frame(1); TX_frame(pitch-5:end)];
        L_lpc = lpc(frame_x,LPC_taps);
        L_lpc = stabilizeLPC(L_lpc);  % Stabilize LPC coefficients
        [TX_frame ,L_final ]=filter(L_lpc,1,TX_frame,L_initial);
        L_initial=L_final;
        
    end
    
    %short term lpc for both voiced and unvoiced frame
    S_lpc = lpc(TX_frame,LPC_taps);
    [TX_frame , S_final ]=filter(S_lpc,1,TX_frame,S_initial);
    S_lpc = stabilizeLPC(S_lpc);  % Stabilize LPC coefficients
    S_initial=S_final;
    AC_frame = xcorr(TX_frame);
    
    %find the minimum euclidean distance in code book noise
    ED = zeros(CB_size,1);
    for ii=1:CB_size
        ED(ii)=sum((CB_noise(:,ii)-TX_frame).^2);
    end
    
    % Sorting all distances and get index of first one 
    [~,idx1] = sort(ED);
    noise_idx = idx1(1);
    
%    % Get log area ratio of coff LPC
%     L_lar = rc2lar(L_lpc);
%     S_lar = rc2lar(S_lpc);
%     
    if(i==100)
        tt=TX_frame;
        plot(tt);
    end
    
    %T_frame= (T_frame-mean(T_frame))/(std(T_frame));
    %T_frame = 2 * (T_frame - min(T_frame)) / (max(T_frame) - min(T_frame)) - 1;
    
    % 4.Synthesis
    
    %Selected CodeBook
    RX_noise = CB_noise(:,noise_idx);
    RX_noise = sqrt(var(TX_frame)) * (RX_noise - mean(RX_noise)) / std(RX_noise) + mean(TX_frame);
    
    %inverse short lpc
    [RX_frame,Sx_final] = filter(1,S_lpc,RX_noise,Sx_initial);
    Sx_initial = Sx_final;
    
    if(Received == "voiced")
        [RX_frame,Lx_final] = filter(1,L_lpc,RX_noise,Lx_initial);
        Lx_initial = Lx_final;
    end
    
    % Store the reconstructed frame at the corresponding index
    frameStartIndex = (i - 1) * Frame_size + 1;
    frameEndIndex = i * Frame_size;
    RX_data(frameStartIndex:frameEndIndex) = RX_frame;
    
%     RX_data = [RX_data; RX_frame];
end

% Trim any excess zeros in RX_data
RX_data = RX_data(1:frameEndIndex);
 
sound(RX_data)








