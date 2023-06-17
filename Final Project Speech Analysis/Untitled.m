% Generate unstable filter coefficients
unstable_coeffs = [1, 1.5, -0.7];

% Create a random input signal
input_signal = randn(1000, 1);

% Apply the unstable filter to the input signal
output_signal = filter(unstable_coeffs, 1, input_signal);
[z,poles] = tf2zpk(1,unstable_coeffs);
figure
zplane(z,poles)
outsideUnitCircle = abs(poles) > 1;
% check if no poles out f unit circle retun from function without changing
% lpc parameters
%%
if(sum(outsideUnitCircle)==0)
    stable_coeff = unstable_coeffs;
    return;
end

% 3. Scale the poles inside the unit circle
scalingFactor = 0.99;
poles(outsideUnitCircle) = (poles(outsideUnitCircle) ./ abs(poles(outsideUnitCircle))) * scalingFactor;

% 4. Reconstruct the modified LPC coefficients
stable_coeff = real(poly(poles));
[z,poles] = tf2zpk(stable_coeff,1);
figure
zplane(z,poles)
%%% Generate unstable filter coefficients
unstable_coeffs = [1, 1.5, -0.7];

% Create a random input signal
input_signal = randn(1000, 1);

% Apply the unstable filter to the input signal
output_signal = filter(unstable_coeffs, 1, input_signal);

% Get the poles of the unstable filter
[~, poles] = tf2zp(unstable_coeffs, 1);

% Check if any poles are outside the unit circle
outsideUnitCircle = abs(poles) > 1;

% If all poles are inside the unit circle, return the stable coefficients
if ~any(outsideUnitCircle)
    stable_coeffs = unstable_coeffs;
    disp('Filter is already stable.');
    return;
end

% Scale the poles inside the unit circle
scalingFactor = 0.99;
scaled_poles = poles;
scaled_poles(outsideUnitCircle) = poles(outsideUnitCircle) ./ abs(poles(outsideUnitCircle)) * scalingFactor;

% Reconstruct the modified LPC coefficients
stable_coeffs = real(poly(scaled_poles));

% Get the poles of the stabilized filter
[~, stabilized_poles] = tf2zp(stable_coeffs, 1);

% Plot the z-plane representation of the poles
figure;
zplane([], stabilized_poles);
title('Z-plane representation of the stabilized filter');

% Apply the stabilized filter to the input signal
stabilized_output_signal = filter(stable_coeffs, 1, input_signal);



