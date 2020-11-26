clc
clear all
close all 

%%

path='./images/'; % this is your working path
impath=[path,'face_good.bmp']; % path of the image
im=imread(impath);
faceGood = double(im);

%%

ims1 = (im(:,:,1)>95) & (im(:,:,2)>40) & (im(:,:,3)>20); 
ims2 = (im(:,:,1)-im(:,:,2)>15) | (im(:,:,1)-im(:,:,3)>15);
ims3 = (im(:,:,1)-im(:,:,2)>15) & (im(:,:,1)>im(:,:,3));
ims = ims1 & ims2 & ims3;

figure,imshow(ims,[]); title('face _ good.bmp Output'); %shows the skin of the face_good.bmp

%%
path='./images/'; % this is your working path
impath2=[path,'face_dark.bmp']; % path of the image
im2=imread(impath2);
faceDark = double(im2);

%% Incorrect Skin Detection Because of Uniform Colors

ims12 = (im2(:,:,1)>95) & (im2(:,:,2)>40) & (im2(:,:,3)>20); 
ims22 = (im2(:,:,1)-im2(:,:,2)>15) | (im2(:,:,1)-im2(:,:,3)>15);
ims32 = (im2(:,:,1)-im2(:,:,2)>15) & (im2(:,:,1)>im2(:,:,3));
ims2nd = ims12 & ims22 & ims32;
%figure,imshow(ims2nd,[]); %defective detection

%% Original Image's Histogram Analysis

DarkHist = imhist(im2);
figure,plot(DarkHist); %shows histogram of the original image

imLuv = colorspace('RGB->Luv',im2);
 
%separates Luv into layers
L = imLuv(:,:,1);
U = imLuv(:,:,2);
V = imLuv(:,:,3);


%uses L to differentiate skin from background
figure,imagesc(L); axis image;axis off; title('Luminance','fontsize',14);
lHist = imhist(L);
figure,plot(lHist);

%% Searches for Extreme Changes in Histogram

variation=[]; %empty matrix to process new pixel values

%I had assistance with this loop; starts at 11 to avoid OOB errors
for i=11:250
    if lHist(i)+lHist(i+1)+lHist(i+2)+lHist(i+3)+lHist(i+4)+lHist(i+5)>0
      variation(i)= abs(lHist(i-10)+lHist(i-8)+lHist(i-6)-lHist(i)+lHist(i+6)+lHist(i+8)+lHist(i+10));
    end
end
  
[value, location] = max(variation);

%Traverses size of the image; pads with 0 if out of bounds 
traversal = location;
for k =1:240
    for j=1:320
        if L(k,j) > traversal
            L(k,j) = 0;
        end
    end
end

%% Luminance of face_dark.bmp

%Looks at the luminance of face_dark.bmp
imLumi = rgb2ycbcr(im2);
figure,imshow(imLumi); title('Face Dark Luminance');
figure,imhist(imLumi, 50); title('Face Dark Luminance Histogram');
histDark = imhist(imLumi);

%% Gamma Correction 

imLuv2(:,:,1) = L;
imLuv2(:,:,2) = U;
imLuv2(:,:,3) = V;
imProper = colorspace('Luv->RGB',imLuv2); 
%figure,imagesc(L); matches first transformation

faceDark = imProper;
figure, imhist(faceDark); title('Corrected Image Histogram')
figure, imshow(faceDark); title('Corrected Image')


%% Skin Detection Filter (Success)
ims1d = (faceDark(:,:,1)>(95/255)) & (faceDark(:,:,2)>(40/255)) & (faceDark(:,:,3)>(20/255));
ims2d = (faceDark(:,:,1)-faceDark(:,:,2)>(15/255)) | (faceDark(:,:,1)-faceDark(:,:,3)>(15/255));
ims3d = (faceDark(:,:,1)-faceDark(:,:,2)>(15/255)) & (faceDark(:,:,1)>faceDark(:,:,3));
imsd = ims1d & ims2d & ims3d;
figure,imshow(imsd); title('face _ dark.bmp Output');