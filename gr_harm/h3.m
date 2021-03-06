function [] = h3( iterations,nx,ny,nz,dx,dy,dz,par1,par2,jobname )
%h3( iterations,nx,ny,nz,dx,dy,dz,par1,par2 )
%         nx,ny,nz  : grid sizes of the 3d cube.
%         dx,dy,dz  : grid spacings
%         iterations: the number of iterations to evolve
%         par1,par2 : Parameters for the initial data
%         par1 amplitude
%         par2 shape -2<shape<2
%     Main code: it does the evolution by calling the routines
%     to set the initial data at iteration 0 (H3expresso restriction)
%     and then calling the method (H3expresso only implements Macormack) 
%     and the boundaries at every time step. H3expresso does not
%     have I/O so no output routine is called. Instead, some minimal
%     information is given at every iteration.
%  [INCLUDES]  metric.h  declares all the grid and metric arrays.
%
%  [VARIABLES] The whole grid and metric structure is allocated here. 
%     See the documentation of the header file metric.h. 
%
%  [CALLED BY]  h3_drv.m
%  [CALLS  TO]  initial.m
%               information_info_header.m
%               method.m
%               boundaries.m


%Current iteration, time and time step
%      integer currentiter       
%      real time,dt 

      time= 0.;

%     We will use a fixed dt during the evolution. This dt
%     should be less than the maximum courant time step of dx/sqrt(3)
%     Note that we assume that the metric factor on the courant does
%     not play any role... this is true for the linearized waves.
      dt = 0.5*dx;
[x,y,z,r,psi,alp,cux,cuy,cuz,rg,uxx,uxy,uxz,uyy,uyz,uzz,gxx,gxy,gxz,gyy,gyz,gzz,qxx,qxy,qxz,qyy,qyz,qzz,dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz]=initial(nx,ny,nz,dx,dy,dz,par1,par2,time,dt);



outname=sprintf('%s_initial.mat',jobname);

save(outname);
for currentiter=1:iterations

%        The evolved level will be at the new time
         time = time+dt;
         
%        H3expresso: only 1 method (Macormack)
         [alp,cux,cuy,cuz,...
             uxx,uxy,uxz,uyy,uyz,uzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz]...
             =method(nx,ny,nz,dt,dx,dy,dz,x,y,z,r,...
             psi,alp,cux,cuy,cuz,rg,uxx,uxy,uxz,uyy,uyz,uzz,...
             gxx,gxy,gxz,gyy,gyz,gzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz);

%        Boundary conditions
         [alp,cux,cuy,cuz,rg,...
             uxx,uxy,uxz,uyy,uyz,uzz,...
             gxx,gxy,gxz,gyy,gyz,gzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz...
             ]=boundaries(...
             nx,ny,nz,time,dt,dx,dy,dz,...
             x,y,z,r,psi,...
             alp,cux,cuy,cuz,rg,...
             uxx,uxy,uxz,uyy,uyz,uzz,...
             gxx,gxy,gxz,gyy,gyz,gzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz...
             );        
         
         %write some data to ouput
         outname=sprintf('%s_%d.mat',jobname, currentiter);
         
         save(outname);
end


