clc;clear all;close all;

%% System parameters
N =1024*64;%2^16
Fs =1000000000;%Hz
Ts =1/Fs;

f_solution=Fs/N
t_solution=N/Fs
%% Input signal parameters

A = 1;
t = (0:N-1)*Ts;
ft_0 =30000;
vi_0=zeros(1,N);
ft_1 =10000000;
vi_1=zeros(1,N);
vi=zeros(1,N);
vim=zeros(1,N);

for n =1:N
    vi_0(n) =A*sin(2*pi*ft_0*t(n));
    vi_1(n) =A*sin(2*pi*ft_1*t(n));
    vi(n) = vi_0(n)+vi_1(n);
end

vi_in(:,1) =1:N;
vi_in(:,2)=vi;
vim_in(:,1) =1:N;
vim_in(:,2)=vim;

figure(1)
subplot(3,1,1);
plot(t,vi_0,'k');
subplot(3,1,2);
plot(t,vi_1,'k');
subplot(3,1,3);
plot(t,vi,'k');

[Fre0,Amp0]=fft_plot(vi_0,Fs,N);
[Fre1,Amp1]=fft_plot(vi_1,Fs,N);
[Fre,Amp]=fft_plot(vi,Fs,N);

figure(2)
subplot(3,1,1);
plot(Fre0,Amp0,'k');
subplot(3,1,2);
plot(Fre1,Amp1,'k');
subplot(3,1,3);
plot(Fre,Amp,'k');

%% Post-processing of system generator FFT output 
start = 2166;% Need to modify the starting position
FFTData1=out.sysgen_fft_output.Data;% Extract time series data
FFTData=abs(FFTData1(start:start+N-1))/N;

%From fft_plot function file
FFTAmplitude_FFTData1 = FFTData(1:N/2);
FFTAmplitude_FFTData1(2:end) = 2*FFTAmplitude_FFTData1(2:end);
Frequence_FFTData1 = Fs*((0:(N/2)-1))/N;

figure(3)
subplot(2,1,1);
plot(Fre,Amp,'k');
subplot(2,1,2);
plot(Frequence_FFTData1,FFTAmplitude_FFTData1,'k');
