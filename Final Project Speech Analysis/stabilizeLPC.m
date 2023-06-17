function lpcCoefficients = stabilizeLPC(lpcCoefficients)
% STABILIZELPC Stabilizes the LPC coefficients to ensure they are within the unit circle.
%
% Input:
%   - lpcCoefficients: The LPC coefficients to be stabilized.
%
% Output:
%   - lpcCoefficients: The stabilized LPC coefficients.

    % Check if any coefficients lie outside the unit circle
    if any(abs(roots(lpcCoefficients)) >= 1)
        % Normalize the coefficients to ensure they lie inside the unit circle
        lpcCoefficients = lpcCoefficients / max(abs(roots(lpcCoefficients)));
    end

end
