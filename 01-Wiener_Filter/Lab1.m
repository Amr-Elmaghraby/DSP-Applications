clc;
close all;
clear all;
v_1 = randn(10000,1);
v_1 = sqrt(0.27)* v_1 ;
v_1 = v_1 -mean(v_1);
% plot(v_1);
v_2 = randn(10000,1);
v_2 = sqrt(0.1)* v_2 ;
v_2 = v_2 - mean(v_2);

b_1 = 1; 
a_1 = [1 -0.8458];
d_n = filter(b_1,a_1,v_1);
% figure;
% plot(d_n);

b_2 = 1;
a_2 = [1 -0.9458];
x = filter(b_2,a_2,d_n);

u_n = v_2 - x;
% figure;
% plot(u_n)


%%
J_min = zeros(1,10);
for i=1:10
    n_order =i;
    P = corr_vec(u_n,d_n,n_order);
    R = corr_mtx(u_n,n_order);
    sigma = var(d_n);
    w0 = R^(-1) * P;

    J_min(i) = sigma - dot((P.'), w0);
end

plot(J_min);



