function final_output = Processing(picture)
    close all;
    load imgfildata.mat;
    
    
    cc = size(picture, 2);
    picture=imresize(picture,[300 500]);

    figure,imshow(picture),title('Original Img');

    if size(picture,3)==3
      picture=rgb2gray(picture);
    end
    
    figure,imshow(picture),title('Gray Scale Img');

    sharpFilter = fspecial('unsharp');
    picture = imfilter(picture, sharpFilter);
    figure,imshow(picture),title('Sharped Image');

    threshold = graythresh(picture);
    picture = ~imbinarize(picture, threshold);

    figure,imshow(picture),title('Binary Img');

    picture = bwareaopen(picture,30);

    figure,imshow(picture),title('Bwareopen(30)');

    if cc>2000
        picture1=bwareaopen(picture,3500);
        figure,imshow(picture1),title('bwareaopen(cc>2000, 3500)');
    else
        picture1=bwareaopen(picture,3000);
        figure,imshow(picture1),title('bwareaopen(cc<2000, 3000)');
    end
    
    picture2=picture-picture1;
    figure,imshow(picture2),title('picture - picture1');

    
    picture2 = medfilt2(picture2, [3 3]);
    figure,imshow(picture2),title('Median Filter');

    picture2=bwareaopen(picture2,70);
    figure,imshow(picture2),title('bwareaopen(70)');
    
    [L,Ne]=bwlabel(picture2);
    propied=regionprops(L,'BoundingBox');
    hold on
    pause(1)
    for n=1:size(propied,1)
      rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end
    hold off
    
    final_output=[];
    t=[];
    for n=1:Ne
      [r,c] = find(L==n);
      n1=picture(min(r):max(r),min(c):max(c));
      n1=imresize(n1,[42,24]);
      pause(0.2)
      x=[ ];
      
      totalLetters=size(imgfile,2);
      for k=1:totalLetters
          y=corr2(imgfile{1,k},n1);
          x=[x y];
      end
      t=[t max(x)];
      
      if max(x)>.45
          z=find(x==max(x));
          out=cell2mat(imgfile(2,z));
          final_output=[final_output out];
      end
    end
    
    file = fopen('number_Plate.txt', 'at');
        fprintf(file,'%s\n',final_output);
        fclose(file);                     
end