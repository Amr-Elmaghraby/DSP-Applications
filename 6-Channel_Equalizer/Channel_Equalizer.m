%CLEAR
clear all; close all; clc; 

%size of samples
sz = 10000;
% define number of tabs for adaptive filters
n_order = 7;
% loop with 100 averages for LMS
avr =100;
% initialize input & desired
u_n = zeros(sz,avr);
d_n = zeros(sz,avr);
for m=1:avr
    % Generate 1st random noise 'INPUT'
    x_n = 2*randi([0,1],10500,1) - 1 ;
    x_n = x_n(501:end);
    %generate 2nd random noise
    v_n = sqrt(5.0509e-5)*randn(10500,1);
    v_n = v_n(501:end);
    
    %Calculating Channel impulse response
    n = 0:10;
    causal_delay = 5;
    h_n = 1./(1+(n-causal_delay).^2);
    %plotting channel impulse response
    if(m==1)
        figure('Name','Channel Impulse Response');title('Impulse Response');
        stem(n,h_n);
        xlabel('n');
        ylabel('h(n)');
    end
    % figure;
    % h=fftshift(fft(h_n));
    % h = 20*log(h);
    % f=-2.5:0.5:2.5;
    % plot(f,h);
    
    %channel ISI effect (InterSymbol Interference)
    i_n = conv(x_n,h_n);
    i_n = i_n(1:end-10); %%COMMENT
    %%UNCOMMENT i_n = i_n(1+causal_delay:end-causal_delay);
    
    %Adding noise
    u_n(:,m) = i_n + v_n;
    
    %Adding delay to input
    %%UNCOMMENT d_n((1+(n_order-1)/2):end,m)=x_n(1:end-((n_order-1)/2));
    d_n((1+((n_order-1)/2)+(length(n)-1)/2):end,m)=x_n(1:end-(((n_order-1)/2)+(length(n)-1)/2)); %%COMMENT
end
%% Wiener Filter
[W_wiener, J_wiener] = Wiener_Filter(u_n(:,1),d_n(:,1),n_order);

%% Steepest Descent 

itr = 10000;
alpha_vec = [0.001 0.005 0.01];
W_steepest = zeros(n_order,length(alpha_vec));
% value of j after each iteration
J_plot = zeros(length(alpha_vec),itr);
% value of j after last iteration(MMSE)
J_steepest = zeros(length(alpha_vec),1);
figure('Name','Steepest Descent MMSE (J)');
colors={'red','blue','black'};
for i= 1:length(alpha_vec)
    [W_steepest(:,i), J_plot(i,:)] = Steepest_Descent(u_n(:,1),d_n(:,1),n_order,itr,alpha_vec(i));
    J_steepest(i) = J_plot(i,itr);
    plot(1:itr,J_plot(i,:),'color',sprintf('%c',char(colors(i))));
    xlabel('itr');
    ylabel('MMSE J');hold on;
end
legend('meu=0.001','meu=0.005','meu=0.01');

%% LMS
% initialize tabs value 'with average'
W_LMS = zeros(n_order,length(alpha_vec));

for i=1:length(alpha_vec)
    for j=1:avr
         [W_n] = LMS(u_n(:,j),d_n(:,j),n_order);
          W_LMS(:,i)=W_LMS(:,i)+W_n;
    end
end
% divide by averaging number
W_LMS = W_LMS ./ avr;











