function [picked] = bg_Pick_Amp_masked(fft_in,mask_in) 
%bg_Pick_Amp_masked(fft_file_in, mask_in) : 
% => Apply median filter to the amplitude data and pick the value only from masked area 
%ouput is 2D matrix
%Oct 25 2017
read_in = fft_in;
how_big = size(fft_in);

%%out_mask =  'mask_2nd.mrc';
%%WriteMRC(mask_in,1,out_mask); 

I_map  = fft_in.*conj(fft_in); 
%% test 

A_map = sqrt(I_map) ;

%%out_fft = 'fft_in.mrc';
%%WriteMRC(A_map,1,out_fft); 

mask_use = ~mask_in;

%%A_map = A_map .* mask_use ;  

if(how_big < 500)
   smoothed = medfilt2(A_map,[10 10]); 
   edge  = 10;
   else
     shrink = 500/how_big(1); 
     blow   = how_big(1)/500;
 
     small = imresize(A_map,shrink);
     small  = medfilt2(small, [10 10]);   
     smoothed = imresize(small, blow);
     edge   = floor(10*blow); 
end 

rot_add  = zeros(how_big); 

%%  zippy radial averaging  
for irot = 1:4 
  %% PLAY HERE   OCT 27 2017
%%  rotated = imrotate(A_map,1,'neares','crop'); 
  
  rotated = imrotate(smoothed,irot*10,'neares','crop');
  rot_add = rot_add + rotated;  
end 

rot_smooth = rot_add./4;

%%%%  noise ( from 0 to 1) 
MANY_ONE  = ones(how_big); 
noise_add  = imnoise(MANY_ONE,'Gaussian',0.000000001);
%%%%% noise shift (from 0.15 to 1.15) 
noise_add  = noise_add + MANY_ONE*0.15; 

rot_smooth_noise = rot_smooth .* noise_add; 

%figure;imshow(rot_smooth,[]);
%figure;imshow(noise_add,[]);
%figure;imshow(rot_smooth_noise,[]);
%picked = smoothed .* mask_use; 

picked = rot_smooth_noise .* mask_use;

block_mean = ones(how_big);

mean_value = mean(mean(picked));
block_mean = block_mean *mean_value;

x_size = how_big(1);
y_size = how_big(2);

% edge hiding : edge shows erroneous drop

picked(1:edge,:)                = block_mean(1:edge,:);
picked(x_size - edge: x_size,:) = block_mean(x_size - edge: x_size,:);

picked(:,1:edge)                = block_mean(:,1:edge);
picked(:,y_size - edge: y_size) = block_mean(:,y_size - edge: y_size);

