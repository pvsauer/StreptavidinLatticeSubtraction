function LAsub(filename)

%% 1. read mrc file and crop image

clear all;close all;clc;
restoredefaultpath;matlabrc
addpath  /arctica/processing/psauer/19Jan28/99_matlab/ ; 

%%%%%%%%%%%%%%%%%%  PARAMETER INITIALIZE  
%% Pad_Box_Size =         4200;
 Pad_Origin_X  =        200 ;
 Pad_Origin_Y   =       200 ;
 Inside_Radius_Ang  =   90 ;
 Outside_Radius_Ang =   3.1  ;
 Pixel_Ang  =           1.14 ;
 Threshold  =           1.42 ;
 expand_pixel = 10; 
 pad_out_opt =   0; 
%%%%%%%%%%%%%%  PARAMETER READING
%{
filein = fopen('PARAMETER','r') ;

  Array = textscan(filein, '%s  %s');
  name_list = Array{1,1}   ; 
  num_list  = Array{1,2}   ; 
  list_count = size(name_list) ;  list_count = list_count(1);

  for ii = 1:list_count

   if ( strfind(name_list{ii}, string('inside_radius_Ang')) )
       Inside_Radius_Ang  =  str2num(num_list{ii})  ;

   elseif ( strfind(name_list{ii}, string('outside_radius_Ang')) )
       Outside_Radius_Ang  =  str2num(num_list{ii})  ;

   elseif ( strfind(name_list{ii}, string('pixel_Ang')) )
       Pixel_Ang  =  str2num(num_list{ii})  ;

   elseif ( strfind(name_list{ii}, string('threshold')) )
       Threshold   =  str2num(num_list{ii})  ; 

   end
  end
  fclose(filein);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

%IMAGE FILE READIN 
   %%name_list =  'input.mrc'; 
   img = ReadMRC(filename);

%%% auto_padding : bgh Oct-18 2017

  img_left = img(:,1);
  img_top  = img(1,:);
  dummy = size(img);
  row_count = dummy(1); 
  column_count = dummy(2); 
  Pad_Box_Size = max(row_count, column_count) + Pad_Origin_X*2  ; 
  Pad_Box_Size = round(Pad_Box_Size / 10) * 10 ; %%  bg_FastSubtract imresize limits box_size choice  
  %Pad_Box_Size = 8192; 
  img_right = img(:,column_count);
  img_bottom = img(row_count,:);
  mean_all =  ( mean(img_left) + mean(img_right) + mean(img_top) + mean(img_bottom) ) /4; 
  
  left_st_minus_1 = Pad_Box_Size ; 

  corner_pad_stROW = Pad_Origin_X - 1; 
  corner_pad_stCOL = Pad_Origin_Y - 1; 

  coner_pad_endROW = Pad_Box_Size - row_count - corner_pad_stROW  ;        
  coner_pad_endCOL = Pad_Box_Size - column_count - corner_pad_stCOL ; 

  pad_1 =     padarray(img,   [ corner_pad_stROW   corner_pad_stCOL ], mean_all , 'pre');
  pad_image = padarray(pad_1, [ coner_pad_endROW   coner_pad_endCOL ], mean_all , 'post');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 unit_cell_pixel_Fourier = Pixel_Ang/57 * Pad_Box_Size;

    img2 = double(pad_image);
%   imshow(img2,[]);

   lattice_sub = bg_push_by_rot(img2,Threshold,expand_pixel,Pixel_Ang,Inside_Radius_Ang,Outside_Radius_Ang);
%   figure; imshow(lattice_sub,[]);
   name_sub = 'output.mrc';  
   out_sub = lattice_sub ; 
   if ( pad_out_opt == 0 ) 
      x_cut = Pad_Origin_X + column_count - 1;
      y_cut = Pad_Origin_Y + row_count - 1;  
      out_sub = lattice_sub(Pad_Origin_Y:y_cut, Pad_Origin_X:x_cut);
     % size(out_sub) 
   end
   WriteMRC(out_sub,1,name_sub);

%%%%%%%%%%%%%%%%%%
   

end
