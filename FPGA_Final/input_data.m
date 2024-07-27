int_data = (randi([0, 1], 64, 1));
disp(dec2bin(int_data));
writematrix(dec2bin(int_data),'inp_bin.dat')