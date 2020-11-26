clc
clear all
close all 

%% Create the base image

width = 256;
length = 256;

%creates arbitrary matrix with all values 0
baseImage = zeros(width, length);

% Makes the circle with two tones of intensity
for horizontal = 1 : width
    for vertical = 1 : length
         dist =((horizontal-128)^2+(vertical-128)^2)^(.5)
         if(dist<80)
            baseImage(horizontal, vertical) = 0.4;
         else
            baseImage(horizontal, vertical) = 0.7;
         end
    end
end

figure, imshow(baseImage);

%% Add three kinds of noises to the image

%Gaussian Noise (with mean 0 and variance 0.01)
gaussImage = imnoise(baseImage, 'gaussian', 0, 0.01);

%Uniform Noise (with range [-0.05 to 0.05])
[M,N] = size(baseImage);
unifNoise = imnoise2('uniform', M, N, -0.05, 0.05);
unifImage = baseImage + unifNoise;

%Salt & Pepper Noise (with d = 0.02)
saltpepImage = imnoise(baseImage, 'salt & pepper', 0.02);

figure, imshow(gaussImage);
gaussHist = myhist(im2uint8(gaussImage));
figure, plot(gaussHist);

figure, imshow(unifImage);
unifHist = myhist(im2uint8(unifImage));
figure, plot(unifHist);

figure, imshow(saltpepImage);
saltpepHist = myhist(im2uint8(saltpepImage));
figure, plot(saltpepHist);

%% Remove the noise from the images

%Remove gaussian noise
removeGauss = wiener2(gaussImage)
removeGauss = medfilt2(removeGauss);
figure, imshow (removeGauss);

%Remove uniform noise by applying wiener filter five times in succession
for i = 1 : 5
    unifImage = wiener2(unifImage);
    removeUnif = unifImage;
end
figure, imshow(removeUnif);

%Remove salt & pepper noise
removeSaltPep = medfilt2(saltpepImage);
figure, imshow(removeSaltPep);