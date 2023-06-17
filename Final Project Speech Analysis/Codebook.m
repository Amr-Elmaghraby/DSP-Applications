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
<<<<<<< HEAD
=======
    %noise=randn(10000,1);
>>>>>>> 20c399cc1de25542a5a6c9dcb4cd92d0ba1f6b18
    CB_noise(:,i)= noise(length(noise)/2:length(noise)/2+Frame_size-1);
end

end
