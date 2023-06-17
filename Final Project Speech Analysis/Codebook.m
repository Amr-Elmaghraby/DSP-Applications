function [CB_noise] = Codebook(Frame_size,CB_size)
%_________________________________________________________________
% Codebook That generate codebook of white noise

% inputs :
    % CB_size
    % Frame_size

% outputs :
    % CB_noise : it is coodbook noises
%_________________________________________________________________


CB_noise=zeros(Frame_size,CB_size);

for i=1:CB_size
     noise=wgn(10000,1,5e-5);
    %noise=randn(10000,1);
    CB_noise(:,i)= noise(length(noise)/2:length(noise)/2+Frame_size-1);
end

end
