function [outimg, pxls] = rgseg(img, h, w, amount, mthd)
%RGSEG region growing image segmentation
% [outimg, pxls] = rgseg(img, h, w, amount, mthd) find a region in pixel
% with heigh h, and width w.
% image can only be in rgb or grayscale colormaps
% methods: method 1: compares pixels to neighboring pixel in the region
%          method 2: compares pixels to initial pixel
% amount is the intensity of similarity between pixels in the region
% if amount is negative, it is automatically set to average of pixels in
% the image.

% convert image to greyscale
[r, c, channels] = size(img);
if channels > 1
    img = rgb2gray(img);
end

% set default for amount
if amount < 0
    amount = mean(mean(img));
end

%set initial point
st = zeros(2, 1);
st(1) = h; 
st(2) = w; 

%initialize a list for the region
pixels = [];
pixels = [pixels, st];

%initialize some variables
im_size = size(img);
init_pixel = img(st(1), st(2));
i = 0;

while i < size(pixels, 2)
    i = i + 1;

    pixel = pixels(:,i);
    nghbr = [];

    %check if neighbor is out of bounds
    if pixel(1)-1 > 0
        n_up = [pixel(1)-1; pixel(2)];
        nghbr = [nghbr n_up];
    end
    if pixel(2)-1 > 0
        n_left = [pixel(1); pixel(2)-1];
        nghbr = [nghbr n_left];
    end
    if pixel(1)+1 < im_size(1)
        n_down = [pixel(1)+1; pixel(2)];
        nghbr = [nghbr n_down];
    end
    if pixel(2)+1 < im_size(2)
        n_right = [pixel(1); pixel(2)+1];
        nghbr = [nghbr n_right];
    end
    
    %check all of current pixel's neighbors to add them to region
    for j = 1:size(nghbr, 2)

        %check if neighbor is in region already
        if length(intersect(transpose(nghbr(:,j)), transpose(pixels), 'rows')) < 2
            if mthd == 1
                if abs(img(nghbr(1,j), nghbr(2,j)) - img(pixel(1), pixel(2))) < amount
                    pixels = [pixels, nghbr(:,j)];
                end
            elseif mthd == 2
                if abs(img(nghbr(1,j), nghbr(2,j)) - init_pixel) < amount
                   pixels =  [pixels, nghbr(:,j)];
                end
            end
        end    
    end

    %color the region
    img(pixel(1), pixel(2)) = 300;
end

%set outputs
outimg = img;
pxls = pixels;

end