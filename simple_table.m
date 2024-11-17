
function [x1,z]=simple_table(N,pro,need)
%表上作业法
%N为运价表，pro为生产量（行向量），need为需求量（行向量）
%x为最优运输方案，z为最小运价

pro=cell2mat(pro);
need=cell2mat(need);
N=cell2mat(N);  
%将cell类型数组，转变为普通数据类型的数组
summary1=sum(pro);
summary2=sum(need);
if summary1>summary2
    [r0,c0]=size(N);
    new=zeros(r0,1);
    N=[N,new];
    need=[need,summary1-summary2];
    disp("供大于需，添加虚拟需求地");

elseif summary2>summary1
    [r0,c0]=size(N);
    new=zeros(1,c0);
    N=[N;new];
    pro=[pro,summary2-summary1];
    disp("需大于供，添加虚拟生产地");

else
    disp("供需平衡");
end

[r,c]=size(N);
ui=zeros(r,1);%定义ui
vj=zeros(1,c);%定义vj,位势法
out1=pro;%求初始解过程中的产量
in1=need;%需求量
sigma=exp(1)*ones(r,c);%检验数表
x=zeros(r,c);
z=0;

%西北角法确定初始解
jishu=0;
for i=1:r 
    for j=1:c 
        if out1(i)~=0 && in1(j)~=0
            if out1(i)>in1(j)
                x(i,j)=in1(j);
                jishu=jishu+1;
                out1(i)=out1(i)-x(i,j);
                in1(j)=0;
            else
                x(i,j)=out1(i);
                jishu=jishu+1;
                out1(i)=0;
                in1(j)=in1(j)-x(i,j);
            end
            sigma(i,j)=0;
        else
            continue;
        end
    end
end
x1=x;
q=jishu;
done=false;
for i=1:r 
    for j=1:c
        if q==r+c-1
            done=true;
            break;
        else
            if x(i,j)==pro(i)&&x(i,j)==need(j)
                q=q+1;
                if i~=r 
                    x(i+1,j)=pi-3;
                end
            end
        end
    end
    if done
        break;
    end
end              

while true
    sigma=jianyan(N,c,r,x);  %判断是否为最优方案
    sigma1=sigma;
    negative=sum(sigma<0);  %检验数中是否存在小于0的
   for i=1:r
        for j=1:c
            if x(i,j)~=0
                sigma1(i,j)=inf;  %数字格检验数不考虑
            end
        end
    end

    if sigma1>0
    disp("有唯一最优解")
    for i=1:r 
        for j=1:c 
            z=z+N(i,j)*x1(i,j);
        end
    end
    disp("最小运费为");
    disp(z);
    break;

    
    elseif sigma1>=0
    disp("最优解不唯一");
     for i=1:r 
        for j=1:c 
            z=z+N(i,j)*x(i,j);
        end
    end
    disp("最小运费为");
    disp(z);
    break;


    else   %存在检验数小于0
        [x,x1]=CircleChange(x,c,r,sigma,x1);
    end
end


%伏格尔法求初始解
%%pro1=pro;
%need1=need;
%a=zeros(r,1);%定义列差额
%b=zeros(1,c);%行
%n1=N;
%for k=1:r
%    column=n1(k,:);
%    [minvalve,minindex]=min(column);
%    column(minindex)=inf;
%    secondminvalue=min(column);
%    a(k,1)=secondminvalue-minvalve;
%end
%for k=1:c
%    column=n1(:,k);
%    [minvalve,minindex]=min(column);
%    column(minindex)=inf;
%    secondminvalue=min(column);
%    b(1,k)=secondminvalue-minvalve;
%end
%while true
%    [amax,i1]=max(a);
%    [bmax,j1]=max(b);
%    for i=1:c
%        if need(i)==0
%            b(1,c)=-1;
%        end
%    end
%    for j=1:r
%        if pro(j)==0
%            a(j,1)=-1;
%        end
%    end


%   if amax>bmax
%        col=N(i1,:);
%        [mim ,j2]=min(col);
%        x(i1,j2)=min(pro(i1),need1(j2));
%        if x(i1,j2)==pro1(i1)
%            need1(j2)=need1(j2)-pro1(i1);
%            pro1(i1)=-1;
%            a(i1,1)=-1;
%        elseif x(i1,j2)==need1(j2)
%            pro1(i1)=pro1(i1)-need1(j2);
%            need1(j2)=-1;
%            b(1,j2)=-1;
%        end
%    else
%        
%        row=N(:,j1);
%        [mim ,i2]=min(row);
%        x(i2,j1)=min(pro1(i2),need1(j1));
%        if x(i2,j1)==pro1(i2)
%            need1(j1)=need1(j1)-pro1(i2);
%            pro1(i2)=0;
%            a(i2,1)=-1;
%            
%        elseif x(i2,j1)==need1(j1)
%            pro1(i2)=pro1(i2)-need1(j1);
%           need1(j1)=0;
%           b(1,j1)=-1;
%
%    end
%
%    if all(a==-1)&&all(b==-1)
%        break;
%   end
%%end

 







