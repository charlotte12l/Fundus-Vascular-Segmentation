function thimg=tophat(img1)
%tophat
%img1=imread('test.tif');
img=255-img1(:,:,2);
[m,n]=size(img);
sum=zeros(m,n);
sum=uint8(sum);
for angle=0:22.5:157.5
    SE = strel('line',21,angle);
    I2=imopen(img,SE);   
    newimg=img-I2;
    sum=sum+newimg;
    %figure(angle/22.5+2);
    %imshow(newimg)
end;


s = zeros(m,n,8);           % pre allocate a variable to store 8 bit planes of the image
for k = 1:8
    for i = 1:m
        for j = 1:n
            s(i,j,k) = bitget(sum(i,j),k);    %get kth bit from each pixel 
        end
     end
    
end
%figure,imshow(uint8(itemp));title('Original Image');    %display original image
                                           %display all the 8 bit planes
    
sum2=s(:,:,8)+s(:,:,7);

sum3=medfilt2(sum2,[2,2]);
thimg=sum3;

