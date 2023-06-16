function [ R ] = corr_mtx( u_n ,n_order)
r = corr_vec(u_n,u_n,n_order);
R_size = length(r);
R=zeros(R_size);
for i =1:R_size
    for j=1:R_size
        col = j+i-1;
        if col > R_size
            continue
        end
       R(i,col)=r(j);
       R(col,i)=r(j);
    end
end
end

