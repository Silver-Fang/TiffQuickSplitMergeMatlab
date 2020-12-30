function [ToPrecision,NotPrecision,ItFunction,TagSize] = ReadHeader(IFid)
%读取Tiff文件头。仅供内部使用，请勿直接调用。
fseek(IFid,2,"bof");
if fread(IFid,1,"uint16=>uint16")==43
	%作为BigTiff读入
	fseek(IFid,8,"bof");
	ToPrecision="uint64=>uint64";
	NotPrecision="uint64=>uint64";
	ItFunction=@IfdTransferBig;
	TagSize=20;
else
	%作为标准Tiff读入
	fseek(IFid,4,"bof");
	ToPrecision="uint32=>uint32";
	NotPrecision="uint16=>uint16";
	ItFunction=@IfdTransferSmall;
	TagSize=12;
end
end