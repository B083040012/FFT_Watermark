clear all
close all

%read picture for watermarked
Img=(imread('gray_image.jpg'))
Img=rgb2gray(Img)
Img=im2double(Img)
%resize to power of 2
Img=imresize(Img,[512,512])
figure
imshow(Img,[])
title('Image for watermarked')

%read logo for watermarked
logo=(imread('gray_logo.jpg'))
logo=rgb2gray(logo)
logo=im2double(logo)
%resize to power of 2
logo=imresize(logo,[128,128])
figure
imshow(logo,[])
title('Logo for watermarked')

%do myfft
Img=myfft(Img)
figure
imshow(Img)
title('Img after myfft')

Img_2=Img

%watermark with fftshift
Img_WaterMarked_shift=watermark_shift(Img,logo)
figure
imshow(Img_WaterMarked_shift)
title('Img after watermarked with fftshift')

%watermark without fftshift
Img_Watermarked=watermark(Img_2,logo)
figure
imshow(Img_Watermarked)
title('Img after watermarked')

function output=myfft(input)
    [row,col]=size(input)
    for a=1:1:col
        input(:,a)=myfft_recursion(input(:,a))
    end
    for b=1:1:row
        input(b,:)=myfft_recursion(input(b,:))
    end
    output=input
end

function output=myfft_recursion(input)
    n=length(input)
if(n==1)
    output=input
else
    f_even=input(1:2:n)
    f_odd=input(2:2:n)
    y1=myfft_recursion(f_even)
    y2=myfft_recursion(f_odd).*W_L(n)
    output=[(y1+y2),(y1-y2)]
end
end

function w=W_L(n)
    w=exp(-2*pi*i*[0:1:(n/2)-1]/n)
end

function m=watermark(Img_fft,logo)
   [Img_row,Img_col]=size(Img_fft)
   [logo_row,logo_col]=size(logo)
   Imgshift=Img_fft
   Imgshift(Img_row/2-logo_row/2:(Img_row/2+logo_row/2-1),Img_col/2-logo_col/2:(Img_col/2+logo_col/2-1))=logo
   figure
   imshow(Imgshift)
   title('Logo Insert')
   Watermark=Imgshift
   m=myifft(Watermark)
end

function m=watermark_shift(Img_fft,logo)
   [Img_row,Img_col]=size(Img_fft)
   [logo_row,logo_col]=size(logo)
   Imgshift=fftshift(Img_fft)
   Imgshift(Img_row/2-logo_row/2:(Img_row/2+logo_row/2-1),Img_col/2-logo_col/2:(Img_col/2+logo_col/2-1))=logo
   figure
   imshow(Imgshift)
   title('Logo Insert with shift')
   Watermark=ifftshift(Imgshift) 
   m=myifft(Watermark)
end

function output=myifft(input)
    [row,col]=size(input)
    for a=1:1:row
        input(a,:)=myifft_recursion(input(a,:))
    end
    for b=1:1:col
        input(:,b)=myifft_recursion(input(:,b))
    end
    output=input/(row*col)
end

function output=myifft_recursion(input)
    n=length(input)
if(n==1)
    output=input
else
    f_even=input(1:2:n)
    f_odd=input(2:2:n)
    y1=myifft_recursion(f_even)
    y2=myifft_recursion(f_odd).*iW_L(n)
    output=[(y1+y2),(y1-y2)]
end
end

function w=iW_L(n)
    w=exp(2*pi*i*[0:1:(n/2)-1]/n)
end