function ret=legal(x)
dd=Second_derivative(x);
if all(x<0)||all(x>0)
%     if all(dd>3/5)&&all(dd<7/5)
    if all(dd>2/3)&&all(dd<4/3)
        ret=true;
    else
        ret=false;
    end
else
    ret=false;
end

end