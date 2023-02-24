function ratio2 = Classification2(Training)

% コードブックがないなら関数を呼び出して作る。あるならばloadする
if ~(exist('codebook.mat','file') == 2)
    CODEBOOK = CODEBOOK_MAKER(Training);
else
    load('codebook.mat','CODEBOOK');
end


% BoFベクトルの作成
bof = zeros(200,500);
for j=1:200  % 各画像についての for-loop
    %j番目の画像読み込み
    %SURF特徴抽出
    I=rgb2gray(imread(Training{j}));
    p=createRandomPoints(I,1000);
    [f,p2]=extractFeatures(I,p);
    for i=1:size(p2,1)  % 各特徴点についての for-loop
        %一番近いcodebook中のベクトルを探してindexを求める．
        
        %距離格納用行列
        D = zeros(size(CODEBOOK,1),1);

        for k = 1:size(CODEBOOK,1)
            D(k,1) = sqrt(sum((CODEBOOK(k,:)-f(1,:)).^2));
        end
        [M,index] = min(D);
        %bofヒストグラム行列のj番目の画像のindexに投票　
        bof(j,index)=bof(j,index)+1;
    end
end

% sum(A,2)で行ごとの合計を求めて，それを各行の要素について割ることによっ
% て，各行の合計値を１として正規化
bof = bof ./ sum(bof,2); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%非線形SVM
n = 200;
cv=5;
idx=1:n;
accuracy=[];

% idx番目(idxはcvで割った時の余りがi-1)が評価データ
% それ以外は学習データ
for i=1:cv 
    %学習データ(160)
    train= bof(mod(idx,cv)~=(i-1),:);
    %評価データ(40)
    eval = bof(mod(idx,cv)==(i-1),:);

    train_label=[ones(80,1); ones(80,1)*(-1)];

    %学習
    model = fitcsvm(train, train_label,'KernelFunction','rbf', 'KernelScale','auto');

    %分類
    [eval_label2, scores] = predict(model, eval);

    %認識精度
    correct = 0;
    for k=1:40
        if(eval_label2(k,1) < 0 && k > 20)
            correct = correct+1;
        elseif(eval_label2(k,1) > 0 && k <= 20)
            correct = correct+1;
        end
    end
    ac = correct / 40.0 * 100;
    accuracy=[accuracy ac];
end

ratio2 = mean(accuracy);

