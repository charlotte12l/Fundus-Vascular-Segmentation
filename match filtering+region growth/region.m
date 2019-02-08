%区域生长算法:region
function LabelImage=region(image,seed,Threshold,maxv)
%image:输入图像
%seed：种子点坐标堆栈
%threshold：用邻域近似生长规则的阈值
%maxv：所有生长的像素的范围小于maxv
% LabelImage:输出的标记图像，其中每个像素所述区域标记为rn


[seedNum,tem]=size(seed);%seedNum为种子个数
[Width,Height]=size(image);
LabelImage=zeros(Width,Height);
rn=0;%区域标记号码

for i=1:seedNum 
   %从没有被标记的种子点开始进行生长
    if LabelImage(seed(i,1),seed(i,2))==0
           rn=rn+1;% %对当前生长区域赋标号值
           LabelImage(seed(i,1),seed(i,2))=rn;
    %     end
        stack(1,1)=seed(i,1);%将种子点压入堆栈（堆栈用来在生长过程中的数据坐标）
        stack(1,2)=seed(i,2);
        Start=1;%定义堆栈起点和终点
        End=1;
        while(Start<=End)
            %当前种子点坐标
            CurrX=stack(Start,1);
            CurrY=stack(Start,2);
            %对当前点的8邻域进行遍历
            for m=-1:1
                for n=-1:1
%                       %判断像素（CurrX，CurrY）是否在图像内部
%                       rule1=(CurrX+m)<=Width&(CurrX+m)>=1&(CurrY+n)<=Height&(CurrY+n)>=1;
%                        %判断像素（CurrX，CurrY）是否已经处理过
%                       rule2=LabelImage(CurrX+m,CurrY+n)==0;
%                       %判断生长条件是否满足
%                       rule3=abs(double(image(CurrX,CurrY))-double(image(CurrX+m,CurrY+n)))<Threshold;
%                       %条件组合
%                       rules=rule1&rule2&rule3;
                    if (CurrX+m)<=Width&(CurrX+m)>=1&(CurrY+n)<=Height&(CurrY+n)>=1&LabelImage(CurrX+m,CurrY+n)==0&abs(double(image(CurrX,CurrY))-double(image(CurrX+m,CurrY+n)))<=Threshold&image(CurrX+m,CurrY+n)<maxv&image(CurrX+m,CurrY+n)>0
                        %堆栈的尾部指针后移一位
                        End=End+1;
                        %像素（CurrX+m,CurrY+n)压入堆栈
                        stack(End,1)=CurrX+m;
                        stack(End,2)=CurrY+n;                   
                        %把像素（CurrX,CurrY)设置成逻辑1
                        LabelImage(CurrX+m,CurrY+n)=rn;
                    end
                end
            end
            %堆栈的尾部指针后移一位
            Start=Start+1;        
        end
    end
end








    

    


                    
            
            
        
        
        

    
    
    