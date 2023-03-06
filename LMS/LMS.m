
% Just clear
clc ; clear all ; close all;

% LMS
outer_itr = 100;
inner_itr = 500;
alpha_vec = [0.01 0.05 0.1];
W = zeros(length(alpha_vec),inner_itr,outer_itr);
e_n = zeros(length(alpha_vec),inner_itr,outer_itr);

for k = 1:outer_itr
% Generate Random noise 
v_n=sqrt(0.02)*randn(10500,1);
v_n=v_n(501:end);

% parameters of filter
a_1=[1 0.99];

%generte u_n
u_n=filter(1,a_1,v_n);

stability_bound= 2/(1*var(u_n));

for i = 1 : length(alpha_vec)

    for j=1:inner_itr-1
        e_n(i,j,k)=u_n(j)-W(i,j,k).*u_n(j+1);           
        W(i,j+1,k)=W(i,j,k)+alpha_vec(i)*u_n(j+1)*e_n(i,j,k);
    end

end
end

% Averaging
w_avr = zeros(length(alpha_vec),inner_itr);
e_avr = zeros(length(alpha_vec),inner_itr);
for i = 1 : outer_itr
w = W(:,:,i);
e =e_n(:,:,i);
w_avr = w + w_avr;
e_avr = e + e_avr;
end

% calculate avg
w_avr = w_avr ./ outer_itr ;
e_avr = e_avr ./ outer_itr;

% plotting
figure;
plot(w_avr(1,:), 'r', 'MarkerSize', 5, 'LineWidth', 0.5);
xlabel('No of Itr');
ylabel('w_avg');
title('W0');

figure;
plot(e_avr(1,:), 'b', 'MarkerSize', 5, 'LineWidth', 0.5);
xlabel('No of Itr');
ylabel('e_avg');
title('Error');

 