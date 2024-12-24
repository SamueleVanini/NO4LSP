clear; clc; close all;

A = [ 1,  2,  3,  4,  5;
      6,  7,  8,  9, 10;
     11, 12, 13, 14, 15;
     16, 17, 18, 19, 20;
     21, 22, 23, 24, 25];

A = round(0.5 * (A + A'));

P = block_to_upper_left(A, 3, 5);

disp(A);
disp(P * A * P');