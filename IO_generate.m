close all;
clear;
clc;
% Warning: Don't run this file in a folder containing other txt files
% it will delete them
delete *.txt;
% Generating the first initial 129 clock cycles outputs after the reset
% and saving them to .txt files
Pos=zeros(129,1);
V=zeros(129,1);
V(2)=1;
HW=zeros(129,1);
fid = fopen('Pos.txt','a');% position of "1"s in a frame
fid1 = fopen('V.txt','a'); % valid signal
fid2 = fopen('HW.txt','a');% Hamming Weight output
for i=1:1:129
    fprintf(fid,'%03s\n',dec2hex(Pos(i)));
    fprintf(fid1,'%d\n',V(i));
    fprintf(fid2,'%02s\n',dec2hex(HW(i)));
end
fclose(fid);
fclose(fid1);
fclose(fid2);
% for 100 frames
for j=1:1:100
    %Generating input sequance
    Y=rand(8,128);%Uniformly distributed numbers
    A=(Y<31/1024);%Probability of "1" is 31/1024
    A=[A,zeros(8,1)];
    No1s=sum(sum(A));
    % Remove extra "1"s if any in a frame
    while (No1s>31)
        Rmv=No1s-31;
        Ai=find(A);
        RandRmv=randi(size(Ai,1),1,Rmv);
        A(Ai(RandRmv))=0;
        No1s=sum(sum(A));
    end
    %Saving the inputs into sequance .txt file
    A=real(A);
    ind=[0,1,2,3,4,5,6,7]';
    pow=2.^ind;
    fid = fopen('Input.txt','a');
    for i=1:1:129
        in=A(:,i);
        d=sum(in.*pow,1);
        h=dec2hex(d);
        fprintf(fid,'%02s\n',h);
    end
    fclose(fid);
    % Generating the expected output and saving them to .txt files
    if (No1s~=0)
        pos=find(A)-1;
        Pos=zeros(129,1);
        Pos(2:size(pos,1)+1)=pos;
        V=zeros(129,1);
        V(2:size(pos,1)+1)=1;
        HW=zeros(129,1);
        HW(2:size(pos,1)+1)=No1s;
    else% if it is an all zero frame
        Pos=zeros(129,1);
        V=zeros(129,1);
        V(2)=1;
        HW=zeros(129,1);
    end
    fid = fopen('Pos.txt','a');
    fid1 = fopen('V.txt','a');
    fid2 = fopen('HW.txt','a');
    for i=1:1:129
        fprintf(fid,'%03s\n',dec2hex(Pos(i)));
        fprintf(fid1,'%d\n',V(i));
        fprintf(fid2,'%02s\n',dec2hex(HW(i)));
    end
    fclose(fid);
    fclose(fid1);
    fclose(fid2);
end