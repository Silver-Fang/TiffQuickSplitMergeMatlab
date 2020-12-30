function IfdTransferSmall(TailOffset,IFid,OutputFid)
%转移单个小Ifd。仅限内部使用，请勿直接调用。
BodyLength=TailOffset-ftell(IFid);
fwrite(OutputFid,ftell(OutputFid)+8+BodyLength,"uint64");
StripeOffset=ftell(OutputFid);
fwrite(OutputFid,fread(IFid,BodyLength,"uint8=>uint8"),"uint8");
NumberOfTags=fread(IFid,1,"uint16=>uint16");
fwrite(OutputFid,NumberOfTags,"uint64");
for b=1:NumberOfTags
	TagHead=fread(IFid,1,"uint32=>uint32");
	%特殊处理StripeOffsets标签值
	if TagHead==0x40111
		fwrite(OutputFid,0x100111,"uint32");
		fwrite(OutputFid,fread(IFid,1,"uint32=>uint32"),"uint64");
		fwrite(OutputFid,StripeOffset,"uint64");
		fseek(IFid,4,"cof");
	else
		fwrite(OutputFid,TagHead,"uint32");
		fwrite(OutputFid,fread(IFid,2,"uint32=>uint32"),"uint64");
	end
end
end