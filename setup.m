addpath(genpath('airfoils'));
addpath(genpath('app'));
addpath(genpath('sim'));

appName = './app/ASTRAL.mlapp';
appDesignerPath = fullfile(pwd, appName); 
open(appDesignerPath); 


clear
close all
clc
