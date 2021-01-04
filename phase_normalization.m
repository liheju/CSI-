%��λ��һ��
function ret=phase_normalization(x)
    fc=[-28,-26,-24,-22,-20,-18,-16,-14,-12,-10,-8,-6,-4,-2,-1,...
    1,3,5,7,9,11,13,15,17,19,21,23,25,27,28];
    x=x+fc*312500*2*pi*200*10^-9;
    index=1;
    lambda1=(0-x(index))/(0.000312500*2*pi*fc(index));
%     x=x+fc*312500*2*pi*lambda1*10^-9;
    x(1:15)=x(1:15)+fc(1:15)*312500*2*pi*lambda1*10^-9;
    lambda2=(0-x(30))/(0.000312500*2*pi*fc(30));
    x(16:30)=x(16:30)+fc(16:30)*312500*2*pi*lambda2*10^-9;
    ret=x;
end