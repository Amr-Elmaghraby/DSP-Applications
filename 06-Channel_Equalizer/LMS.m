function [ W, e, alpha ] = LMS( u_n, d_n, n_order, alpha)

stability_bound= 2/(n_order *var(u_n));
if(nargin <=3)
    alpha = stability_bound /10;
end
inner_itr = length(u_n);
W = zeros(n_order, 1);

for i=1:inner_itr-n_order+1
    e_n = d_n(i+n_order-1) - dot(W, u_n(i:i+n_order-1));
    W = W + alpha * u_n(i:i+n_order-1) .* e_n;
end
e=e_n^2;
end

