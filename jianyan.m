function [sigma] = jianyan(N,c,r,x)
%位势法求检验数
ui=inf*ones(r,1);%定义ui
vj=inf*ones(1,c);%定义vj,位势法  
i=1;
special=zeros(round((c+r-1)/2),2);
f=1;
sigma=exp(1)*ones(r,c);
ui(1,1)=0;
for j=1:c 
    if x(i,j)~=0
        
        vj(1,j)=N(i,j)-0;  %令u1=0
    end
end

for i=2:r 
    for j=1:c
        if x(i,j)~=0
            if vj(1,j)~=inf && ui(i,1)==inf
                ui(i,1)=N(i,j)-vj(1,j);
            elseif vj(1,j)==inf && ui(i,1)~=inf
                vj(1,j)=N(i,j)-ui(i,1);
            elseif vj(1,j)==inf && ui(i,1)==inf
                special(f,1)=i;
                special(f,2)=j;
                vj(1,j)=inf;
                ui(i,1)=inf;
                f=f+1;
                continue;

            end
        else
            continue;
        end
    end
end

if f==1  %完善ui,vj
    
else
    f=f-1;  %表示special表记录了多少个坐标
    for t=1:f
        for i=1:r
            if x(i,special(t,2))==0
                continue;
            else
                if ui(i,1)==inf
                    continue;
                else
                    vj(1,special(t,2))=N(i,special(t,2))-ui(i,1);
                end
            end
        end
        for j=1:c
            if x(special(t,1),j)==0
                continue;
            else
                if vj(1,j)==inf
                    continue;
                else
                    ui(special(t,1),1)=N(special(t,1),j)-vj(1,j);
                end
            end
        end
        %再次检查ui,vi是否为常数（非inf）
        if i==r
            for i=1:r
            if x(i,special(t,2))==0
                continue;
            else
                vj(1,special(t,2))=N(i,special(t,2))-ui(i,1); 
            end
            end
        end

        if j==c
            for j=1:c
            if x(special(t,1),j)==0
                continue;
            else
                ui(special(t,1),1)=N(special(t,1),j)-vj(1,j);
            end
            end
        end
    end
end
                
for i=1:r
    for j=1:c
        if x(i,j)==0
            sigma(i,j)=N(i,j)-ui(i,1)-vj(1,j);
        else
            sigma(i,j)=0;
        end
    end
end

end