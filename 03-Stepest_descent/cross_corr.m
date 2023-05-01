function [seg_sum] = cross_corr( u_n , d_n ,n_order)

seg_sum = zeros(n_order , 1);

for i = 0 : (length(u_n) - n_order)
    seg = u_n(i+1 : n_order + i );
    scaler = d_n(n_order + i);
    % Get vector segment
    seg = seg * scaler ; 
    % Sum all vectors
    seg_sum = seg_sum + seg ;
end

% Divided by length
seg_sum = seg_sum / (length(u_n) - n_order) ;

end

