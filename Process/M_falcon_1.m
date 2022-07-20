%% 1. read mrc file and crop image

clear all;close all;clc;

restoredefaultpath;matlabrc
addpath  /home/local_user/Desktop/bg_minimum/MATLAB_PROCESS/K3_LATTICE_SUPPRESS/00_K3_script ;   change as needed 

%%%%%%%%%%%%%%%%%%  PARAMETER INITIALIZE  
%% Pad_Box_Size =         4400;
 Pad_Origin_X  =        200 ;
 Pad_Origin_Y   =       200 ;  %% Changed  Falcon
 Inside_Radius_Ang  =   90 ;
 Outside_Radius_Ang =   3  ;    %% Changed Falcon, Will be (2 * Pixel_Ang + 0.2 Ang)
 Pixel_Ang  =           1.32 ;
 Threshold  =           1.57 ;
 expand_pixel = 10; 

 pad_out_opt =   0; 
%%%%%%%%%%%%%%  PARAMETER READING
filein = fopen('PARAMETER','r') ;

  Array = textscan(filein, '%s  %s');
  name_list = Array{1,1}   ; 
  num_list  = Array{1,2}   ; 
  list_count = size(name_list) ;  list_count = list_count(1);

  for ii = 1:list_count

   if ( contains(name_list{ii}, string('inside_radius_Ang')) )
       Inside_Radius_Ang  =  str2num(num_list{ii})  ;

   elseif ( contains(name_list{ii}, string('outside_radius_Ang')) )
       Outside_Radius_Ang  =  str2num(num_list{ii})  ;

   elseif ( contains(name_list{ii}, string('pixel_Ang')) )
       Pixel_Ang  =  str2num(num_list{ii})  ;

   elseif ( contains(name_list{ii}, string('threshold')) )
       Threshold   =  str2num(num_list{ii})  ; 

   end
  end
  fclose(filein);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

%IMAGE FILE READIN 
   name_list =  'input.mrc'; 
   img = ReadMRC(name_list);

%%% auto_padding : bgh Oct-18 2017

  img_left = img(:,1);
  img_top  = img(1,:);
  dummy = size(img);
  row_count = dummy(1) 
  column_count = dummy(2) 
  Pad_Box_Size = max(row_count, column_count) + Pad_Origin_X*2  ; 
  Pad_Box_Size = round(Pad_Box_Size / 10) * 10 ; %%  bg_FastSubtract imresize limits box_size choice  
  img_right = img(:,column_count);
  img_bottom = img(row_count,:);
 mean_edge  =  ( mean(img_left) + mean(img_right) + mean(img_top) + mean(img_bottom) ) /4   %%% just information
  mean_all = mean(mean(img)) 
  left_st_minus_1 = Pad_Box_Size ; 

  corner_pad_stROW = Pad_Origin_X - 1; 
  corner_pad_stCOL = Pad_Origin_Y - 1; 

  coner_pad_endROW = Pad_Box_Size - row_count - corner_pad_stROW  ;        
  coner_pad_endCOL = Pad_Box_Size - column_count - corner_pad_stCOL ; 


%% exit ;  %%%% K3 

   

  pad_1 =     padarray(img,   [ corner_pad_stROW   corner_pad_stCOL ],mean_all, 'pre');
  pad_image = padarray(pad_1, [ coner_pad_endROW   coner_pad_endCOL ], mean_all, 'post');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 unit_cell_pixel_Fourier = Pixel_Ang/57 * Pad_Box_Size;

    img2 = double(pad_image);
%   imshow(img2,[]);
     
   Outside_Radius_Ang = Pixel_Ang * 2 + 0.2;  %%  Changed K3 
 
   lattice_sub = bg_push_by_rot(img2,Threshold,expand_pixel,Pixel_Ang,Inside_Radius_Ang,Outside_Radius_Ang);
%   figure; imshow(lattice_sub,[]);
   name_sub = 'output.mrc';  
   out_sub = lattice_sub ; 
   if ( pad_out_opt == 0 ) 
      x_cut = Pad_Origin_X + row_count - 1;
      y_cut = Pad_Origin_Y + column_count - 1;  
      out_sub = lattice_sub(Pad_Origin_X:x_cut, Pad_Origin_Y:y_cut); 
   end  
   WriteMRC(out_sub,1,name_sub);

%%%%%%%%%%%%%%%%%%
   
