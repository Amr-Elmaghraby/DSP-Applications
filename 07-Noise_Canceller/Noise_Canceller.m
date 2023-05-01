%Clear
close all;clear all;clc;

%% First part (Noise Cancellation on audio)
% Record Audio
Fs = 48000; % sampling rate
% Create an audiorecorder object
recObj = audiorecorder(Fs, 16, 1);

% Record for 5 seconds
disp('Start speaking.');
recordblocking(recObj, 5);
disp('End of Recording.');

% Get the recorded data and plot it
d_n = getaudiodata(recObj);
plot(d_n);
sound(d_n,Fs);
pause(5);
% Record Noise
Fs = 48000; % sampling rate
% Create an audiorecorder object
recObj = audiorecorder(Fs, 16, 1);

% Record for 5 seconds
disp('Start speaking.');
recordblocking(recObj, 5);
disp('End of Recording.');

% Get the recorded data and plot it
u_n = getaudiodata(recObj);
plot(u_n);
sound(u_n,Fs);

%
W = Wiener_Filter(u_n, d_n, 11);

y_n = filter(W,1,u_n);

op = d_n - y_n;
sound(op,Fs);

%
t= linspace(0,5,Fs*5)';

plot(t,d_n);
figure;
plot(t,op);
figure;
plot(t,u_n);
ylim([-0.3 0.2]);










































%% Second part (Chirp signal)

% Generate Chirp signal
% Define the chirp parameters
f0 = 0; % starting frequency in Hz
f1 = 150; % ending frequency in Hz
t = linspace(0, 1, 10000); % time vector

% Generate the chirp signal using the 'chirp' function
s_n = chirp(t, f0, 1, f1, 'linear');

% Plot the chirp signal
plot(t, s_n);
xlabel('Time (s)');
ylabel('Amplitude');
title('Chirp Signal');
s_n = s_n';

% Generate u_n , v_n 
% Define u_n
u_n = randn(10500,1);
u_n = u_n(501:end);
u_n= u_n - mean(u_n);

% define half-band LPF
order = 10;
half_LPF = fir1(order,0.5);
% filter u_n 
v_n = filter(half_LPF,1,u_n); 

% Add v_n to the chirp signal 
d_n = s_n + v_n; 

%% Wiener Filter
n_order = 11;
[Wiener_W, Wiener_J_min] = Wiener_Filter(u_n , d_n ,n_order);

%% Steepest Descent 
% Number of iteration
itr = 4000;
[ Steepest_Descent_W, Steepest_Descent_J ,stb, alpha] = Steepest_Descent( u_n , d_n ,n_order,itr ,0.001);
Steepest_J_min = min(Steepest_Descent_J);

%% LMS 
LMS_av = zeros(11,100);
%Averaging over 100 iterations
itr_LMS = 100;
for i = 1:itr_LMS
    %define u_n
    u_n_lms = randn(10500,1);
    u_n_lms = u_n_lms(501:end);
    u_n_lms = u_n_lms - mean(u_n_lms);

    % define half-band LPF
    half_LPF = fir1(order,0.5);
    % filter u_n 
    v_n_lms = filter(half_LPF,1,u_n_lms); 

    % Add v_n to the chirp signal 
    d_n_lms = s_n + v_n_lms; 
    
    % LMS filter
    LMS_av(:,i) = LMS(u_n_lms, d_n_lms, n_order);
end
% averaging 
LMS_W = zeros(11,1);
for i=1:itr_LMS
    LMS_W = LMS_av(:,i) + LMS_W;
end
LMS_W = LMS_W / itr_LMS ;

























