clc
clear all
close all 
  

  
path='./images/'; % this is your working path
impath=[path,'guitar.jpg']; % path of the image
im=imread(impath);


[r,c,ch]=size(im);
img=zeros(r,c);
img=rgb2gray(im); % change color image to grayscale image 

%Average (Mean) Filter
meanImage = conv2(single(img), ones(3)/9, 'same') %applies (1/9) filter onto original image

%Laplacian Filter
lapKernel = -1 * ones(3); %creates a 3x3 matrix of -1s
lapKernel(2,2) = 8;  %sets middle of kernel to 8
lapOutput = conv2(double(img), lapKernel, 'same');

%Sobel Filter
Gx = [+1 +2 +1; 0 0 0; -1,-2,-1] %x-filter
Gy = [-1 0 +1; -2,0,+2; -1,0,+1] %y-filter
xResult = conv2(img, Gx, 'same');
yResult = conv2(img, Gy, 'same');
sobelOutput = sqrt(xResult.^2 + yResult.^2);

%Median Filter
[m,n]= size(img); %height and width of orignal image
medianIm = zeros(m,n);
imPad = padarray(img, [1 1]); %pads the border with 0s
[height,width] = size(imPad);
for i = 2:height-1
    for j = 2:width-1
        sub_array = imPad((i-1):(i+1),(j-1):(j+1)); %creates a 3x3 sub-matrix
        reshaped_array = reshape(sub_array, 1, []); %converts it from 3x3 to 9x1
        sorted_array = sort(reshaped_array);
        medOutput(i-1,j-1) = sorted_array(5); %finds median from the sub-array
    end
end
           
figure,imshow(meanImage, []);
figure,imshow(lapOutput, []);
figure,imshow(sobelOutput, []);
figure,imshow(medOutput, []);

%-----------------------------------------
%-----------Pupil Detection --------------
%-----------------------------------------

iris_path='./images/';
impath_iris=[iris_path,'iris.bmp']; %path of the image
im_iris=imread(impath_iris); %converts image to matrix

%Sobel Filter
Gx_iris = [+1 +2 +1; 0 0 0; -1,-2,-1] %x-filter
Gy_iris = [-1 0 +1; -2,0,+2; -1,0,+1] %y-filter
iris_x = conv2(im_iris, Gx_iris, 'same');
iris_y = conv2(im_iris, Gy_iris, 'same');
sobelIris = sqrt(iris_x.^2 + iris_y.^2);
%figure,imshow(sobelIris, []);

%Iris Mask
irisFilter = zeros(45,45); %creates a 45x45 matrix of zeros
for k = 1:45 %vertical movement until it hits edge or iris
    for l = 1:45 %horizontal movement until it hits edge of iris
        h = sqrt((k-22)^2 + (l-22)^2); %makes a matrix in the center of the eye
        if(h>17.5 && h < 22.5)
            irisFilter(k, l) = 1; %makes everything in boundry white
        end
    end
end
irisFilterApplied = conv2(sobelIris, irisFilter, 'same');
irisInverted = imcomplement(irisFilterApplied)

%Thresholding
thresholdedIris = imquantize(irisInverted, .9); %If above .9, make a 255 and if below, make 0

%Finding the boundries of the circle
stats = regionprops(thresholdedIris, 'basic'); %Gives us area, bounding box, and centroid of white space
realCenter = {stats.Centroid};

centerMatrix = cell2mat(realCenter(2));%2 because it's the center of the white space
centerX = centerMatrix(2); %gives the X value of the center
centerY = centerMatrix(1); %gives the Y value of the center
[sizeX, sizeY] = size(sobelIris); %gives the X and Y of sobel filter image

for i = 1:sizeX
    for j = 1:sizeY
        distance = ((i-centerX)^2+(j-centerY)^2)^(.5); %distance from center of circle
        if(distance > 45)%if distance from center of circle is 45, turn it black
            sobelIris(i,j)=0; %makes everything outside boundary black
        end
    end
end
thresholdBoundry = imquantize(sobelIris, 200); %reduces noise


figure,imshow(irisFilterApplied,[]); %shows masked image
figure,imshow(irisInverted, []); %Inverted image 
figure,imshow(thresholdedIris, []); %shows the circle of the pupil
figure,imshow(thresholdBoundry,[]); %shows boundry
