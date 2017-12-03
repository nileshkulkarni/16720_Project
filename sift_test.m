I = vl_impattern('roofs1') ;
image(I) ;
I = single(rgb2gray(I)) ;
% [f,d] = vl_sift(I) ;
% perm = randperm(size(f,2)) ;
% sel = perm(1:50) ;
% h1 = vl_plotframe(f(:,sel)) ;
% h2 = vl_plotframe(f(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
% h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h3,'color','g') ;
% 
scales = [20];
fcx = 100*ones(size(scales));
fcy = 100*ones(size(scales));
fcangle  = 0*ones(size(scales));
fc = [fcx;fcy;scales;fcangle];
[f,d] = vl_sift(I,'frames',fc) ;

h1 = vl_plotframe(f) ;
h2 = vl_plotframe(f) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
% h3 = vl_plotsiftdescriptor(d,f) ;
% set(h3,'color','g') ;
% 
