list=textread('urllist.txt','%s');
list2=textread('urllist2.txt','%s');
OUTDIR='imgdir';
OUTDIR2='imgdir2';
% imgdirが存在しないならフォルダを作成して画像を呼び込む
if ~exist('imgdir/','dir')
    mkdir(OUTDIR);
    for i=1:size(list,1)
        fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg')
        websave(fname,list{i});
    end
end

if ~exist('imgdir2/','dir')
    mkdir(OUTDIR2);
    for i=1:size(list2,1)
        fname2=strcat(OUTDIR2,'/',num2str(i,'%04d'),'.jpg')
        websave(fname2,list2{i});
    end
end


% ポジティブ、ネガティブの画像の設定
PosList=list(1:100);   
NegList=list(101:200);
Training=[PosList(:) NegList(:)];

PosList2=list2(1:100);   
NegList2=list2(101:200);
Training2=[PosList2(:) NegList2(:)];


% カラーヒストグラムと最近傍分類
ratio1 = Classification1(list);
ratio1_2 = Classification1(list2);

% BoFベクトルと非線形SVMによる分類
ratio2 = Classification2(Training);
ratio2_2 = Classification2(Training2);

% AlexNetやVGG16などによるDCNN特徴量と線形SVM
ratio3 = Classification3(Training);
ratio3_2 = Classification3(Training2);


fprintf("[ramen:takoyaki] [1] %d [2] %d [3] %d\n", ratio1, ratio2, ratio3);
fprintf("[ramen:soba] [1] %d [2] %d [3] %d\n", ratio1_2, ratio2_2, ratio3_2);