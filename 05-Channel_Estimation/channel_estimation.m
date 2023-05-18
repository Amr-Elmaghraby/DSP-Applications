% generate random noise v_n 
u_n=randn(10500,1);
u_n=u_n(501:end); 
 n_order=10;
% get desired signal d_n
% define the impulse response of the filter
h_n=zeros(9,1);

 h_n=[2.0000, -0.1000, 1.4500, -0.2170, 1.0657, -0.2628, 0.7936, -0.2686, 0.5982, 0.2532].';
d_n=zeros(10000,1); 




% %method 2
%  d_n=conv(u_n,h_n); 
%  d_n =d_n(1:end-9);
 
% method 3
% insert 9 zeros at the begining of the u_n as initial conditions for u_n(1)
u_n=[zeros(9,1); u_n];
 for i=1:length(u_n)-9
     d_n(i)=dot(h_n,u_n(i:i+9));
     
 end  
 %remove the initial conditions
 u_n=u_n(10:end);



%% Weiner Solution

[w_wiener, J_wiener]=Wiener_Filter(u_n,d_n,n_order); 

%% Steepest Decent solution 

iteration=10000;
Mu_vec=[0.01,0.005,0.0015];

w_steepest=zeros(n_order,length(Mu_vec));
J_steepest=zeros(1,length(Mu_vec));

str_mu=["mu=0.01","mu=0.005","mu=0.0015"];
figure 

for i=1:length(Mu_vec)
    [w_steepest(:,i),J_steepest(i),J_vec]=Steepest_Descent(u_n,d_n,n_order,iteration,Mu_vec(i));
    plot(J_vec,'DisplayName',str_mu(i))
    hold on 
end
title('learning curve for steepest descent')
legend()
hold off

%% LMS solution
indep_runs=100;
W_LMS=zeros(n_order,indep_runs);
W_avr_LMS=zeros(n_order,1);
for i=1:100
    %generate u_n
    u_n=randn(10500,1);
    u_n=u_n(501:end);
    %generate d_n
    u_n = [zeros(9,1); u_n];
     for j=1:length(u_n)-9
         d_n(j)=dot(h_n,u_n(j:j+9));

     end  
     %remove the initial conditions
     u_n=u_n(10:end);
%     method 2
%      d_n=conv(u_n,h_n); 
%      d_n =d_n(1:end-9);
     
     
    W_LMS(:,i)=LMS(u_n,d_n,n_order,10000,0.01);
    W_avr_LMS=W_avr_LMS+W_LMS(:,i);
    
    
    
end 
W_avr_LMS=W_avr_LMS ./ 100;

%compare between solutions

figure
 stem(h_n,'*','DisplayName','original channel')
 hold on
 stem(w_wiener,'DisplayName','wiener estimation')
 hold on 
 stem(w_steepest(:,1),'>','DisplayName','Steepest estimation')
 hold on 
 stem(W_avr_LMS ,'^','DisplayName','LMS estimation')
  legend() 
figure
freqz(W_avr_LMS,1)
figure
freqz(h_n,1)

























