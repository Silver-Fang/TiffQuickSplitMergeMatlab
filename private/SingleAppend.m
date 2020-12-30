function SingleAppend(OutputFid,InputPath)
%向给定文件ID追加单个Tiff文件。仅限内部使用，不建议直接调用。
IFid=fopen(InputPath,"r");
[ToPrecision,~,ItFunction,~] = ReadHeader(IFid);
TailOffset=fread(IFid,1,ToPrecision);
while TailOffset>0
	ItFunction(TailOffset,IFid,OutputFid);
	TailOffset=fread(IFid,1,ToPrecision);
end
fclose(IFid);
end