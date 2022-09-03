% Copyright (c) 2014, Analog Devices Inc. 
% All rights reserved.
% 
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

Description:
  Model   AD9136.pmf
  DLL     MOTIF.dll or libMOTIF.so
  Arch    64-bit
  Version 1.0.0.15
  
  This code simulates operation of the AD9136.  The simulation generates a tone, passes it 
  through a model of the device, and takes an FFT of the results.  It also allows the user
  to configure some digital features of the device.  Feel free to modify the code to suit
  your application.

Install:
  Unzip the contents into some working folder.
  
Usage:
  From Simulink, open AD9136.slx and run.  Edit the mask to change the device under simulation. 
  The simulation uses frames, so it has to be Sample based.

  To change the simulation/model conditions, navigate to the Model Properties | Callbacks | InitFcn Callbacks
    (File > Model Properties > Model Properties)

  Under the AD9136 Mask, you can change the Output Configuration. 
    Normalized, where the output is normalize to be between -1 and 1.
    Absolute, where the output is in absolute current.
  
  From the MATLAB shell, run Main.m by typing "Main" (it may prompt you to change directories)
  To change the behavior of the model modify AD9136_Configuration.m, save, and rerun Main.

Troubleshoot:
  If MATLAB complains that a compiler has not been selected, type "mex -setup" and follow the instrustions.
  Rerun Main.m
  
  If MATLAB complains that there is a problem with loadlibrary, it might be an issue with having
  a valid supported C compiler.  In Windows, MATLAB doesn't work with Microsoft Visual Studio 2010
  Redistributables.  You will need to uninstall any references to VS 2010 Redistributable and 
  install the Windows SDK 7.1.

  For support or questions, please use EngineerZone (ez.analog.com)
 
  
  描述：

型号AD9136.pmf

DLL主题。dll或libMOTIF.so

Arch 64位

版本1.0.0.15



此代码模拟AD9136的操作。模拟生成音调，并将其传递

并对结果进行FFT。它还允许用户

以配置设备的一些数字功能。请随意修改代码以适应

这是您的应用程序。



安装：

将内容解压缩到某个工作文件夹中。



用法：

在Simulink中，打开AD9136.slx并运行。编辑遮罩以更改模拟下的设备。

模拟使用帧，因此必须基于样本。



要更改模拟/模型条件，请导航到模型属性|Callbacks| InitFcn Callbacks

（文件>模型属性>模型属性）



在AD9136掩码下，您可以更改输出配置。

归一化，其中输出被归一化为介于-1和1之间。

绝对，其中输出为绝对电流。



在Matlabshell中，运行Main。m通过键入“Main”（它可能会提示您更改目录）

要更改模型的行为，请修改AD9136_Configuration。m、 保存并重新运行Main。



故障排除：

如果MATLAB抱怨未选择编译器，请键入“mex-setup”并遵循指令。

重新运行Main.m



如果MATLAB抱怨loadlibrary存在问题，则可能是因为

有效的受支持的C编译器。在Windows中，MATLAB不能与Microsoft Visual Studio 2010一起工作

可再发行。您需要卸载对VS 2010可再发行版和

安装Windows SDK 7.1。



有关支持或问题，请使用EngineerZone（ez.analog.com）
