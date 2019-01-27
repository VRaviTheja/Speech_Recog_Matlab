clc;
fs=22050;

a=input('press any key');
x = wavrecord(2 * fs, fs, 'double'); % Record and store the uttered speech
plot(x);
wavplay(x);
wavwrite(x,fs,'rec3');
