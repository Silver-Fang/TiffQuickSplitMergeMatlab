function IfdTransferBig(TailOffset,IFid,OutputFid)
%转移单个大Ifd。仅限内部使用，请勿直接调用。
BodyLength=TailOffset-ftell(IFid);
fwrite(OutputFid,ftell(OutputFid)+8+BodyLength,"uint64");
StripeOffset=ftell(OutputFid);
fwrite(OutputFid,fread(IFid,BodyLength,"uint8=>uint8"),"uint8");
NumberOfTags=fread(IFid,1,"uint64=>uint64");
fwrite(OutputFid,NumberOfTags,"uint64");
for b=1:NumberOfTags
	TagHead=fread(IFid,1,"uint16=>uint16");
	%特殊处理StripeOffsets标签值
	if TagHead==0x0111
		fwrite(OutputFid,[TagHead;fread(IFid,5,"uint16=>uint16")],"uint16");
		fwrite(OutputFid,StripeOffset,"uint64");
        fseek(IFid,8,"cof");
		break;
	else
		fwrite(OutputFid,[TagHead;fread(IFid,9,"uint16=>uint16")],"uint16");
	end
end
fwrite(OutputFid,fread(IFid,(NumberOfTags-b)*20,"uint8=>uint8"),"uint8");
end