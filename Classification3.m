function ratio3 = Classification3(Training)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DCNN特徴を抽出
% net準備
net = alexnet;

%%%%%%%%%%%%%%%% 特徴抽出
for j=1:200
    % 入力画像を準備
    img = imread(Training{j});
    reimg = imresize(img,net.Layers(1).InputSize(1:2));
    if(rem(j,100) == 1 && j <= 100)
        IMPos = reimg;
    elseif(rem(j,100) ~= 1 && j <= 100)
        IMPos = cat(4,IMPos,reimg);
    elseif(rem(j,100) == 1 && j > 100)
        IMNeg = reimg;
    elseif(rem(j,100) ~= 1 && j > 100)
        IMNeg = cat(4,IMNeg,reimg);
    end
end


% activationsを利用して中間特徴量を取り出します．
% 4096次元の'fc7'から特徴抽出します．
data_pos = activations(net,IMPos,"fc7");
data_neg = activations(net,IMNeg,"fc7");

% squeeze関数で，ベクトル化します．
data_pos = squeeze(data_pos);
data_neg = squeeze(data_neg);

% L2ノルムで割って，L2正規化．
% 最終的な dcnnf を画像特徴量として利用
% data_pos 4096次元のPos画像特徴が100枚分
% data_neg 4096次元のNeg画像特徴が100枚分
data_pos = data_pos/norm(data_pos);
data_neg = data_neg/norm(data_neg);

n = 100;
cv=5;
idx=1:n;
accuracy=[];

% このままでは逆なので転置
data_pos2 = data_pos';
data_neg2 = data_neg';

% idx番目(idxはcvで割った時の余りがi-1)が評価データ
% それ以外は学習データ
for i=1:cv 
    %ポジティブの学習データ
    train_pos=data_pos2(mod(idx,cv)~=(i-1),:);
    %ポジティブの評価データ
    eval_pos =data_pos2(mod(idx,cv)==(i-1),:);
    %ネガティブの学習データ
    train_neg=data_neg2(mod(idx,cv)~=(i-1),:);
    %ネガティブの学習データ
    eval_neg =data_neg2(mod(idx,cv)==(i-1),:);

    train=[train_pos; train_neg];
    eval=[eval_pos; eval_neg];

    train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
    eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];

    %学習
    model = fitcsvm(train, train_label,'KernelFunction','linear');
    %分類
    [eval_label2, scores] = predict(model, eval);


    %認識精度
    correct = 0;
    for k=1:40
        if(eval_label2(k,1) < 0 && eval_label(k,1) == -1)
            correct = correct+1;
        elseif(eval_label2(k,1) > 0 && eval_label(k,1) == 1)
            correct = correct+1;
        end
    end
    ac = correct / 40.0 * 100;
    accuracy=[accuracy ac];
end

ratio3 = mean(accuracy);