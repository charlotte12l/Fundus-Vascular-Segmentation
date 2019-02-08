function X = normalize(I)
%该函数用于将图片归一化到0~1
minValue = min(min(I));
maxValue = max(max(I));
X = (I - minValue) /(maxValue - minValue);