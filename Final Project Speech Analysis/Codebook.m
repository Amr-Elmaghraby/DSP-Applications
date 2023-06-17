function [CB_noise, CB_size] = Codebook(TX_frame,Frame_size)
%_________________________________________________________________
% Codebook That generate codebook of white noise

% inputs :
    % TX_frame
    % Frame_size

% outputs :
    % CB_noise : it is coodbook noises
%_________________________________________________________________

CB_size = 1024;
CB_noise=zeros(length(TX_frame),CB_size);

for i=1:CB_size
    noise=randn(10000,1);
    noise = sqrt(var(TX_frame)) * (noise - mean(noise)) / std(noise) + mean(TX_frame);
    %   noise= 2 * (noise - min(noise)) / (max(noise) - min(noise)) - 1;
    CB_noise(:,i)= noise(length(noise)/2:length(noise)/2+Frame_size-1);
end

end

