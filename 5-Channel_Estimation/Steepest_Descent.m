function [ W,J_min, J ,alpha] = Steepest_Descent( u_n , d_n ,n_order,itr ,alpha)
%define J vector
J=zeros(1,itr); 
% Calculate R, P
R = corr_mtx(u_n,n_order);
P = cross_corr(u_n,d_n,n_order);
sigma = var(d_n);
if(nargin<=4)
    alpha = 2/(2*max(eig(R)));
end
%% Calculate W, J recursivly
% set w intial values to zeros
W_init = zeros(n_order , 1);
% set W to w_init at first
W = W_init ;
% iteration loop
for j = 1 : itr
    W = W + alpha * (P - R * W);
    J(j) = sigma - (W.' * P) - (P.' * W) + ( W.' * R * W) ;
end
    J_min=J(itr);
    
end

