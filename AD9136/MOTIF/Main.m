% Copyright (c) 2014, Analog Devices Inc. 
% All rights reserved.
% %源代码和二进制形式的重新分发和使用，有或没有

%允许修改，前提是以下条件：

%满足：

%

%1.源代码的重新分发必须保留上述版权

%注意，此条件列表和以下免责声明。

%

%2.二进制形式的再分配必须复制上述版权声明，

%本文件中的条件列表和以下免责声明：

%和/或与分配一起提供的其他材料。

%

%3.版权持有人的姓名或其

%贡献者可用于支持或推广由此衍生的产品

%未经特定事先书面许可的软件。

%

%本软件由版权所有人和贡献者提供

%以及任何明示或暗示保证，包括但不限于：，

%对特定产品的适销性和适用性的默示保证

%目的被否认。在任何情况下，版权持有人或

%出资人对任何直接、间接、附带、特殊、或，

%示例性或后果性损害（包括但不限于，

%采购替代货物或服务；使用、数据丢失，或

%利润；或业务中断），无论是何种原因造成的

%责任，无论是合同责任、严格责任还是侵权责任（包括

%疏忽或其他）以任何方式产生

%软件，即使被告知可能发生此类损坏。



%该文件的组织方式如下：

%1）音调生成

%2）产品配置

%3）模拟

%4）FFT

%

%以下代码是一个模板，您可以自己使用

%工作流程。请随意修改此文件以更改操作

%或者在更大的设计中模拟该模型。

%模拟参数

%注：产品配置见AD9136_configuration.m
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
% 1. Redistributions of source code must retain the above copyright
% notice, this list of conditions and the following disclaimer.
%
% 2.Redistributions in binary form must reproduce the above copyright notice,
% this list of conditions and the following disclaimer in the documentation
% and/or other materials provided with the distribution.
%
% 3. Neither the name of the copyright holder nor the names of its
% contributors may be used to endorse or promote products derived from this
% software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% This file is organized as such:
%   1) Tone generation
%   2) Product configuration
%   3) Simulation
%   4) FFT
%
% The following code is a template which you may use in your own
% work flow.  Feel free to modify this file to change operating
% conditions, or to simulate this model within a larger design.

% Simulation parameters
% NOTE: Product configuration is found in AD9136_Configuration.m
spectrumLevel_dB = -0.1;
fdata = 1.06e9;  % Data rate (in Hz)
                 % Constraints (adjust l in AD9136_Config.m):
                 %   l = 1, max fclk = 2.12e9
                 %   l = 2, max fclk = 1.06e9
                 %   l = 4, max fclk = 0.70e9
                 %   l = 8, max fclk = 0.35e9

OSR = 1;         % Over Sampling Ratio of analog output (e.g. 1, 2, 4, 8...)
numOfSamples = 2^12;
latency = 256;    % Extra data appended to numOfSamples
    
% Set the input tone frequency
infreq = 163.1e6;

% Calculate coherent frequency (assumes numOfSamples is a power of 2)
nCycles = floor(infreq * numOfSamples / fdata / 2) * 2 + 1;
spectrumCenter = nCycles / numOfSamples * fdata;

% Load the specified model into memory and returns a "key" to that file.
m = MOTIF_if('AD9136.pmf');

if (~m.isLoaded())
    disp('Error: Could not open file!  Check to see if you have the model file downloaded in your path.');
    return
end

% Configure the simulation.
AD9136_Configure(m, fdata, OSR);

% Return the relevant properties of the current ADC
props = m.queryPropValues();

% Make sure the clock frequency doesn't exceed maximum allowable value
max_fdata = str2double(props('settings.clkmax'));
if (fdata > max_fdata)
   fdata = max_fdata;
   disp('Warning: fclk (input data rate) too fast.  It will be coerced to maximum sample rate of converter');
   m.setProp('GLOBAL', 'fclk', num2str(fdata));
end

nBits = str2double(props('settings.nbits'));
commonMode = str2double(props('settings.offset'));
inputSpan = str2double(props('settings.range'));

inputMode = props('settings.inputmode');
if strcmp(inputMode, 'Offset Binary')
    bias = 2 ^ nBits / 2;
else
    bias = 0;
end

% Create a normalized frequency to generate the sinewave.创建标准化频率以生成正弦波。
frequency = spectrumCenter / fdata * numOfSamples;

% Convert spectrumLevel_dB into a peak amplitude voltage.% Convert spectrumLevel_dB into a peak amplitude voltage.
amplitude = (2 ^ nBits / 2) * 10 ^ (spectrumLevel_dB / 20);

% Generate a sinewave voltage input to the model.
n = 0:(numOfSamples+latency-1);
codes = round(amplitude * exp(1i * 2 * pi * frequency * n / numOfSamples) + bias * (1 + 1i));

% Run the model
[sinewave, interface] = m.runSamples(codes);

% Trim the output data to ignore startup transients
sinewave = sinewave(latency*interface.r+1:numOfSamples*interface.r+latency*interface.r);

% Normalize sinewave to full-scale
if interface.out.is_complex
    bias = commonMode * (1 + 1i);
else
    bias = commonMode;
end
sinewave = (sinewave - bias) / (inputSpan / 2);

% Take the FFT
nHarmonics = 2;
useHann = true;
complexOut = false;
sinewave = real(sinewave) + 1j * imag(sinewave) * complexOut;
harms = PlotFFT(sinewave, nHarmonics, 1, useHann, interface.out.f);

% Display DC, fundamental, and harmonic information (only accurate when
%   useHann is false)
%harms
