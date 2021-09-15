clc; %�������������
clear all; %�������������,�ͷ��ڴ�ռ�
F1=1; %�ź�Ƶ��
Fs=2^10; %����Ƶ��
P1=0; %�źų�ʼ��λ
N=2^10; %��������
t=[0:1/Fs:(N-1)/Fs]; %����ʱ��
ADC=2^7 - 1; %ֱ������
A=2^7; %�źŷ���
%����mif�ļ�
fild = fopen('wave.txt','wt');
%д��mif�ļ�ͷ
fprintf(fild, '%s\n','#WIDTH=8;'); %λ��
fprintf(fild, '%s\n\n','#DEPTH=4096;'); %���
%���������ź�
s=A*sin(2*pi*F1*t + pi*P1/180) + ADC;
plot(s); %����ͼ��
%д������
for i = 1:N
s0(i) = round(s(i)); %��С������������ȡ��
if s0(i) <0 %��1ǿ������
s0(i) = 0
end
fprintf(fild, '%s\n',dec2bin(s0(i),8)); %����д��
end
s=A*square(2*pi*F1*t + pi*P1/180) + ADC;
plot(s); %����ͼ��
%д������
for i = 1:N
s0(i) = round(s(i)); %��С������������ȡ��
if s0(i) <0 %��1ǿ������
s0(i) = 0
end
fprintf(fild, '%s\n',dec2bin(s0(i),8)); %����д��
end
s=A*sawtooth(2*pi*F1*t + pi*P1/180,0.5) + ADC;
plot(s); %����ͼ��
%д������
for i = 1:N
s0(i) = round(s(i)); %��С������������ȡ��
if s0(i) <0 %��1ǿ������
s0(i) = 0
end
fprintf(fild, '%s\n',dec2bin(s0(i),8)); %����д��
end
s=A*sawtooth(2*pi*F1*t + pi*P1/180) + ADC;
plot(s); %����ͼ��
%д������
for i = 1:N
s0(i) = round(s(i)); %��С������������ȡ��
if s0(i) <0 %��1ǿ������
s0(i) = 0
end
fprintf(fild, '%s\n',dec2bin(s0(i),8)); %����д��
end
fclose(fild);