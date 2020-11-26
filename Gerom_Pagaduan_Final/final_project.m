clc
clear all
close all

%% Contrast Stretch
original_image = imread('final_img/IMG_01.jpg'); %read original image
gray_image = rgb2gray(original_image); %turn image into grayscale
imshow(original_image);
title('Original Image');

%show histogram of original image
imhist(original_image), title('Original Image Histogram');

%contrast stretch
contrasted_image = imadjust(original_image,stretchlim(original_image));
figure;
imshow(contrasted_image);
title('Image After Contrast Stretch');

%show histogram of stretched image
imhist(contrasted_image), title('Stretched Image Histogram');

%color space preprocess
red_plane = contrasted_image(:,:,1);
green_plane = contrasted_image(:,:,2);
blue_plane = contrasted_image(:,:,3);

figure;
subplot(2,2,1), imshow(red_plane);
title('Red Plane');
subplot(2,2,2), imshow(green_plane);
title('Green Plane');
subplot(2,2,3), imshow(blue_plane);
title('Blue Plane');

%% Segmentation
%threshold each plane of color and return its sum
red_thresh = 0.5;
green_thresh = 0.3;
blue_thresh = 0.0;

image_red = im2bw(red_plane, red_thresh);
image_green = im2bw(green_plane, green_thresh);
image_blue = im2bw(blue_plane, blue_thresh);
thresholded_image = (image_red & image_green & image_blue);

%plot each image
subplot(2,2,1), imshow(image_red);
title('Red Plane');
subplot(2,2,2), imshow(image_green);
title('Green Plane');
subplot(2,2,3), imshow(image_blue);
title('Blue Plane');
figure, imshow(thresholded_image);
title('Total of Planes');

%% Noise reduction
%inverse black & white, fill in holes
reverse_image = imcomplement(thresholded_image);
figure, imshow(reverse_image);
filled_image = imfill(reverse_image, 'holes');
figure, imshow(filled_image);
title('Filled Image');

% more morphological functions to get rid of noise
structuring_element = strel('disk', 1);
final_image = imopen(filled_image, structuring_element);
figure, imshow(final_image);
title('Final Image');


%bwboundaries
%use light patterns to separate holes from ports; reflectivity is different

%% Decorrelation Stretch

%decorrelation stretch
decorrelated_image = decorrstretch(original_image, 'Tol', 0.01);
figure;
imshow(decorrelated_image);
title('Image After Decorrelation Stretch');


%color space preprocess
red_plane2 = decorrelated_image(:,:,1);
green_plane2 = decorrelated_image(:,:,2);
blue_plane2 = decorrelated_image(:,:,3);

figure;
subplot(2,2,1), imshow(red_plane2);
title('Red Plane');
subplot(2,2,2), imshow(green_plane2);
title('Green Plane');
subplot(2,2,3), imshow(blue_plane2);
title('Blue Plane');

%% Segmentation
%threshold each plane of color and return its sum
red_thresh2 = 0.5;
green_thresh2 = 0.3;
blue_thresh2 = 0.0;

image_red2 = im2bw(red_plane2, red_thresh2);
image_green2 = im2bw(green_plane2, green_thresh2);
image_blue2 = im2bw(blue_plane2, blue_thresh2);
thresholded_image2 = (image_red2 & image_green2 & image_blue2);

%plot each image
subplot(2,2,1), imshow(image_red2);
title('Red Plane');
subplot(2,2,2), imshow(image_green2);
title('Green Plane');
subplot(2,2,3), imshow(image_blue2);
title('Blue Plane');
figure, imshow(thresholded_image2);
title('Total of Planes');

%% Noise reduction
%inverse black & white, fill in holes
reverse_image2 = imcomplement(thresholded_image2);
figure, imshow(reverse_image2);
filled_image2 = imfill(reverse_image2, 'holes');
figure, imshow(filled_image2);
title('Filled Image');

% more morphological functions to get rid of noise
structuring_element = strel('disk', 1);
final_image2 = imopen(filled_image2, structuring_element);
figure, imshow(final_image2);
title('Final Image');


% consider using bwboundaries in the future
%use light patterns to separate holes from ports; reflectivity is different





