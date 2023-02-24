function CODEBOOK = CODEBOOK_MAKER(Training)

% forループで，全画像についてSURF特徴を抽出
Features=[];
for i=1:200
  I=rgb2gray(imread(Training{i}));
  p=createRandomPoints(I,1000);
  [f,p2]=extractFeatures(I,p);
  Features=[Features; f];
end

%あとは，kmeans でコードブックを作成してください．
%コードブックは，各クラスタの中心ベクトルの集合です．
%k=500の場合，500x64 の行列になります．[idx,CODEBOOK]=kmeansとした時の
%CODEBOOKがコードブックになります．

%ただし，Featuresの行数が5万を超える時は，
%k-meansに時間がかかるので，
%Features=Features(randperm(size(randperm,1),50000),:);
%などとして，ランダム選択で50000行に減らしたほうがいいでしょう．

[idx,CODEBOOK]=kmeans(Features, 500);
save('codebook.mat','CODEBOOK');