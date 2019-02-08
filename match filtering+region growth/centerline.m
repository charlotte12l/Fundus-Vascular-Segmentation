function centerl=centerline(orinimg)
%参数调整好的中心线检测算法
greenimg=orinimg(:,:,2);
greenimg=double(greenimg);
greenimg=greenimg/max(greenimg(:));
height=size(greenimg,1)
width=size(greenimg,2)
maskimg=greenimg;
maskimg(find(maskimg<0.07))=0;
maskimg(find(maskimg>0.07))=1;
greenimg(find(greenimg<0.07))=max(greenimg(:))/2;
B=ones(15);
maskimg=imerode(maskimg,B);%图像A1被结构元素B膨胀


patchsize=31
smoothfilter=ones(patchsize);
smoothfilter=smoothfilter./patchsize^2;
background=conv2(greenimg,smoothfilter,'same');
normimg=greenimg-background;
normimg=normimg.*maskimg;

%斜线检测
gfilter4=[0, 0, 0,-1, 0, 0;
          0, 0,-2,-2,-2, 0;
          0, 2, 0,-4,-2,-1;
          1, 2, 4, 0,-2, 0;
          0, 2, 2, 2, 0, 0;
          0, 0, 1, 0, 0, 0]
img4=conv2(normimg,gfilter4,'same');


candidate4=zeros(height,width);
for i=2:height-2
   for j=3:width-1
       sum4=img4(i-1,j+1)+img4(i,j)+img4(i+1,j-1)+img4(i+2,j-2);%img4(i-1,j+1)>0 img4(i,j)>0
       if img4(i+1,j-1)<0 & img4(i+2,j-2)<0 & img4(i,j)>0 & img4(i-1,j+1)>0
           candidate4(i,j)=img4(i,j)+abs(img4(i+1,j-1));
       end
       if img4(i+1,j-1)<0 & img4(i,j)>0 & img4(i-1,j+1)>0 & sum4>0
           candidate4(i,j)=img4(i,j)+abs(img4(i+1,j-1));
       end
       if img4(i+1,j-1)<0 & img4(i+2,j-2)<0 & img4(i,j)>0 & sum4<0
           candidate4(i,j)=img4(i,j)+abs(img4(i+1,j-1));
       end
       if img4(i,j)==0 & img4(i+1,j-1)<0 & img4(i-1,j+1)>0
           candidate4(i,j)=img4(i-1,j+1)+abs(img4(i+1,j-1));
       end
    end
end       
candidate4=(candidate4-min(candidate4(:)))/(max(candidate4(:))-min(candidate4(:)));

nzcandidate4=candidate4(candidate4~=0);
nzcandidate4=roundn(nzcandidate4,-2);
canmode4=mode(nzcandidate4);
canmean4=mean(nzcandidate4);
canstd4=std(nzcandidate4);
a4=0.4


canseed4=candidate4;
canseed4(find(canseed4<canmean4+canstd4*a4))=0;
canseed4(find(canseed4>canmean4+canstd4*a4))=1;
canseed4= bwareaopen(canseed4,4,8);
[x4,y4]=find(canseed4==1);


connect4=region(candidate4,[x4,y4],canmode4,1);
connect4(find(connect4~=0))=1;
connect4= bwareaopen(connect4,8,8);
%斜线检测
gfilter3=[0, 0,-1, 0, 0, 0;
          0,-2,-2,-2, 0, 0;
         -1,-2,-4, 0, 2, 0;
          0,-2, 0, 4, 2, 1;
          0, 0, 2, 2, 2, 0;
          0, 0, 0, 1, 0, 0];
img3=conv2(normimg,gfilter3,'same');

candidate3=zeros(height,width);
for i=2:height-2
   for j=2:width-2
       sum3=img3(i-1,j-1)+img3(i,j)+img3(i+1,j+1)+img3(i+2,j+2);
       if img3(i+1,j+1)<0 & img3(i+2,j+2)<0 & img3(i,j)>0 & img3(i-1,j-1)>0
           candidate3(i,j)=img3(i,j)+abs(img3(i+1,j+1));
       end
       if img3(i+1,j+1)<0 & img3(i,j)>0 & img3(i-1,j-1)>0 & sum3>0
           candidate3(i,j)=img3(i,j)+abs(img3(i+1,j+1));
       end
       if img3(i+1,j+1)<0 & img3(i+2,j+2)<0 & img3(i,j)>0 & sum3<0
           candidate3(i,j)=img3(i,j)+abs(img3(i+1,j+1));
       end
       if img3(i,j)==0 & img3(i+1,j+1)<0 & img3(i-1,j-1)>0
           candidate3(i,j)=img3(i-1,j-1)+abs(img3(i+1,j+1));
       end
    end
end       
candidate3=(candidate3-min(candidate3(:)))/(max(candidate3(:))-min(candidate3(:)));

