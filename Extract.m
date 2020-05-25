mypicture = imread('e:\carrier.bmp');
embed = imread('e:\embed.bmp');

grayImage = rgb2gray(mypicture);

a = 0.1;

%分块
L2 = size(embed);

hight = 30;    %块大小
width = 40;    

max_row = L2(1)/hight;
max_col = L2(2)/width;

 for row = 1:max_row    %分割图像为8*8块
    for col = 1:max_col
        Seg(row,col) = {grayImage((row-1)*hight+1:row*hight,(col-1)*width+1:col*width,:)};
    end
 end


m = 1;   %(m,n)
n = 1;
f = 1;

for i = 1:64    %zig排列
    if n == 1 
         if m == 1
              Zig{i} = Seg{1};
              m = m+1;n=n;
              continue
         elseif m ~= 1
             if f == 1
                 Zig{i} = Seg{(m-1)*8+n};
                 m = m - 1;n = n + 1;
                 continue
             elseif f == -1
                 Zig{i} = Seg{(m-1)*8+n};
                 m = m + 1;n = n;f = 1;
                 continue
             end
         end
    elseif n == 8
        if m ~= 8 
            if f == -1
                Zig{i} = Seg{(m-1)*8+n}; 
                m = m + 1;n = n - 1;
                continue
            elseif f == 1
                Zig{i} = Seg{(m-1)*8+n};
                m = m + 1;n = n;f = -1;
                continue
            end
        end
    end

    if m == 1
        if n ~= 1
            if f == 1
                Zig{i} = Seg{(m-1)*8+n}; 
                m = m; n = n + 1; f = -1;
                continue
            elseif f == -1 
                Zig{i} = Seg{(m-1)*8+n}; 
                m = m + 1; n = n - 1;
                continue
            end
        end
    elseif m == 8
        if n ~= 8
            if f == -1
               Zig{i} = Seg{(m-1)*8+n}; 
               m = m; n = n + 1; f = 1;
               continue
            elseif f == 1
               Zig{i} = Seg{(m-1)*8+n}; 
               m = m - 1;n = n + 1;
               continue
            end
        end
    end

    if m ~= 1 && n ~= 1
        if f == 1
            Zig{i} = Seg{(m-1)*8+n}; 
            m = m - 1;n = n + 1;
            continue
        elseif f == -1
            Zig{i} = Seg{(m-1)*8+n};
            m = m + 1; n = n - 1;
            continue
        end
    end

    if n == 8 && m ==  8
        Zig{i} = Seg{64};
    end
end

for i = 1:64       %dct变换
    Dct{i}=dct2(Zig{i});
end




for row = 1:max_row    %分割图像为8*8块
    for col = 1:max_col
        seg2(row,col) = {embed((row-1)*hight+1:row*hight,(col-1)*width+1:col*width,:)};
    end
end

m = 1;   %(m,n)
n = 1;
f = 1;

for i = 1:64    %zig排列
    if n == 1 
         if m == 1
              zig2{i} = seg2{1};
              m = m+1;n=n;
              continue
         elseif m ~= 1
             if f == 1
                 zig2{i} = seg2{(m-1)*8+n};
                 m = m - 1;n = n + 1;
                 continue
             elseif f == -1
                 zig2{i} = seg2{(m-1)*8+n};
                 m = m + 1;n = n;f = 1;
                 continue
             end
         end
    elseif n == 8
        if m ~= 8 
            if f == -1
                zig2{i} = seg2{(m-1)*8+n}; 
                m = m + 1;n = n - 1;
                continue
            elseif f == 1
                zig2{i} = seg2{(m-1)*8+n};
                m = m + 1;n = n;f = -1;
                continue
            end
        end
    end

    if m == 1
        if n ~= 1
            if f == 1
                zig2{i} = seg2{(m-1)*8+n}; 
                m = m; n = n + 1; f = -1;
                continue
            elseif f == -1 
                zig2{i} = seg2{(m-1)*8+n}; 
                m = m + 1; n = n - 1;
                continue
            end
        end
    elseif m == 8
        if n ~= 8
            if f == -1
               zig2{i} = seg2{(m-1)*8+n}; 
               m = m; n = n + 1; f = 1;
               continue
            elseif f == 1
               zig2{i} = seg2{(m-1)*8+n}; 
               m = m - 1;n = n + 1;
               continue
            end
        end
    end

    if m ~= 1 && n ~= 1
        if f == 1
            zig2{i} = seg2{(m-1)*8+n}; 
            m = m - 1;n = n + 1;
            continue
        elseif f == -1
            zig2{i} = seg2{(m-1)*8+n};
            m = m + 1; n = n - 1;
            continue
        end
    end

    if n == 8 && m ==  8
        zig2{i} = seg2{64};
    end
end

for i = 1:64       %dct变换
    dct_2{i}=dct2(zig2{i});
end


for i = 1:64         %提取
    for j = 0:9
        ext((i-1)*100+10*j+1) = uint8((dct_2{i}(29-3*j,1+4*j)-Dct{i}(29-3*j,1+4*j))/a);
        ext((i-1)*100+10*j+2) = uint8((dct_2{i}(30-3*j,1+4*j)-Dct{i}(30-3*j,1+4*j))/a);
        ext((i-1)*100+10*j+3) = uint8((dct_2{i}(28-3*j,2+4*j)-Dct{i}(28-3*j,2+4*j))/a);
        ext((i-1)*100+10*j+4) = uint8((dct_2{i}(29-3*j,2+4*j)-Dct{i}(29-3*j,2+4*j))/a);
        ext((i-1)*100+10*j+5) = uint8((dct_2{i}(30-3*j,2+4*j)-Dct{i}(30-3*j,2+4*j))/a);
        ext((i-1)*100+10*j+6) = uint8((dct_2{i}(28-3*j,3+4*j)-Dct{i}(28-3*j,3+4*j))/a);
        ext((i-1)*100+10*j+7) = uint8((dct_2{i}(29-3*j,3+4*j)-Dct{i}(29-3*j,3+4*j))/a);
        ext((i-1)*100+10*j+8) = uint8((dct_2{i}(30-3*j,3+4*j)-Dct{i}(30-3*j,3+4*j))/a);
        ext((i-1)*100+10*j+9) = uint8((dct_2{i}(28-3*j,4+4*j)-Dct{i}(28-3*j,4+4*j))/a);
        ext((i-1)*100+10*j+10) = uint8((dct_2{i}(29-3*j,4+4*j)-Dct{i}(29-3*j,4+4*j))/a);        
    end
end

extract = reshape(ext,80,80);

figure(),image(extract),title('提取图像');

