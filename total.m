k = 16; % number of centroids required
% for i = 1:n % train a VQ codebook for each speaker
file = sprintf('s1');
disp(file);
[s, fs] = wavread(file);
% v = mfcc(s, fs); % Compute MFCC's
% code{i} = vqlbg(v, k); % Train VQ codebook



m = 100;
n = 256;
l = length(s);
nbFrame = floor((l - n) / m) + 1;
for i = 1:n
for j = 1:nbFrame
    M(i, j) = s(((j - 1) * m) + i);
end
end
%size(M)
h = hamming(n);
M2 = diag(h) * M;
for i = 1:nbFrame
frame(:,i) = fft(M2(:, i));
end
t = n / 2;
tmax = l / fs;

p=20;


f0 = 700 / fs;
fn2 = floor(n/2);
lr = log(1 + 0.5/f0) / (p+1);
% convert to fft bin numbers with 0 for DC term
bl = n * (f0 * (exp([0 1 p p+1] * lr) - 1));
b1 = floor(bl(1)) + 1;
b2 = ceil(bl(2));
b3 = floor(bl(3));
b4 = min(fn2, ceil(bl(4))) - 1;
pf = log(1 + (b1:b4)/n/f0) / lr;
fp = floor(pf);
pm = pf - fp;
r = [fp(b2:b4) 1+fp(1:b3)];
c = [b2:b4 1:b3] + 1;
v = 2 * [1-pm(b2:b4) pm(1:b3)];
m = sparse(r, c, v, p, 1+fn2);


m = melfb(20, n, fs);
n2 = 1 + floor(n / 2);
z = m * abs(frame(1:n2, :)).^2;
r = dct(log(z));
v=r;

d=v;
e = .0003;
r = mean(d, 2);
dpr = 10000;
for i = 1:log2(k)
r = [r*(1+e), r*(1-e)];
while (1 == 1)
z = disteu(d, r);
[m,ind] = min(z, [], 2);
t = 0;
for j = 1:2^i
r(:, j) = mean(d(:, find(ind == j)), 2);
x = disteu(d(:, find(ind == j)), r(:, j));
for q = 1:length(x)
t = t + x(q);
end
end
if (((dpr - t)/t) < e)
break;
else
dpr = t;
end
end
end