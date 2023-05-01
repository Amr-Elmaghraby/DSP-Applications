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

% Calculate W , j_min with Direct Method
n_order = 4 ;

P = cross_corr(u_n,d_n,n_order);
R = corr_mtx(u_n,n_order);
sigma = var(d_n);

W0 = R^(-1) * P;
J_min = sigma - dot((P.'), W0);


% Calculate with recursive iteration
W_init = zeros(n_order , 1);
alpha_vec = [0.1 0.2 0.3 0.4 0.5];

J = zeros( length(alpha_vec) , 100);
W = zeros( n_order , length(alpha_vec) );

colors=["red","blue","g","magenta","black"];
style=["-","--","-","-.","-"];

figure;
for i = 1 : length(alpha_vec)   
    % get current alpha value
    alpha = alpha_vec(i);
    W(: , i) = W_init ;
    for j = 1 : 100 
    W(: , i) = W(: , i) + alpha * (P - R * W(: , i));
    J(i,j) = sigma - (W(: , i).' * P) - (P.' * W(: , i)) + ( W(: , i).' * R * W(: , i)) ;
    end
    
    plot(J(i , :),style(i),'Color',colors(i))
    hold on
    
end
legend('Mu=0.1','Mu=0.2','Mu=0.3','Mu=0.4','Mu=0.5')
