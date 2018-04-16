n=100;
p=20;
N=5000;


c=1;
X = eye(n);
for i=1:N
    [q,~]=qr(X+rand*0.02-0.01);
    data(1:n*p,c)=reshape(q(:,1:p),n*p,1);
    c=c+1;
end

c=1;
X1 = rand(n,n);
for i=1:N
    [q,~]=qr(X1+rand*0.02-0.01);
    data3(1:n*p,c)=reshape(q(:,1:p),n*p,1);
    c=c+1;
end

c=1;
X2 = 2000*rand(n,n)+2000;
for i=1:N
    [q,~]=qr(X2+rand*0.02-0.01);
    data1(1:n*p,c)=reshape(q(:,1:p),n*p,1);
    c=c+1;
end

c=1;
X3 = zeros(n);
for i=1:N
    [q,~]=qr(X3+rand*0.02-0.01);
    data2(1:n*p,c)=reshape(q(:,1:p),n*p,1);
    c=c+1;
end

new_data=cat(2,data,data1);

new_data = cat(2,new_data',cat(2,ones(N,1)',2*ones(N,1)')',randperm(2*N)');

new_data=sortrows(new_data,n*p+2);

new_data(:,n*p+2)=[];

tic;

[~,label]=kmeans_manifold(new_data(:,1:n*p)',2,n,p,1);
toc;

[accuracy, true_labels, CM] = calculateAccuracy(new_data(:,n*p+1), label)

tic;

[~,label1]=kmeans_manifold(new_data(:,1:n*p)',2,n,p,2);
toc;

[accuracy, true_labels, CM] = calculateAccuracy(new_data(:,n*p+1), label1)




