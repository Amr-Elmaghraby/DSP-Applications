function [W0, J_min] = Wiener_Filter( u_n , d_n ,n_order)

% get sigma
sigma = var(d_n);

%% Calculate R

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

%% Calculate P
P = zeros(n_order , 1);
for i = 0 : (length(u_n) - n_order)
    seg = u_n(i+1 : n_order + i );
    scaler = d_n(n_order + i);
    % Get vector segment
    seg = seg * scaler ;
    % Sum all vectors
    P = P + seg ;
end

% Divided by length
P = P / (length(u_n) - n_order ) ;

%% Calculate OPtimal value of W
W0 = R^(-1) * P;

%% Calculate J min
J_min = sigma - dot((P.'), W0);
end

