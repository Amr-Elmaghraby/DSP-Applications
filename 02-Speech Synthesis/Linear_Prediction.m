%% Code 1 Of speech Synthsis with Linear Filter

clc ; clear; close all ;

% Load speech signal
[y, Fs] = audioread('Recording (24).m4a');

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
title('LPC Paramters');

%% Code 2 Of speech Synthsis with Linear Filter
clc; 
clear;
close all;

% Load speech signal
[y, Fs] = audioread('Recording (24).m4a');

% Segment length in seconds
seg_len_sec = 0.015;

% LPC order
p = 10;

% Compute segment length in samples
seg_len = round(seg_len_sec * Fs);

% Compute the number of segments
num_segments = floor(length(y) / seg_len);

% Initialize synthesized speech
synthesized = zeros(size(y));

% Run sound before synthesized segments
sound(y, Fs);
% Pause for a short duration between segments
pause(8);

for i = 1:num_segments
    % Extract segment
    seg_start = (i - 1) * seg_len + 1;
    seg_end = i * seg_len;
    seg = y(seg_start:seg_end);

    % Compute LPC coefficients
    a = lpc(seg, p);

    % Get Estimation Value Fm
    est_x = filter(a, 1, seg);
    [acs, lags] = xcorr(est_x, 'coeff');
    
    % Synthesize speech using LPC coefficients
    seg_syn = filter(1, a, est_x);
    
    % Update synthesized speech with the current segment
    synthesized(seg_start:seg_end) = seg_syn;
end

% Plot original and synthesized speech for the entire record
t = (0:length(y)-1) / Fs;

figure;
subplot(2, 1, 1);
plot(t, y);
title('Original Speech');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, synthesized);
title('Synthesized Speech');
xlabel('Time (s)');
ylabel('Amplitude');

% Run sound for the synthesized speech
sound(synthesized, Fs);




