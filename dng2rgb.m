function [Csrgb, Clinear, Cxyz, Ccam] = dng2rgb(rawim, XYZ2Cam, wbcoeffs, bayertype, method, M, N)
    % dng2rgb: gets as input a linearly transformed rawim and outputs
    % different color images on the requested color spaces,
    % given parameters

    % transform rawim to Ccam

    % white balancing
    mask = wbmask(size(rawim, 1), size(rawim, 2), wbcoeffs, bayertype);
    rawim_wb = rawim .* mask;

    % demosaicing (or interpolating)
    % temporary (testing purposes)
    Ccam = interpolate_image(rawim_wb, bayertype, method, M, N);

    % % transform Ccam to Cxyz
    % % if T XYZ -> Cam = XYZ2Cam
    % % then T Cam -> XYZ = XYZ2Cam^-1
    Cam2XYZ = inv(XYZ2Cam);
    Cam2XYZ = Cam2XYZ ./ repmat(sum(Cam2XYZ, 2), 1, 3); % normalize rows to 1
    % necesary since they are not
    Cxyz = apply_cmatrix(Ccam, Cam2XYZ);
    % clip invalid values
    Cxyz = max(0, min(Cxyz, 1));

    % transform Cxyz to Clinear
    % given matrix
    XYZ2RGB = [3.2406 -1.5372 -0.4986;
               -0.9689 1.8758 0.0415;
               0.0557 -0.2040 1.0570];   
    Clinear = apply_cmatrix(Cxyz, XYZ2RGB);
    % clip invalid values
    Clinear = max(0, min(Clinear, 1));

    % transform Clinear to Csrgb
    multTransf = Clinear <= 0.0031308;
    otherTRansf = Clinear > 0.0031308;
    Csrgb = Clinear;
    Csrgb(multTransf) = Csrgb(multTransf) * 12.92;
    Csrgb(otherTRansf) = 1.055 * Csrgb(otherTRansf) .^ (1 / 2.4) - 0.055;
    % clip invalid values
    Csrgb = max(0, min(Csrgb, 1));

    % or use the simplification
    % Csrgb = Clinear.^(1/2.2);
    % Csrgb = max(0, min(Csrgb, 1));
end

