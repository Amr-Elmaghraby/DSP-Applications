function [ v ] = corr_vec( u_n , g_n ,n_order)

% Vector that save one raw from R
v =zeros(n_order,1);

for i=0:(n_order-1)
    % Dot product between u_n but every time from frist
    % Other wise g_n every time from shifted (No. of itr)
    sum=dot(u_n(1:end-i),g_n(i+1:end));
    
    % Then Divied on there numbers
    v(i+1)=sum/(length(u_n)-i);  
end
end
