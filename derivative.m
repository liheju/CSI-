function ret=derivative(x,y)
len=length(x);
diffe1=diff(x);
diffe2=diff(y);
temp=zeros(1,len-1);
for i=1:len-1
    temp(i)=diffe2(i)/diffe1(i);
end
ret=temp;
end