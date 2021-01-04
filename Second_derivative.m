function ret=Second_derivative(x)
len=length(x);
dd=zeros(1,len-1);
for i=1:len-1
    dd(i)=x(i+1)/x(i);
end
ret=dd;
end