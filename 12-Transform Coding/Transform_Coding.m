clear;
[x_n, fs] = audioread("Crowd.wav");
%%sound(x_n,fs);

frame_start=length(x_n)/3;
x_n = x_n( frame_start : frame_start +10000-1 );
% b = [1 0.85] ;
 n_tab = 10;
% % x = filter(b, 1, x_n);
R = corr_mtx(x_n , n_tab);
[eig_vec, Diag] = eig(R);


% Extract the eigenvalues from the diagonal of D
eig_val = diag(Diag);

% Sort the eigenvalues in descending order
[eig_val, idx] = sort(eig_val, 'descend');

% Extract the eigenvectors corresponding to the sorted eigenvalues
eig_vec = eig_vec(:,idx);

% Normalize the eigenvectors to be orthonormal
A = orth(eig_vec);

%% KLT
KLT=zeros(1,10000);
for i=0:(length(x_n)-1)/10
    KLT(10*i+1 : (i+1)*10 )= (A)* x_n(10*i+1 : (i+1)*10 ).';
end

% inverse KLT
KLT_inv=zeros(1,10000);
for i=0:(length(x_n)-1)/10
    KLT_inv(10*i+1 : (i+1)*10 )= inv(A) *KLT(10*i+1 : (i+1)*10 ).';
end
mse_KLT = sqrt(mean(x_n - KLT_inv).^2);



%% DCT
N = 10;
% Create  DCT matrix of order N
C =dctmtx(N);

DCT=zeros(1,10000);
for i=0:(length(x_n)-1)/10
    DCT(10*i+1 : (i+1)*10 )= (C)* x_n(10*i+1 : (i+1)*10 ).';
end

% DCT inv
DCT_inv =zeros(1,10000);
for i=0:(length(x_n)-1)/10
    DCT_inv(10*i+1 : (i+1)*10 )= inv(C)* DCT(10*i+1 : (i+1)*10 ).';
end
mse_DCT = sqrt(mean(x_n - DCT_inv).^2);

%% Plotting


% original and KLT & DCT signal
figure ;
subplot(3,1,1);
stem(x_n(1:50));
title("original signal");
subplot(3,1,2);
stem(KLT(1:50));
title("KLT signal");
subplot(3,1,3);
stem(DCT(1:50));
title("DCT Signal");

% original and inverse signals
% 
% figure;
% stem(x_n(1000:1050), 'x-');hold on ;
% stem(DCT_inv(1000:1050),'o-');hold off
% title("original signal Vs DCT inv signal ");
% legend('original signal','DCT inv signal');
%     
% 
% stem(x_n(1000:1050), 'x-');hold on ;
% stem(KLT_inv(1000:1050),'o-');hold off
% title("original signal Vs KLT inv signal ");
% legend('original signal','KLT inv signal');

