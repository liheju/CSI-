function ret=read_csilist(x)
fileID = fopen(x);
C = textscan(fileID,'%s');
fclose(fileID);
d=C{1,1};
f=d';
ret=f;
end