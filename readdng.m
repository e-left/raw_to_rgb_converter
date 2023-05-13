function [rawim, XYZ2Cam, wbcoeffs] = readdng(filename)
    % function readdng: gets as input a filename
    % and returns the raw image data, the XYZ2Cam matrix
    % and the white balance coefficients

    % read raw image with provided code
    img = Tiff(filename, "r");
    offsets = getTag(img, "SubIFD");
    setSubDirectory(img, offsets(1));
    rawim_unprocessed = read(img);
    close(img);

    % read useful metadata with provided code
    meta_info = imfinfo(filename);
    % (x_origin,y_origin) is the uper left corner of the useful 
    % part of the sensor and consequently of the array rawim
    y_origin = meta_info.SubIFDs{1}.ActiveArea(1) + 1;
    x_origin = meta_info.SubIFDs{1}.ActiveArea(2) + 1;
    % width and height of the image (the useful part of array rawim)
    width = meta_info.SubIFDs{1}.DefaultCropSize(1);
    height = meta_info.SubIFDs{1}.DefaultCropSize(2);
    if isfield(meta_info.SubIFDs{1},"LinearizationTable")
        ltab=meta_info.SubIFDs{1}.LinearizationTable;
        rawim_unprocessed = ltab(rawim_unprocessed + 1);
    end
    blacklevel = meta_info.SubIFDs{1}.BlackLevel(1); % sensor value corresponding to black
    whitelevel = meta_info.SubIFDs{1}.WhiteLevel; % sensor value corresponding to white
    wbcoeffs = (meta_info.AsShotNeutral).^ -1;
    wbcoeffs = wbcoeffs / wbcoeffs(2); % green channel will be left unchanged
    XYZ2Cam = meta_info.ColorMatrix2; 
    XYZ2Cam = reshape(XYZ2Cam, 3, 3)';

    % keep only useful portion of raw image
    rawim = rawim_unprocessed(y_origin:y_origin + height - 1, x_origin:x_origin + width - 1);
    rawim = double(rawim); % convert to double to keep decimal values

    % normalize blacklevels and whitelevels
    % 1. subtract blacklevel from every pixel
    % 2. divide every pixel value with whitelevel - blacklevel
    rawim = (rawim - blacklevel) / (whitelevel - blacklevel);

    % clamp every pixel in [0, 1]
    rawim = max(0, min(rawim, 1));
end

