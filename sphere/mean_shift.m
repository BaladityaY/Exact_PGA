function [data_mode, label] = mean_shift(X,n,p)
[~,N] = size(X);

data_mode=zeros(size(X,1),2);
h=1.0;
for i=1:2
    y=ones(size(X(:,i)));
    y_new =X(:,i);
    distance_stiefel(y_new,y,n,p)
    
    while distance_stiefel(y_new,y,n,p)>0.0001
    
        y = y_new;
        w(1:N)=0;

        s=0;
        for j=1:N
            w(j) = exp(-distance_stiefel(y, X(:,j),n,p)^2/h^2)*2*distance_stiefel(y, X(:,j),n,p)/h^2;
            s=s+w(j);
        end;
        w=w./s;
        y_new = karcher_mean_Stiefel_recursive_weight(X,w,n,p);
        distance_stiefel(y_new,y,n,p)

    end;
    
    data_mode(:,i) = y_new;
    
end;
label = zeros(N,1);
for i=1:N
    label(i,1)=1;
    mini=distance_stiefel(X(:,i),data_mode(:,1),n,p);
    for j=2:2
        dd=distance_stiefel(X(:,i),data_mode(:,j),n,p);
        if dd<mini
            mini=dd;
            label(i,1)=j;
        end;
    end;
end;
    



end