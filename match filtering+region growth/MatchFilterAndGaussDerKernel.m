function [Kernel]  = MatchFilterAndGaussDerKernel(sigma,YLength,theta,type)
%该函数哟弄个与生成匹配滤波的卷积核
%sigm为高斯带宽，与血管宽度相关
%theta代表检测的血管方向


if type == 0
    widthOfTheKernel = ceil(sqrt( (6*ceil(sigma)+1)^2 + YLength^2));
    if mod(widthOfTheKernel,2) == 0
        widthOfTheKernel = widthOfTheKernel + 1;
    end
    halfLength = (widthOfTheKernel - 1) / 2;
    row = 1;
    for y = halfLength:-1:-halfLength
        col = 1;
        for x = -halfLength:halfLength
            xPrime = x * cos(theta) + y * sin(theta);
            yPrime = y * cos(theta) - x * sin(theta);
            if abs(xPrime)>3*ceil(sigma)
                matchFilterKernel(row,col) = 0;
            elseif abs(yPrime)> (YLength-1) / 2
                matchFilterKernel(row,col) = 0;
            else
                matchFilterKernel(row,col) = -exp(-.5*(xPrime/sigma)^2)/(sqrt(2*pi)*sigma); %%%%？？？？？
            end
            col = col + 1;
        end
        row = row + 1;
    end
    mean = sum(sum(matchFilterKernel)) / sum(sum(matchFilterKernel < 0));%%%会不会少了个2
    for i = 1:widthOfTheKernel
        for j =1:widthOfTheKernel
            if matchFilterKernel(i,j) < 0
                matchFilterKernel(i,j) = matchFilterKernel(i,j) - mean;
            end
        end
    end
    Kernel = matchFilterKernel;
else
    widthOfTheKernel = ceil(sqrt( (6*ceil(sigma)+1)^2 + YLength^2));
    if mod(widthOfTheKernel,2) == 0
        widthOfTheKernel = widthOfTheKernel + 1;
    end
    halfLength = (widthOfTheKernel - 1) / 2;
    row = 1;
    for y = halfLength:-1:-halfLength
        col = 1;
        for x = -halfLength:halfLength
            xPrime = x * cos(theta) + y * sin(theta);
            yPrime = y * cos(theta) - x * sin(theta);
            if abs(xPrime)>3*ceil(sigma)
                GaussDerivativeKernel(row,col)  = 0;
            elseif abs(yPrime)> (YLength-1) / 2
                GaussDerivativeKernel(row,col)  = 0;
            else
                GaussDerivativeKernel(row,col)= -exp(-.5*(xPrime/sigma)^2)*xPrime/(sqrt(2*pi)*sigma^3);
            end
            col = col + 1;
        end
        row = row + 1;
    end
    Kernel = GaussDerivativeKernel;
end 