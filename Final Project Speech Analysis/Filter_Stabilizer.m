function [M_lpc] = Filter_Stabilizer(lpc)
%_________________________________________________________________
%Applying stabilization to the lpc parameters 

% inputs :
    % lpc parameters : short or long parameters

% outputs :
    % M_lpc : lpc paramters after stabilizing 
%_________________________________________________________________

% 1. Calculate the roots (poles) of the LPC coefficients
[~,poles] = tf2zpk(1,lpc);

% 2. Check if any poles are outside the unit circle
outsideUnitCircle = abs(poles) > 1;
% check if no poles out f unit circle retun from function without changing
% lpc parameters
if(sum(outsideUnitCircle)==0)
    M_lpc = lpc;
    return;
end

% 3. Scale the poles inside the unit circle
scalingFactor = 0.99;
poles(outsideUnitCircle) = (poles(outsideUnitCircle) ./ abs(poles(outsideUnitCircle))) * scalingFactor;

% 4. Reconstruct the modified LPC coefficients
if(length(poles)~=12)
    M_lpc =  [real(poly(poles)) zeros(1,length(lpc)-length(poles)-1)];
else
    M_lpc = real(poly(poles));
end
end

