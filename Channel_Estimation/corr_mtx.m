function [R] = corr_mtx(u_n,n_order)

% Vector that save one raw from R
r =zeros(n_order,1);

for i=0:(n_order-1)
    % Dot product between u_n but every time from frist
    % Other wise g_n every time from shifted (No. of itr)
    sum=dot(u_n(1:end-i),u_n(i+1:end));
    
    % Then Divied on there numbers
    r(i+1)=sum/(length(u_n)-i);  
end

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

