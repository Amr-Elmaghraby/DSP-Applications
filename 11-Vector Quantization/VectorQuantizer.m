tic
%% Clear
clear ;  clc;
%% Read Gray scale image
dat = imread('gray2.jpg');
% Convert the image to grayscale
if size(dat, 3) == 3
    dat = rgb2gray(dat);
end

% Define block size
block_size = 4;
size1 = size(dat,1);
size2 = size(dat,2);
zero_tap1 =0;
zero_tap2 =0;
if(mod(size1,block_size)~= 0)
    zero_tap1 = block_size  - mod(size1,block_size);
end
if( mod(size2,block_size)~= 0)
    zero_tap2 = block_size  - mod(size2,block_size);
end
data = zeros(size1+zero_tap1,size2+zero_tap2);
data(1:size1,1:size2) = dat;
data = uint8(data);
% Create a figure
figure;
subplot(2, 2, 1);

% Display the original image in the first subplot
imshow(data);
title('Original');

% Divide the image into blocks
num_rows = floor(size(data, 1) / block_size);
num_cols = floor(size(data, 2) / block_size);
% Split img to blocks of size 4*4
blocks = zeros(block_size, block_size, (num_rows * num_cols));
n=1;
for i = 1:num_rows
    for j = 1:num_cols
        block = data((i-1)*block_size+1:i*block_size, (j-1)*block_size+1:j*block_size);
        blocks(:,:,n) = block;
        n=n+1;
    end
end
% Calculate the mean of each block
means = squeeze(mean(mean(blocks, 1), 2));

% Sort blocks from min to max
[~, idx] = sort(means);
blocks = blocks(:, :, idx);

%% Initializing Codebooks
ki = [4 64 1024];  %codebook size
for len=1:length(ki)
    %% COMPRESSION
    k=ki(len);
    range = 256 / k ; %range to determine voronoi region
    CB = zeros(block_size,block_size,k); %initialize CB with zeros
    vor = 0:range:256;  %voronoi region
    
    % Average of each block of img
    itr=5; %number of iterations
    ni= zeros(1,k); % vector to save number of blocks per each region
    t1=0;
    for u=1:itr
        st=1;
        for i= 1:k
            sum= 0; % to sum all blocks per region
            num= 0; % calculate number of blocks per region
            for j=st:length(blocks);
                meen = mean2(blocks(:,:,j));
                t1=t1+1;
                if(meen>=vor(i)&&meen<vor(i+1))
                    sum = sum + blocks(:,:,j);
                    num = num +1;
                else
                    break
                end
            end
            ni(i) = num;
            st = st + num;
            if(num==0)
                if(i==1)
                    CB(:,:,i)=zeros(4,4);
                else
                    CB(:,:,i)=CB(:,:,i-1);
                end
            else
                CB(:,:,i) = floor(sum / num);
            end
        end
        for i=2:length(vor)-1
            vor(i) = (mean2(CB(:,:,i-1)) + mean2(CB(:,:,i))) / 2;
        end
        %vor(1) = mean2(CB(:,:,1));
        %vor(k+1) = mean2(CB(:,:,k));
    end
    
    %%
% %     z =zeros(1,k);
% %     for i =1:k
% %         z(i) = mean2(CB(:,:,i));
% %     end
% %     figure;
% %     stem(z);
    
    %% EXTRACTION
    %NOTE: values to be saved are:  
    %block_size, num_rows, num_cols  ==> size of block , image
    %CB ==> codebooks that have been calculated
    %idx ==> index of each block before sorting 
    %ni ==> number of blocks per each region
    daten=zeros(num_rows * block_size,num_cols * block_size);
    k=length(CB);
    mu=1;
    y=ni(1);
    for i=1:k
        for j=mu:y
            x=idx(mu);
            r = ceil(x/num_cols);
            c=x-num_cols*(r-1);
            daten((r-1)*block_size+1:r*block_size, (c-1)*block_size+1:c*block_size)=CB(:,:,i);
            mu=mu+1;
        end
        if(i ~= k)
            y=y+ni(i+1);
        end
    end
    daten = uint8(daten);
    subplot(2,2,len+1);
    imshow(daten);
    title(['Quantized Image (K=' num2str(k) ')']);
end

toc;



