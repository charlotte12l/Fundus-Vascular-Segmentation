function [image2,MatchFilterKernel] = MatchFilter(image1,sigma,yLength, direction_number)
%该函数用于对图像进行匹配滤波
    
[a, b] = size(image1);
image1 = double(image1);
MatchFilter_image=zeros(a,b,direction_number);
for i = 1:direction_number %等分180°，滤波
    MatchFilterKernel = MatchFilterAndGaussDerKernel(sigma,yLength, pi/direction_number*(i-1),0);
    MatchFilter_image(:,:,i) = conv2(image1,MatchFilterKernel,'same');
end
image2 = max(MatchFilter_image,[],3);%选取最大的
%image2 = uint8(image2);

end

    