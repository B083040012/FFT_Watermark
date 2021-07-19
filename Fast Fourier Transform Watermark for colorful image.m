clear all
close all

%read picture for watermarked
Img=(imread('colorful_image.jpg'))
Img=im2double(Img)
%resize to power of 2
Img=imresize(Img,[512,512])
figure
imshow(Img,[])
title('Image for watermarked')

%read logo for watermarked
logo=(imread('colorful_logo.jpg'))
logo=im2double(logo)
%resize to power of 2
logo=imresize(logo,[128,128])
figure
imshow(logo,[])
title('Logo for watermarked')

%do myfft_3d
Img=myfft_3d(Img)
figure
imshow(Img)
title('Img after myfft_3d')

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

function output=myfft_3d(input)
    [row,col,high]=size(input)
    for h=1:1:high
        for a=1:1:col
            input(:,a,h)=myfft_recursion(input(:,a,h))
        end
        for b=1:1:row
            input(b,:,h)=myfft_recursion(input(b,:,h))
        end
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
   [Img_row,Img_col,Img_high]=size(Img_fft)
   [logo_row,logo_col,logo_high]=size(logo)
   for a=1:1:Img_high
       Img_fft(Img_row/2-logo_row/2:(Img_row/2+logo_row/2-1),Img_col/2-logo_col/2:(Img_col/2+logo_col/2-1),a)=logo(:,:,a)
   end
   figure
   imshow(Img_fft)
   title('Logo Insert') 
   Img_fft=myifft_3d(Img_fft)
   m=Img_fft
end

function m=watermark_shift(Img_fft,logo)
   [Img_row,Img_col,Img_high]=size(Img_fft)
   [logo_row,logo_col,logo_high]=size(logo)
   for a=1:1:Img_high
       Img_fft(:,:,a)=fftshift(Img_fft(:,:,a))
       Img_fft(Img_row/2-logo_row/2:(Img_row/2+logo_row/2-1),Img_col/2-logo_col/2:(Img_col/2+logo_col/2-1),a)=logo(:,:,a)
   end
   figure
   imshow(Img_fft)
   title('Logo Insert with shift')
   for h=1:1:Img_high
       Img_fft(:,:,h)=ifftshift(Img_fft(:,:,h)) 
   end
   Img_fft=myifft_3d(Img_fft)
   m=Img_fft
end

function output=myifft_3d(input)
    [row,col,high]=size(input)
    for h=1:1:high
        for a=1:1:row
            input(a,:,h)=myifft_recursion(input(a,:,h))
        end
        for b=1:1:col
            input(:,b,h)=myifft_recursion(input(:,b,h))
        end
        input(:,:,h)=input(:,:,h)/(row*col)
    end
    output=input
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