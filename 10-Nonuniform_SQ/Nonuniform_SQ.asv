%% Clear 
close all; clear all; clc; 
%% Generate Poisson Distribution
len = 100;       % length of poisson function
lambda = len/2;   % mean of the distribution
n = 1:len;        % Index for poisson distribution
pos = poisspdf(n, lambda);   % generate Poisson distribution
samples = randsample(n, 10*len, true, pos); %samples due to poisson distribution
figure;
plot(n,pos);
figure;
plot(samples);
%% Calculate Decision boundaries and Reconstruction levels
M  = 100 ;  % number of levels
Nm_bon = M - 2; % number of decision boundaries
Delta = (max(samples) - min(samples)) / Nm_bon;  % Step size
DB = min(samples):Delta:max(samples);  % Initialize Decision boundaries as uniform destribution
y = zeros(1,M);
y(1) = min(samples);
y(M) = max(samples);
n= zeros(1,M);
we=100;
zzz =zeros(1,we);
for u=1:we
    for i = 2:M-1
        sum =0;
        nu =0;
        for j = 1:len
            if(samples(j)>DB(i-1) && samples(j) <= DB(i) )
                nu = nu +1;
                sum = samples(j) + sum;
            end
        end
        if(nu==0)
            y(i) = DB(i-1);
        else
            y(i) = sum /nu;
        end
        n(i)=nu;
    end
    for i = 1:Nm_bon
        DB(i) = ( y(i) + y(i+1) ) / 2;
    end


    [a, zz]= quantiz(samples,DB,y);

    for i = 1:length(samples)    
        zzz(u) = zz(i) -samples(i) + zzz(u);
    end
    zzz(u) = (zzz(u)/length(samples))^2;


end

plot(zzz);







