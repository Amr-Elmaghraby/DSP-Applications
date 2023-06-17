function [quantized_lpc] = quantizeLPC(lpcCoefficients, numBits)

    % Scale the LPC coefficients to a suitable range for quantization
    scale = max(abs(lpcCoefficients));
    scaled_lpc = lpcCoefficients / scale;

    % Determine the number of levels and the step size for quantization
    L = 2^numBits;
    stepSize = 2 * scale / L;

    % Quantize the scaled LPC coefficients
    quantized_lpc = round(scaled_lpc / stepSize) * stepSize;

    % Rescale the quantized LPC coefficients back to the original range
    quantized_lpc = quantized_lpc * scale;
end

