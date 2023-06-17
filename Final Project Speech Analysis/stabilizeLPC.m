function lpcCoefficients = stabilizeLPC(lpcCoefficients)
% STABILIZELPC Stabilizes the LPC coefficients to ensure they are within the unit circle.
%
% Input:
%   - lpcCoefficients: The LPC coefficients to be stabilized.
%
% Output:
%   - lpcCoefficients: The stabilized LPC coefficients.

    % Ensure LPC coefficients are within the unit circle
    lpcCoefficients = lpcCoefficients / max(abs(lpcCoefficients));
    
    % Check if any coefficients have magnitude >= 1
    unstableIndices = find(abs(lpcCoefficients) >= 1);
    if ~isempty(unstableIndices)
        % Apply a scaling factor to bring the coefficients inside the unit circle
        lpcCoefficients(unstableIndices) = lpcCoefficients(unstableIndices) / 1.01;
    end
    
    % Adjust coefficients to satisfy the stability condition
    poles = roots(lpcCoefficients);
    unstablePoles = abs(poles) >= 1;
    poles(unstablePoles) = poles(unstablePoles) ./ abs(poles(unstablePoles));
    
    % Reconstruct the stabilized LPC coefficients
    lpcCoefficients = real(poly(poles));

end
