function database = DATABASE_MAKER(list)

%画像DB行列
database = [];
for i = 1:length(list)
    X = imread(list{i});

    RED = X(:,:,1);
    GREEN = X(:,:,2);
    BLUE = X(:,:,3);
         
    X64 = floor(double(RED)/64) *4*4 + floor(double(GREEN)/64) *4 + floor(double(BLUE)/64);
    X64_vec = reshape(X64,1,numel(X64));
    h = histcounts(X64_vec, 0:63);

    h = h / sum(h);      % 要素の合計が１になるように正規化します．
    database = [database; h];
end

save('db.mat', 'database');
