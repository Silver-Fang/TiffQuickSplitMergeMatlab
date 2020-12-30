function TiffAppend(OutputFid,InputPaths,Flags)
arguments
	OutputFid(1,1)double
	InputPaths string
end
arguments(Repeating)
	Flags(1,1)string
end
%向已经打开的文件ID，在IFD维度上追加Tiff，按照BigTiff格式标准。使用低级读写，不需要LibTiff对LZW压缩进行解码，因此速度较快。
%% 语法说明
%TiffAppend(OutputFid,InputPaths)向OutputFid指定的文件ID，在当前文件指针位置追加写入InputPath指定的所有Tiff文件的所有IFD。此位置之后的原有字节会被覆盖。
%TiffAppend(___,Flags)与上述语法组合使用，指定可选附加功能，如是否添加文件头尾、自动寻找插入点、显示进度信息等。一个标准的Tiff文件必须有且仅有一对文件头和文件尾。
%% 示例
%在已有文件后追加并入Tiff文件
%OutputFid=fopen("C:\已有.tif","r+");
%TiffAppend(OutputFid,["输入1.tif";"输入2.tif"],"AutoSeek","AddTail");
%fclose(OutputFid);
%将已有Tiff合并到新的Tiff文件（建议用TiffMerge而不是此函数），并显示进度
%OutputFid=fopen("C:\已有.tif","w");
%TiffAppend(OutputFid,["输入1.tif";"输入2.tif","输入3.tif"],"AddHead","AddTail","Verbose");
%fclose(OutputFid);
%% 必需位置参数
%OutputFid，输出的文件ID，通常用fopen取得。函数完成后该文件ID不会自动关闭，请用fclose自行关闭。
%InputPaths，字符串数组，所有输入Tiff的路径。
%% 重复参数
%Flags，指定可选的附加功能，每个功能一个字符串：
%	AutoSeek，自动将文件指针定位到文件尾之前（最后一个IFD之后）再行写入
%	AddHead，添加文件头
%	AddTail，添加文件尾
%	Verbose，输出进度信息
%%
%See also TiffMerge fopen fclose fseek
%%
Flags=string(cat(1,Flags{:}));
if ismember("AutoSeek",Flags)
	fseek(OutputFid,-8,"eof");
end
if ismember("AddHead",Flags)
	fwrite(OutputFid,0x8002B4949,"uint64");
end
if ismember("Verbose",Flags)
	NumberOfIp=numel(InputPaths);
	Postfix="/"+num2str(NumberOfIp)+"个文件已并入";
	for a=1:NumberOfIp
		SingleAppend(OutputFid,InputPaths(a));
		disp(num2str(a)+Postfix);
	end
else
	for a=1:numel(InputPaths)
		SingleAppend(OutputFid,InputPaths(a));
	end
end
if ismember("AddTail",Flags)
	fwrite(OutputFid,0,"uint64");
end
end