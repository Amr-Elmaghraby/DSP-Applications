% Just clear
clc  ; clear all ; close all ;

% Specifiy some attributes
filter_size = 10000; 
variance_val_1 = 0.27;
variance_val_2 = 0.1;

%Generate Noise
v_1 = randn(filter_size + 500 , 1);
v_1 = v_1(501:end) * sqrt(variance_val_1) ; 
v_2 = randn(filter_size + 500 , 1) * sqrt(variance_val_2);
v_2 = v_2(501:end);

% numerator and denomirator 
b_1 = 1 ;
a_1 = [1 0.8458];
b_2 = 1 ;
a_2 = [1 -0.9458];

% create Filter for d_n
d_n = filter( b_1 , a_1 , v_1 );

%create filter for u_n
u_n = v_2 - filter( b_2 , a_2 , d_n );

% Calclations for optimum value
J_min = zeros(10,1);

% get sigma
sigma = var(d_n);

for i = 1:10
  
    n_order = i ;
    
    % Calculate R , P
    P = cross_corr(u_n,d_n,n_order);
    R = corr_mtx(u_n,n_order);
    
    %Calculate OPtimal value of W
    W0 = R^(-1) * P;
    
    % Calculate J min
    J_min(i,1) = sigma - dot((P.'), W0);
end

% Plotting
figure;
plot(J_min, 'r-o', 'MarkerSize', 5, 'LineWidth', 1.5);

% Add labels and title
xlabel('No of samples');
ylabel('J');
title('Cost Func');
