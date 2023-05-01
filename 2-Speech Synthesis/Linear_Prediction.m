% %% Code 1 Of speech Synthsis with Linear Filter

% Clear all
clc ; clear all ; close all ;
 
% % Load speech signal
% [y, Fs] = audioread('Recording (8).m4a');

% % Segment length in seconds
% seg_len_sec = 0.015;
 
% % LPC order
% p = 10;
 
% % Compute segment length in samples
% seg_len = round(seg_len_sec * Fs);
 
% % Number of segments
% num_seg = floor(length(y) / seg_len);
 
% % Initialize synthesized speech signal
% y_syn = zeros(length(y));
 
 
% % Loop through each segment
% for i = 1:seg_len:length(y)-seg_len
%     % Extract current segment
%     seg = y((i-1)*seg_len+1:i*seg_len);
%     % Compute LPC coefficients
%     a = lpc(seg, p);
%     if i == 1 
%         %Initial value for segments
%         zi = zeros(max(length(a),length(1))-1) ;
%     end
%     % Get Estimation Value Fm
%     [zf , est_val] = filter(a,1,seg);
%     % Make Initial for next seg is final from current seg 
%     zi = zf ;
%     % Synthesize speech using LPC coefficients
%     seg_syn = filter(1, a , seg);
%     % Add synthesized segment to output signal
%     y_syn((i-1)*seg_len+1:i*seg_len) = seg_syn;
% end

 
% figure
% % Plot the first set of data in the first subplot
% subplot(1,2,1)
% plot(y)
% title('Plot 1')

% % Plot the second set of data in the second subplot
% subplot(1,2,2)
% plot(y_syn)
% title('Plot 2')
% Load speech signal
[y, Fs] = audioread('Recording (8).m4a');

% Segment length in seconds
seg_len_sec = 0.015;

% LPC order
p = 10;

% Compute segment length in samples
seg_len = round(seg_len_sec * Fs);

% Number of segments
num_seg = floor(length(y) / seg_len);

% Initialize synthesized speech signal
y_syn = zeros(size(y));

% 
zi_1 = 0 ;
zi_2 = 0 ;

seg_analysis_vec = zeros(num_seg,1);
a_vec = zeros(num_seg,1);

% Loop through each segment
for i = 1:seg_len:length(y)-seg_len
    
    % Extract current segment
    seg = y((i-1)*seg_len+1:i*seg_len);
    % Compute LPC coefficients
    a = lpc(seg, p);
    %analysis speech using LPC coefficients 
    [seg_analysis , zf_1] = filter(a, 1, seg , zi_1);
    % Save zi
    zi_1 = zf_1 ;
    
    % Save Vectors
    seg_analysis_vec(i) = seg_analysis;
    a_vec(i) = a;
     
end



    % Synthesize speech using LPC coefficients
    [seg_syn , zf_2] = filter(1 , a , seg_analysis);
    x = length(seg_syn);
    y = length(y_syn((i-1)*seg_len+1:i*seg_len));
    Add synthesized segment to output signal
    y_syn((i-1)*seg_len+1:i*seg_len) = seg_syn;   

figure
% Plot the first set of data in the first subplot
subplot(1,2,1)
plot(y)
title('Plot 1')

% Plot the second set of data in the second subplot
subplot(1,2,2)
plot(y_syn)
title('Plot 2')
% Write synthesized speech to file
% audiowrite('speech_synthesized.wav', y_syn, Fs);

%% Code 2 Of speech Synthsis with Linear Filter

clc ; clear all ; close all ;

% Load speech signal
[y, Fs] = audioread('Recording (8).m4a');

% Segment length in seconds
seg_len_sec = 0.015;

% LPC order
p = 10;

% Compute segment length in samples
seg_len = round(seg_len_sec * Fs);

% Extract single segment
seg_start = 10000;
seg_end = seg_start + seg_len - 1;
seg = y(seg_start:seg_end);

% Compute LPC coefficients
a = lpc(seg, p);

% Get Estimation Value Fm
est_x = filter(a,1,seg);
% e = seg - est_x;
[acs,lags] = xcorr(est_x,'coeff');

figure;
plot(lags,acs)
grid
xlabel('Lags')
ylabel('Normalized Autocorrelation')
ylim([-0.1 1.1])

% Synthesize speech using LPC coefficients
seg_syn = filter(1, a, est_x);

% Plot original and synthesized speech
t = (0:length(seg)-1)/Fs;

figure;
subplot(2,1,1);
plot(t, seg);
title('Original Speech Segment');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, seg_syn);
title('Synthesized Speech Segment');
xlabel('Time (s)');
ylabel('Amplitude');
% 
% subplot(3,1,3);
% plot(a);
% title('LPC Paramters');



