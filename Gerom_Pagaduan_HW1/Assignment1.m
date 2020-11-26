clc
clear all
close all 
  

  
path='C:\Users\Celes\OneDrive\Documents\MATLAB\images\'; % this is your working path
impath=[path,'yuri.jpg']; % path of the image
im=imread(impath);
%figure,imshow(im); % you could also try image() imagesc() other image display functions 


[r,c,ch]=size(im);
img=zeros(r,c);
img=rgb2gray(im); % change color image to grayscale image 

im_resized=imresize(img,[256,256]);

for i = 1:256
    for j = 1:256
        dist =((i-128)^2+(j-128)^2)^(.5);
        if(dist<80)
            B(i,j)= im_resized(i,j);
        else
            B(i,j)=0;
        end
    end
end
figure,imshow(im_resized);
image(B);
colormap(gray(256));