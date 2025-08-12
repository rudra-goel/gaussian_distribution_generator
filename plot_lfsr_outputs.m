clc; clear; close all;

vals = readlines("lfsr_outputs.txt");
vals_base10 = bin2dec(vals);

nomalized = vals_base10 / max(vals_base10);

figure;
plot(nomalized); ylabel("Normalized Value"); xlabel("Sample");
title(strcat("Uniform Distribution over ", num2str(length(vals_base10)), " Samples"));