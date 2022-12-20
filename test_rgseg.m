%averaging filter
I1 = imread('test_img.jpg');

%Segmentation - Region Growing
t = zeros(2, 1); %gives us the starting point

figure, imshow(I1);
[st(1), st(2)] = ginput(1);
st(1)= floor(st(1));
st(2)= floor (st(2));

imout = rgseg(I1, st(2), st(1), -1, 2);
figure, imshow(imout)
