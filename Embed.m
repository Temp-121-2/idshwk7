mypicture = imread('e:\carrier.bmp');
%figure(),image(mypicture),title('原输入图像');
grayImage = rgb2gray(mypicture);
%figure(),image(grayImage),title('原图像');

%sigma1 = 1
%gsn = wgn(240,320,20);

%for i1 = 1:9
a = 0.1;     %定义参数a
hidepicture = imread('e:\hide.bmp');        %读入水印图像
HgrayImage = rgb2gray(hidepicture);

%figure(),image(grayImage),title('原图像');
figure(),image(HgrayImage),title('水印图像');

L = size(grayImage);

hight = 30;    %块大小
width = 40;    

max_row = L(1)/hight;
max_col = L(2)/width;

for row = 1:max_row    %分割图像为8*8块
for col = 1:max_col
seg(row,col) = {grayImage((row-1)*hight+1:row*hight,(col-1)*width+1:col*width,:)};
end
end

%for i = 1:max_row*max_col
%figure(),image(seg{3}),title('分割图像');
%end

m = 1;   %(m,n)
n = 1;
f = 1;

for i = 1:64    %zig排列
if n == 1 
     if m == 1
          zig{i} = seg{1};
          m = m+1;n=n;
          continue
     elseif m ~= 1
         if f == 1
             zig{i} = seg{(m-1)*8+n};
             m = m - 1;n = n + 1;
             continue
         elseif f == -1
             zig{i} = seg{(m-1)*8+n};
             m = m + 1;n = n;f = 1;
             continue
         end
     end
elseif n == 8
    if m ~= 8 
        if f == -1
            zig{i} = seg{(m-1)*8+n}; 
            m = m + 1;n = n - 1;
            continue
        elseif f == 1
            zig{i} = seg{(m-1)*8+n};
            m = m + 1;n = n;f = -1;
            continue
        end
    end
end

if m == 1
    if n ~= 1
        if f == 1
            zig{i} = seg{(m-1)*8+n}; 
            m = m; n = n + 1; f = -1;
            continue
        elseif f == -1 
            zig{i} = seg{(m-1)*8+n}; 
            m = m + 1; n = n - 1;
            continue
        end
    end
elseif m == 8
    if n ~= 8
        if f == -1
           zig{i} = seg{(m-1)*8+n}; 
           m = m; n = n + 1; f = 1;
           continue
        elseif f == 1
           zig{i} = seg{(m-1)*8+n}; 
           m = m - 1;n = n + 1;
           continue
        end
    end
end

if m ~= 1 && n ~= 1
    if f == 1
        zig{i} = seg{(m-1)*8+n}; 
        m = m - 1;n = n + 1;
        continue
    elseif f == -1
        zig{i} = seg{(m-1)*8+n};
        m = m + 1; n = n - 1;
        continue
    end
end

if n == 8 && m ==  8
    zig{i} = seg{64};
end
end

for i = 1:64       %dct变换
dct{i}=dct2(zig{i});
end

%figure(),image(dct{4}),title('分割图像');


%figure(),image(grayImage),title('灰度图像');

%dctgrayImage=dct2(grayImage);
%figure(),image(dctgrayImage);


dct1 = dct;


for i = 1:64     %嵌入
for j = 0:9

    dct1{i}(29-3*j,1+4*j)=dct{i}(29-3*j,1+4*j) + a*double(HgrayImage((i-1)*100+10*j+1));    
    dct1{i}(30-3*j,1+4*j)=dct{i}(30-3*j,1+4*j) + a*double(HgrayImage((i-1)*100+10*j+2));
    dct1{i}(28-3*j,2+4*j)=dct{i}(28-3*j,2+4*j) + a*double(HgrayImage((i-1)*100+10*j+3));
    dct1{i}(29-3*j,2+4*j)=dct{i}(29-3*j,2+4*j) + a*double(HgrayImage((i-1)*100+10*j+4));
    dct1{i}(30-3*j,2+4*j)=dct{i}(30-3*j,2+4*j) + a*double(HgrayImage((i-1)*100+10*j+5));
    dct1{i}(28-3*j,3+4*j)=dct{i}(28-3*j,3+4*j) + a*double(HgrayImage((i-1)*100+10*j+6));
    dct1{i}(29-3*j,3+4*j)=dct{i}(29-3*j,3+4*j) + a*double(HgrayImage((i-1)*100+10*j+7));
    dct1{i}(30-3*j,3+4*j)=dct{i}(30-3*j,3+4*j) + a*double(HgrayImage((i-1)*100+10*j+8));
    dct1{i}(28-3*j,4+4*j)=dct{i}(28-3*j,4+4*j) + a*double(HgrayImage((i-1)*100+10*j+9));
    dct1{i}(29-3*j,4+4*j)=dct{i}(29-3*j,4+4*j) + a*double(HgrayImage((i-1)*100+10*j+10));
end
end

for i = 1:64
idct{i} = idct2(dct1{i});
end

%for i = 1:max_row*max_col
%figure(),image(idct{i}),title('嵌入后分块图像');
%end

m = 1
n = 1
f = 1

for i = 1:64    %反zig排列
if n == 1 
     if m == 1
          seg{1} = idct{i};
          m = m+1;n=n;
          continue
     elseif m ~= 1
         if f == 1
             seg{(m-1)*8+n} = idct{i};
             m = m - 1;n = n + 1;
             continue
         elseif f == -1
             seg{(m-1)*8+n} = idct{i};
             m = m + 1;n = n;f = 1;
             continue
         end
     end
elseif n == 8
    if m ~= 8 
        if f == -1
            seg{(m-1)*8+n} = idct{i}; 
            m = m + 1;n = n - 1;
            continue
        elseif f == 1
            seg{(m-1)*8+n} = idct{i};
            m = m + 1;n = n;f = -1;
            continue
        end
    end
end

if m == 1
    if n ~= 1
        if f == 1
            seg{(m-1)*8+n} = idct{i}; 
            m = m; n = n + 1; f = -1;
            continue
        elseif f == -1 
            seg{(m-1)*8+n} = idct{i}; 
            m = m + 1; n = n - 1;
            continue
        end
    end
elseif m == 8
    if n ~= 8
        if f == -1
           seg{(m-1)*8+n} = idct{i}; 
           m = m; n = n + 1; f = 1;
           continue
        elseif f == 1
           seg{(m-1)*8+n} = idct{i}; 
           m = m - 1;n = n + 1;
           continue
        end
    end
end

if m ~= 1 && n ~= 1
    if f == 1
        seg{(m-1)*8+n} = idct{i}; 
        m = m - 1;n = n + 1;
        continue
    elseif f == -1
        seg{(m-1)*8 + n} = idct{i};
        m = m + 1; n = n - 1;
        continue
    end
end

if n == 8 && m ==  8
    seg{(m-1)*8+n} = seg{64};
end
end

for i = 0:7
C{i+1}=[seg{1+8*i};seg{2+8*i};seg{3+8*i};seg{4+8*i};seg{5+8*i};seg{6+8*i};seg{7+8*i};seg{8+8*i}];
end

embed = [C{1},C{2},C{3},C{4},C{5},C{6},C{7},C{8}];

embed = uint8(embed);
figure(),image(embed),title('嵌入后图像');
imwrite(embed,'e:\embed.bmp');

