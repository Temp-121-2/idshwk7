​	此算法是基于空间域信息隐藏，是将信息隐藏到载体图像的DCT变换结果中，对高斯噪声，图片切割具有良好的抵抗能力。

​		此算法是我在选修课“信息隐藏和数字水印”的课程作业，使用matlab，能够对320﹡240的灰度图像中嵌入80﹡80的隐藏信息，并可以调节入嵌入深度。



文件介绍：

- Embed.m：隐藏算法，读取载体图像carrier.bmp和隐藏图像hide.bmp，写入隐藏结果embed.bmp
- Extract.m：提取算法，读取embed.bmp和carrier.bmp，提取出隐藏图像
- carrier.bmp：载体图像320﹡240
- hide.bmp：隐藏图像80﹡80
- embed.bmp：隐藏后图像320﹡240

​	

隐藏方法：给出test.bmp和hide.bmp，运行Embed.m，就能得到embed.bmp

提取方法：给出embed.bmp和carrier.bmp，运行Extract.m，就能够得到hide.bmp

注意：运行前需要确保Embed.m，Extract.m中图片的路径正确



算法原理：见"原理.pdf"

