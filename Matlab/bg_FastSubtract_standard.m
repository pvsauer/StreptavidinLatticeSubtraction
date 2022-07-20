function [subtracted] = bg_FastSubtract(file_in) 
%bg_FastSubtract(2d_file,edge) : (name,30) :
% => produce background subtracted 2D matrix (background was from smoothing fucntion
% edge size should be multiple of 10
%ouput is 2D matrix
%Oct 27 2017 

read_in = file_in;

how_big = size(file_in);

x_size = how_big(1) ; 
y_size = how_big(2) ; 


if(how_big < 500)
   smoothed = medfilt2(file_in,[10 10]); 
   edge  = 10;
   else 
     shrink = 500/how_big(1); 
     blow   = how_big(1)/500;
%     blow = 5 ; 
     small = imresize(file_in,shrink); 
     small  = medfilt2(small, [10 10]);   
     smoothed = imresize(small, [x_size  y_size]);
     edge   = 10*blow;  

%%image_smooth = 'smooth_out.mrc';
%%WriteMRC(smoothed,1,image_smooth);

end 

subtracted = file_in - smoothed ; 

block_mean = ones(how_big);

mean_value = mean(mean(subtracted));
block_mean = block_mean * mean_value;

% edge hiding : edge shows erroneous drop

edge = floor(edge); 

subtracted(1:edge,:)    = block_mean(1:edge,:);
subtracted(x_size - edge: x_size,:) = block_mean(x_size - edge: x_size,:);

subtracted(:,1:edge)                = block_mean(:,1:edge);
subtracted(:,y_size - edge: y_size) = block_mean(:,y_size - edge: y_size);

%%image_sub = 'subtract_out.mrc';
%%WriteMRC(subtracted,1,image_sub);

