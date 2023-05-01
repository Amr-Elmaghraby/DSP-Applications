%% Clear 
close all; clear all; clc; 
%% Generate Poisson Distribution
len = 100;       % length of poisson function
lambda = len/2;   % mean of the distribution
n = 1:len;        % Index for poisson distribution
pos = poisspdf(n, lambda);   % generate Poisson distribution
samples = randsample(n, len, true, pos); %samples due to poisson distribution
figure;
plot(n,pos);
figure;
plot(samples);
%% Calculate Decision boundaries and Reconstruction levels
M  = 10 ;  % number of levels
Nm_bon = M - 2; % number of decision boundaries
Delta = (max(samples) - min(samples)) / Nm_bon;  % Step size
DB = min(samples):Delta:max(samples);  % Initialize Decision boundaries as uniform destribution
y = zeros(1,M);
y(1) = min(samples);  %Define first level to be min value of samples
y(M) = max(samples);  %Define last level to be max value of samples
s_nu= zeros(1,M);     %Number of samples excist in each boundary level        
itr=10;   %% Number of iterations
MSQE =zeros(1,itr); %Mean Square Quantization Error
for u=1:itr
    for i = 2:M-1
        sum =0;   % Summing samples leying in every boundary to cal mean
        nu =0;    % number of samples per current boundary
        for j = 1:len
            if(samples(j)>DB(i-1) && samples(j) <= DB(i) ) %To get samples inside boundary
                nu = nu +1;   %Increasing nu for each sample enter if condition
                sum = samples(j) + sum; % Add value of sample to sum
            end
        end
        if(nu==0)
            y(i) = DB(i-1);    % if there's no sample isnide boundary put y to be min boundary  for this period
        else
            y(i) = sum /nu;    %cal mean of the samples in the boundary
        end
        n(i)=nu;    %put value of samples per each boundary to variable n, to contain number of samples per all peroids at the end
    end
    for i = 1:Nm_bon
        DB(i) = ( y(i) + y(i+1) ) / 2;  % Updating value of Decision boundary
    end
    [a, quan_samples]= quantiz(samples,DB,y);  % quantize samples with levels , DB that have been reached 

    for i = 1:length(samples)    
        MSQE(u) = abs(quan_samples(i) -samples(i))^2 + MSQE(u);  %Cal msqe
    end
    MSQE(u) = (MSQE(u)/length(samples));
end
zz = ((mean(samples) - MSQE(itr)) / mean(samples)) * 100; %Percentage of MSQE to mean of samples
%PLOTTING MSQE & ORIGINAL SAMPLES & QUANTIZED SAMPLES
figure;
plot(MSQE);
xlabel('index');
ylabel('MSQE values');
title('Mean Square Quantization Error');
figure;
subplot(2,1,1);
plot(samples);
xlabel('index');
ylabel('Original values');
title('Original Samples');
subplot(2,1,2);
plot(quan_samples);
xlabel('index');
ylabel('Quantized values');
title('Quantized Values');






