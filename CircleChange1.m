function [X,X1] = CircleChange1(x,c,r,sigma)
%闭回路调整法
X=zeros(r,c);

vx=x;  %初始化访问表，数字格赋值为0，非数子格赋值-1
for i=1:r
    for j=1:c
        if vx(i,j)~=0
            vx(i,j)=0;
        else
            vx(i,j)=-1;
        end
    end
end

m=min(sigma(sigma<0));
[r2,c2 ]=find(sigma==m);
r0=r2(1);
c0=c2(1);
r1=r2(1);
c1=c2(1);

path=-ones(r+c+1,3);  %定义路径表【行号，列号，运输量】
vx(r0,c0)=2;  %起点
path(1,1)=r0;
path(1,2)=c0;
p=2;
while true
    for i=1:r
        if vx(i,c0)==0  %查询第c0列有没有没被访问过的数字格
            vx(i,c0)=1;  %若未被访问，加入路径表并标记
            r0=i;
            path(p,1)=i;
            path(p,2)=c0;
            path(p,3)=x(i,c0);
            p=p+1;
            break;
        end
    end
    for j=1:c 
        if vx(r0,j)==0  %查询第r0行有没有没被访问过的数字格
            vx(r0,j)=1;  %若未被访问，加入路径表并标记
            c0=j;
            path(p,1)=r0;
            path(p,2)=j;
            path(p,3)=x(r0,j);
            p=p+1;
            break;
        end
    end

    a=find(vx(r0,:)==0);
    b=find(vx(:,c0)==0);
    a1=find(vx(r0,:)==2);
    b1=find(vx(:,c0)==2);
    if isempty(a)&&isempty(b)  %判断该点所在行和列中有无未被访问的点
        if isempty(a1)==false || isempty(b1)==false  %判断最后访问的数字格是否跟起点在同一列或者同一行
            break;
        else  %如果不是的话，路就不通
            vx(r0,c0)=-1;
            for i=1:r
                for j=1:c
                    if vx(i,j)==1
                        vx(i,j)=0;
                    end
                end
            end
        r0=r1;
        c0=c1;

        path=-ones(r+c,3);
        path(1,1)=r1;
        path(1,2)=c1;
        p=2;
        end
    end
end

[rows,cols ]=size(path);
for i=1:rows
    if path(i,1)==-1
        break;
    end
end

path(i:rows,:)=[];  %删去路径表中多余的格子

add=path(1,:);
path=[path;add];  %将起点加到路径表末尾，构成回路
[row,col]=size(path);
i=1;

while true            
     if i==row-1
       break; 
     end
    i=i+1;
    if (path(i-1,1)==path(i+1,1))
        path(i,:)=[];
        row=row-1;
        i=i-1;
    end
    if (path(i-1,2)==path(i+1,2))
        path(i,:)=[];
        row=row-1; 
        i=i-1;
    end 
end
%起始点在闭回路中出现了两次,因此删去第二次出现的起始点
k=find(path(:,3)==-1);
path(k(2),:)=[];
[row2,col2]=size(path);
%将奇数编号和偶数编号分开

if mod(row2,2)==0    %若拐点总数是偶数
    single=zeros(row2/2,3);  %定义奇数编号
    double=zeros(row2/2,3);  %定义偶数编号
end
if mod(row2,2)==1    %若拐点总数是奇数
   single=zeros(row2/2+0.5,3);   %定义奇数编号
   double=zeros(row2/2-0.5,3);   %定义偶数编号
end
j1=1;
j2=1;
%将闭回路中的点按编号分别存入奇数表和偶数表
for i=1:row2
   if mod(i,2)==1
       single(j1,:)=path(i,:);
       j1=j1+1;
   end
   if mod(i,2)==0
      double(j2,:)=path(i,:);
      j2=j2+1;
   end
end
%更新运量表
value=double(:,3);
[min_x,index]=min(value);%找到编号偶数数字格的运量最小值及其位置
min_x1=0;
if min_x==pi-3
    min_x1=0;
else
    min_x1=min_x;
end
[row3,col3]=size(single);
[row4,col4]=size(double);
%将奇数编号数字格的运量加上min_x
for i=1:row3
    x(single(i,1),single(i,2))=x(single(i,1),single(i,2))+min_x;
    
end
%将偶数编号数字格的运量减去min_x
for i=1:row4
    x(double(i,1),double(i,2))=x(double(i,1),double(i,2))-min_x;
    
    
end
X=x;

end