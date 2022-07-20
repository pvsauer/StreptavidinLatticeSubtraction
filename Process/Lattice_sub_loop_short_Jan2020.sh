#!/bin/bash

input_mrc_dir=/kriosdata/processing/psauer/20Oct23/MotionCorr/job037/Frames_20Oct23
output_mrc_dir=/kriosdata/processing/psauer/20Oct23/Frames_sub

wait_time=2

mkdir -p $output_mrc_dir
while [ $mrc_number -lt $(find $input_mrc_dir/ -name "*.mrc" ! -name "*_PS.mrc" ! -name "*_noDW.mrc" | wc -l) ] ; do
	find $input_mrc_dir/ -name "*.mrc" ! -name "*_PS.mrc" ! -name "*_noDW.mrc" > $output_mrc_dir/mrc_list 
	for f in `cat $output_mrc_dir/mrc_list`; do
		ROOT=$(basename -s .mrc $f)
		#echo "processing $(basename $f)"
		if ! [ -f $output_mrc_dir/${ROOT}_sub.mrc ] ; then
			cp -f $f input.mrc
          		/opt/qb3/matlab/bin/matlab  -nodisplay <  M_by_rot_K3_4.m 
			cp -f output.mrc $output_mrc_dir/${ROOT}_sub.mrc"
		else
			echo "${ROOT}_sub.mrc already exists"
	done
	sleep ${wait_time}m
done
