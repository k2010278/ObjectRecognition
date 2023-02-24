function ratio1 = Classification1(list)

% databaseがないなら関数を呼び出して作る。あるならばloadする
if ~(exist("db.mat","file") == 2)
    database = DATABASE_MAKER(list);
else
    load("db.mat","database");
end

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 200;
cv=5;
idx=1:n;
accuracy=[];

% idx番目(idxはcvで割った時の余りがi-1)が評価データ
% それ以外は学習データ
for i=1:cv 
    %学習データ(160)
    train= database(mod(idx,cv)~=(i-1),:);
    %評価データ(40)
    eval = database(mod(idx,cv)==(i-1),:);


    correct = 0;

    for k = 1:size(eval,1)
        query = eval(k,:);
        sim=[];  
        for j = 1:size(train,1)
            sim = [sim sum(min(train(j,:),query))];
        end
        [sorted,index]=sort(sim,'descend');

        %認識精度
        if (index(1) <= 80 && k <= 20)
            correct = correct+1;
        elseif (index(1) > 80 && k > 20)
            correct = correct+1;
        end
    end

    ac = correct / 40.0 * 100;
    accuracy=[accuracy ac];
end

ratio1 = mean(accuracy);