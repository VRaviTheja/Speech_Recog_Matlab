clc;
fs=22050;
input('press any key')
x = wavrecord(2 * fs, fs, 'double'); % Record and store the uttered speech
plot(x);
wavplay(x);

fid = fopen('sample.dat', 'w');
fwrite(fid, x, 'double'); % Store this feature vector as a .dat file
fclose(fid);