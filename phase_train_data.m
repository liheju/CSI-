%非相位相位误差特征获取
clear;
format long;
csilist=read_csilist('all.txt');
fc=[-28,-26,-24,-22,-20,-18,-16,-14,-12,-10,-8,-6,-4,-2,-1,...
    1,3,5,7,9,11,13,15,17,19,21,23,25,27,28];
band=312500;
freq=fc*band+2.442*10^9;
temp_y=zeros(1,30);
start=1;
unlegal=[];
P=[];
for t=1:30
    csi_trace = read_bf_file(csilist{t});
csi_phase_all=zeros(length(csi_trace),30);
n=2;
hangshu=5;
if length(csi_trace)>=2000
        start=1001;
else
    start=1;
end
for index=1:hangshu
count=1;
phase_set=[];
for i=(start-1+(1+200*(index-1))):(start-1+(1+200*(index-1))+199)
    csi_entry = csi_trace{i};
    point=2;
    csi=squeeze(get_scaled_csi(csi_entry));
    if csi_entry.Ntx==2
        csi=squeeze(csi(1,:,:));
    end
    csi_phase=angle(csi);
    temp=(csi_phase(point,:));
    ph_line=unwrap(temp);
    center=(ph_line(15)+ph_line(16))/2;
    ph_normalization=ph_line-center;
     decision=derivative(fc,ph_normalization);
     if legal(decision)
         ph_normalization=phase_normalization(ph_normalization);
         phase_set(count,:)=ph_normalization;
         count=count+1;
     else
     end
end
    ph_average=mean(phase_set,1);
    int_phase=ph_average;
    ptrain=[int_phase,(ceil(t/1))];
    P(hangshu*(t-1)+index,:)=ptrain;
end
end
matrix=P;
%非相位相位误差分类测试
t_num=100;
nu=5;
n = randperm(size(matrix,1));
train_data = matrix(n(1:t_num),1:30);
train_label = matrix(n(1:t_num),31);
test_data = matrix(n((t_num+1):end),1:30);
test_label = matrix(n((t_num+1):end),31);
[bestacc,bestc,bestg] = lhj_SVMcg(train_label,train_data);
cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg)];
%训练
model = svmtrain(train_label, train_data,cmd);
%测试
[predicted_label, accuracy, prob_estimates] = svmpredict(test_label, test_data, model);
%每一类的精度
for i=1:nu
     count_right=0;
     lo=find(test_label==i);
     tot(1,i)=length(lo);
     for j=1:length(lo)
     if test_label(lo(j))==predicted_label(lo(j))
         count_right=count_right+1;
     end
     end
     acc(1,i)=count_right./tot(1,i);
end
%真阳性假阳性等等
len=150-t_num;
for i=1:nu
    tp = 0;
    fn = 0;
    fp = 0;
    tn = 0;
      for y = 1:len
        if predicted_label(y,1)==i && test_label(y,1)==i
            tp=tp+1;
        elseif predicted_label(y,1)==i && test_label(y,1)~=i
            fp=fp+1;
        elseif predicted_label(y,1)~=i && test_label(y,1)==i
            fn=fn+1;
        elseif predicted_label(y,1)~=i && test_label(y,1)~=i
            tn=tn+1;
        end
      end
    T_PR(1,i) = tp/(tp+fn);
    F_PR(1,i)= fp/(tn+fp);
end