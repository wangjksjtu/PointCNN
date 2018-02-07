#!/usr/bin/env bash

gpu=
setting=
modelsFolder="../../models/cls/"

usage() { echo "train/val pointcnn_cls with -g gpu_id -x setting options"; }

gpu_flag=0
setting_flag=0
while getopts g:x:h opt; do
  case $opt in
  g)
    gpu_flag=1;
    gpu=$(($OPTARG))
    ;;
  x)
    setting_flag=1;
    setting=${OPTARG}
    ;;
  h)
    usage; exit;;
  esac
done

shift $((OPTIND-1))

if [ $gpu_flag -eq 0 ]
then
  echo "-g option is not presented!"
  usage; exit;
fi

if [ $setting_flag -eq 0 ]
then
  echo "-x option is not presented!"
  usage; exit;
fi

if [ ! -d "$modelsFolder" ]
then
  mkdir -p "$modelsFolder"
fi


echo "Train/Val with setting $setting on GPU $gpu!"
CUDA_VISIBLE_DEVICES=$gpu python3 ../train_val_cls.py -t ../../data/modelnet/train_files.txt -v ../../data/modelnet/test_files.txt -s ../../models/cls -m pointcnn_cls -l ../../models/cls/pointcnn_cls_modelnet_x2_l4_6364_2018-02-05-22-45-26/ckpts/iter-17500 -x $setting > ../../models/cls/pointcnn_cls_$setting.txt 2>&1 &
