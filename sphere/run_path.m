base=[0,0,1]';
n = 5;
div=101;
% for i=1:n
%     %theta = rand*0.9*pi/2;
%     theta=1.1;
%     phi = rand*0.9*pi/2;
%     onsphere(1:3,i)=[sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta)];
%     onsphere(1:3,i+n)=[sin(theta)*cos(pi/6+phi), sin(theta)*sin(pi/6+phi), cos(theta)];
% end;

for i=1:n
    %theta = rand*0.9*pi/2;
    theta=1.1;
    phi = rand*0.9*pi/2;
    onsphere(1:3,i)=[sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta)];
    basesphere(1:3,i)=[sin(theta)*cos(-phi), sin(theta)*sin(-phi), cos(theta)];
%     onsphere(1:3,i+n)=[sin(theta)*cos(pi+phi), sin(theta)*sin(pi+phi), cos(theta)];
%     basesphere(1:3,i+n)=[sin(theta)*cos(pi-phi), sin(theta)*sin(pi-phi), cos(theta)];
    onsphere(1:3,i+n)=[sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta)];
    basesphere(1:3,i+n)=[sin(theta)*cos(-phi), sin(theta)*sin(-phi), cos(theta)];
end;

for i=1:2*n
    base = basesphere(:,i);
    v=logmap_sphere(base,onsphere(:,i));
    X=[];
    c=1;
    for t=0:1/(div-1):1
        p=expmap_sphere(base,t*v);
        X(c,:)=p';
        c=c+1;
    end
    data(1:div*3,i) = reshape(X,div*3,1);
    [q,r] = qr(X,0);
    onstiefel(1:div*3,i) = reshape(q,div*3,1);
    oneuclid(1:9,i) = reshape(r,3*3,1);
end;

mu = karcher_mean_Stiefel(onstiefel,div,3);
mu_s=reshape(mu,div,3);
mu_e = mean(oneuclid,2);
mu_e = reshape(mu_e,3,3);
new_mu = mu_s*mu_e;
[x,y,z]=sphere;
figure;surf(x,y,z,'FaceColor',[228/255,202/255,188/255],'LineStyle','none');
alpha(0.2);
hold on;
for i=1:2*n
    X=reshape(data(:,i),div,3);
    for j=1:div
      plot3(X(j,1),X(j,2),X(j,3),'b.','markersize',16);
    end;
end;
for j=3:div
    new_mu(j,:)=new_mu(j,:)./norm(new_mu(j,:));
    plot3(new_mu(j,1),new_mu(j,2),new_mu(j,3),'r.','markersize',16);
end;
