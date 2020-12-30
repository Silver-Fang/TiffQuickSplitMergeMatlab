# TiffQuickSplitMergeMatlab
这是一个以IFD为单位对Tiff进行快速拆分与合并的工具包。因为无需解析IFD内容，所以能够快速操作应用了压缩算法的Tiff，无需解析IFD内部信息，无需解码，直接底层剪接。

LibTiff没有提供自带的IFD维度上快速合并/拆分的算法。对于压缩了的Tiff文件，只能先解码写入内存，再重新编码写入合并的新文件。但实际上，Tiff文件中各个IFD彼此是独立压缩的，在IFD维度上进行合并，并不需要读出图像的实际值，这就有了性能优化的空间。本工具利用这一点，绕过LibTiff层直接进行底层读写，避免解压/压缩步骤，实现快速合并/拆分。

公开以下函数：

TiffCountIfds，清点Tiff中IFD的个数

TiffSplit，并行拆分单个Tiff为多个文件

TiffMerge，顺序合并多个Tiff为单个文件，也可以追加到已有Tiff
