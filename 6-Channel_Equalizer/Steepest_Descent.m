function [ W, J ,stb, alpha] = Steepest_Descent( u_n , d_n ,n_order,itr ,alpha)
 
% Calculate R, P
R = corr_mtx(u_n,n_order);
P = cross_corr(u_n,d_n,n_order);
sigma = var(d_n);
stb = 2/(max(eig(R)));
if(nargin<=4)
    alpha = stb/2;
end
%% Calculate W, J recursivly
% set w intial values to zeros
W_init = zeros(n_order , 1);
% set W to w_init at first
W = W_init ;
J = zeros(itr,1);
% iteration loop
for j = 1 : itr
    W = W + alpha * (P - R * W);
    J(j) = sigma - (W.' * P) - (P.' * W) + ( W.' * R * W) ;
end
end

