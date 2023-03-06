function [ v ] = corr_vec( u_n , g_n ,n_order)

v =zeros(n_order,1);
for i=0:(n_order-1)
    sum =0;
    for j =1: (length(u_n)-i)
    sum = sum + u_n(j) *g_n(j+i);   
    end
    v(i+1)=sum/(length(u_n)-i);  
end

end

