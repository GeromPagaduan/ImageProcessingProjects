%% resizes image for use
originalImage = imread('img/smol.png');
resizedOriginImage = imresize(originalImage, 0.5);

distortedImage1 = imread('img/smolsaldist.png');
resizedDistortImage1 = imresize(distortedImage1, 0.5);

distortedImage2 = imread('img/smolnondist.png');
resizedDistortImage2 = imresize(distortedImage2, 0.5);

%% finds MSE and PSNR
[psnr1, mse1] = PSNR(resizedOriginImage,resizedDistortImage1); %compares original image to distorted salient areas
[psnr2, mse2] = PSNR(resizedOriginImage,resizedDistortImage2); %compares original image to distorted non-salient area

disp("PSNR for Comparison 1: " + psnr1);
disp("MSE for Comparison 1: " + mse1);
disp("PSNR for Comparison 2: " + psnr2);
disp("MSE for Comparison 2: " + mse2);

%% finds SSIM
ssim1 = ssim(resizedOriginImage,resizedDistortImage1,[0.01 0.03], fspecial('gaussian', 11, 1.5), 255); %compares original image to distorted salient areas
ssim2 = ssim(resizedOriginImage,resizedDistortImage2,[0.01 0.03], fspecial('gaussian', 11, 1.5), 255); %compares original image to distorted non-salient area

disp("SSIM for Comparison 1: " + ssim1);
disp("SSIM for Comparison 2: " + ssim2);
