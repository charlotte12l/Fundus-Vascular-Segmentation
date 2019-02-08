function resultimg=standard(orinimg)
%该函数返回标准的分割结果
tophatimg=tophat(orinimg);
climg=centerline(orinimg);
[xf,yf]=find(climg==1);
tophatimg(find(tophatimg>0.3))=1;
tophatimg(find(tophatimg~=1))=0;
tophatimg=bwareaopen(tophatimg,20,8);
resultimg=region(tophatimg,[xf,yf],1,1.2);
resultimg(find(resultimg>0.1))=1;
resultimg(find(resultimg~=1))=0;
resultimg=bwareaopen(resultimg,1000,8);