nzcandidate3=candidate3(candidate3~=0);
nzcandidate3=roundn(nzcandidate3,-2);
canmode3=mode(nzcandidate3);
canmean3=mean(nzcandidate3);
canstd3=std(nzcandidate3);
a3=0.4

canseed3=candidate3;
canseed3(find(canseed3<canmean3+canstd3*a3))=0;
canseed3(find(canseed3>canmean3+canstd3*a3))=1;
canseed3= bwareaopen(canseed3,4,8);
[x3,y3]=find(canseed3==1);


connect3=region(candidate3,[x3,y3],canmode3,1);
connect3(find(connect3~=0))=1;
connect3= bwareaopen(connect3,8,8);


%竖直线检测
gfilter2=[1,2,0,-2,-1;
          2,4,0,-4,-2;
          1,2,0,-2,-1];
img2=conv2(normimg,gfilter2,'same');


candidate2=zeros(height,width);
for i=1:height
    for j = 3:width-1
       sum2=img2(i,j-2)+img2(i,j-1)+img2(i,j)+img2(i,j+1);
       if img2(i,j-2)<0 & img2(i,j-1)<0 & img2(i,j)>0 & img2(i,j+1)>0
           candidate2(i,j)=img2(i,j)+abs(img2(i,j-1));
       end
       if img2(i,j-1)<0 & img2(i,j)>0 & img2(i,j+1)>0 & sum2>0
           candidate2(i,j)=img2(i,j)+abs(img2(i,j-1));
       end
       if img2(i,j-2)<0 & img2(i,j-1)<0 & img2(i,j)>0 & sum2<0
           candidate2(i,j)=img2(i,j)+abs(img2(i,j-1));
       end
       if img2(i,j)==0 & img2(i,j-1)<0 & img2(i,j+1)>0
           candidate2(i,j)=img2(i,j+1)+abs(img2(i,j-1));
       end
    end
end
candidate2=(candidate2-min(candidate2(:)))/(max(candidate2(:))-min(candidate2(:)));

nzcandidate2=candidate2(candidate2~=0);
nzcandidate2=roundn(nzcandidate2,-2);
canmode2=mode(nzcandidate2);
canmean2=mean(nzcandidate2);
canstd2=std(nzcandidate2);

a2=0.4

canseed2=candidate2;
canseed2(find(canseed2<canmean2+canstd2*a2))=0;
canseed2(find(canseed2>canmean2+canstd2*a2))=1;
canseed2= bwareaopen(canseed2,4,8);
[x2,y2]=find(canseed2==1);

connect2=region(candidate2,[x2,y2],canmode2,1);
connect2(find(connect2~=0))=1;
connect2= bwareaopen(connect2,8,8);


%水平线检测
gfilter1=[1,2,1;2,4,2;0,0,0;-2,-4,-2;-1,-2,-1];
img1=conv2(normimg,gfilter1,'same');
%检测是否为中心线
candidate1=zeros(height,width);
for j=1:width
    for i = 3:height-1
       sum1=img1(i-2,j)+img1(i-1,j)+img1(i,j)+img1(i+1,j);
       if img1(i-2,j)<0 & img1(i-1,j)<0 & img1(i,j)>0 & img1(i+1,j)>0
           candidate1(i,j)=img1(i,j)+abs(img1(i-1,j));
       end
       if img1(i-1,j)<0 & img1(i,j)>0 & img1(i+1,j)>0 & sum1>0
           candidate1(i,j)=img1(i,j)+abs(img1(i-1,j));
       end
       if img1(i-2,j)<0 & img1(i-1,j)<0 & img1(i,j)>0 & sum1<0
           candidate1(i,j)=img1(i,j)+abs(img1(i-1,j));
       end
       if img1(i,j)==0 & img1(i-1,j)<0 & img1(i+1,j)>0
           candidate1(i,j)=img1(i+1,j)+abs(img1(i-1,j));
       end
    end
end
candidate1=(candidate1-min(candidate1(:)))/(max(candidate1(:))-min(candidate1(:)));
%连接中心线
nzcandidate1=candidate1(candidate1~=0);
nzcandidate1=roundn(nzcandidate1,-2);
canmode1=mode(nzcandidate1);
canmean1=mean(nzcandidate1);
canstd1=std(nzcandidate1);

a1=0.4

canseed1=candidate1;
canseed1(find(canseed1<canmean1+canstd1*a1))=0;
canseed1(find(canseed1>canmean1+canstd1*a1))=1;
canseed1= bwareaopen(canseed1,4,8);
[x1,y1]=find(canseed1==1);


connect1=region(candidate1,[x1,y1],canmode1,1);
connect1(find(connect1~=0))=1;
connect1= bwareaopen(connect1,8,8);


connectall=connect1+connect2+connect3+connect4;
connectall(find(connectall>0.1))=1;

connectall=bwareaopen(connectall,20,8);
centerl=connectall;
