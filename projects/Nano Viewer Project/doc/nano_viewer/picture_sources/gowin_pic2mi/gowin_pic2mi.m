%picture to gowin rom initial file (.mi)

%ԭʼͼƬ·��
SOURCE_IMAGE_PATH    = '.\source_image_2.bmp';
%�����mi�ļ�����·��
SAVED_MEM_FILE_PATH = 'img_rom_2.mi';
%ͼƬ���
SOURCE_IMG_WIDTH = 100;
%ͼƬ�߶�
SOURCE_IMG_HIGHT = 100;
%���λ��
OUT_RADIX  =  1;

src_img =  imread(SOURCE_IMAGE_PATH);
img_data = fopen(SAVED_MEM_FILE_PATH,'w');


fprintf(img_data,'%s\r\n','#File_format=Bin');
fprintf(img_data,'%s%s\r\n','#Address_depth=',num2str(SOURCE_IMG_WIDTH*SOURCE_IMG_HIGHT));
fprintf(img_data,'%s%s\r\n','#Data_width=',num2str(OUT_RADIX));

for i = 1:SOURCE_IMG_WIDTH
    for j = 1:SOURCE_IMG_HIGHT
        fprintf(img_data,'%s\r\n',num2str(src_img(i,j)));
    end
end
    