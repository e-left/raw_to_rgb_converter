function colormask = wbmask(m, n, wbmults, align)
    % COLORMASK = wbmask(M,N,WBMULTS,ALIGN)
    %
    % Makes a white-balance multiplicative mask for an image of size m-by-n
    % with RGB while balance multipliers WBMULTS = [R_scale G_scale B_scale].
    % ALIGN is string indicating Bayer arrangement: "RGGB", "BGGR", "GRBG",
    % "GBRG"
    
    % code is taken from pdf

    colormask = wbmults(2) * ones(m,n); %Initialize to all green values
    switch align
        case "RGGB"
        colormask(1:2:end, 1:2:end) = wbmults(1); %r 
        colormask(2:2:end, 2:2:end) = wbmults(3); %b
        case "BGGR"
        colormask(2:2:end, 2:2:end) = wbmults(1); %r 
        colormask(1:2:end, 1:2:end) = wbmults(3); %b
        case "GRBG"
        colormask(1:2:end, 2:2:end) = wbmults(1); %r 
        colormask(1:2:end, 2:2:end) = wbmults(3); %b
        case "GBRG"
        colormask(2:2:end, 1:2:end) = wbmults(1); %r
        colormask(1:2:end, 2:2:end) = wbmults(3); %b
    end 
end
