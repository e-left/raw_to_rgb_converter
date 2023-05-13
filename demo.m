warning('off','all');
clear;
close all;
filename = "../test.DNG";

% dimensions
M = 1000;
N = 1000;

[rawim, XYZ2Cam, wbcoeffs] = readdng(filename);

% testing

% single image
bayertype = "RGGB";
method = "linear";

[Csrgb, Clinear, Cxyz, Ccam] = dng2rgb(rawim, XYZ2Cam, wbcoeffs, bayertype, method, M, N);

% figure("Name", "Camera Color Space")
% imshow(Ccam);
% imwrite(Ccam, sprintf("test_CCam_%s_%s_1000_1000.png", bayertype, method));
% make_histograms(Ccam, 'Test_Camera_1000_1000', bayertype, method);
% 
% figure("Name", "XYZ Color Space")
% imshow(Cxyz);
% imwrite(Ccam, sprintf("test_Cxyz_%s_%s_1000_1000.png", bayertype, method));
% make_histograms(Cxyz, 'Test_XYZ_1000_1000', bayertype, method);
% 
% figure("Name", "Linear RGB Color Space")
% imshow(Clinear);
% imwrite(Clinear, sprintf("test_Clinear_%s_%s_1000_1000.png", bayertype, method));
% make_histograms(Clinear, 'Test_linear_1000_1000', bayertype, method);

figure("Name", "sRGB Color Space")
imshow(Csrgb);
% imwrite(Csrgb, sprintf("test_Csrgb_%s_%s_1000_1000.png", bayertype, method));
% make_histograms(Csrgb, 'Test_sRGB_1000_1000', bayertype, method);

% % try all combinations
% for bayertype = ["RGGB", "BGGR", "GBRG", "GRBG"]
%     for method = ["nearest", "linear"]   
% 
%         [Csrgb, Clinear, Cxyz, Ccam] = dng2rgb(rawim, XYZ2Cam, wbcoeffs, bayertype, method, M, N);
% 
%         figure("Name", "Camera Color Space")
%         imshow(Ccam);
%         imwrite(Ccam, sprintf("CCam_%s_%s.png", bayertype, method));
%         make_histograms(Ccam, 'Base_Camera', bayertype, method);
% 
%         figure("Name", "XYZ Color Space")
%         imshow(Cxyz);
%         imwrite(Ccam, sprintf("Cxyz_%s_%s.png", bayertype, method));
%         make_histograms(Cxyz, 'Base_XYZ', bayertype, method);
% 
%         figure("Name", "Linear RGB Color Space")
%         imshow(Clinear);
%         imwrite(Clinear, sprintf("Clinear_%s_%s.png", bayertype, method));
%         make_histograms(Clinear, 'Base_linear', bayertype, method);
% 
%         figure("Name", "sRGB Color Space")
%         imshow(Csrgb);
%         imwrite(Csrgb, sprintf("Csrgb_%s_%s.png", bayertype, method));
%         make_histograms(Csrgb, 'Base_sRGB', bayertype, method);
% 
%     end
% 
% end
