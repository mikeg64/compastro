function [out_xx,out_xy,out_xz,out_yy,out_yz,out_zz,rg]=invert(nx,ny,nz,flag,in_xx,in_xy,in_xz,in_yy,in_yz,in_zz)
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%
% [FILE]       invert.cpp
%
% [VERSION]    H3expresso  (c) 1995 Joan Masso, NCSA & UIB
%
% [PURPOSE]    Just the invert routine.
%
% [ROUTINES]   invert
%
% [COMMENTS]   This short routine is put as a separate file because
%              is called from different modules of the program.
%
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

%==============================================================================
%
%  [ROUTINE NAME] invert
%  [AUTHOR] Joan Masso, NCSA & UIB
%
%  [PURPOSE] Invert the metric tensor to compute covariant from
%            contravariant and viceversa. The square root of
%            the determinant is also computed.
%
%  [ARGUMENTS] 
%     [INPUT]
%        nx,ny,nz   : grid sizes of the 3d cube.
%        flag       : Flag to indicate if one is computing
%                     covariant from contravariant (1) of 
%                     contravariant from covariant (-1)
%        in_xx,in_xy,...  : Metric tensor to invert
%     [OUTPUT]
%        rg               : root of the determinant of the covariant metric
%        out_xx,out_xy,...: Inverted metric tensor
% 
%  [CALLED BY]  Initial
%               Method
%               Boundaries
%
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



%    compute determinant of the given metric
%     Note that rg is not yet the roor of the determinant.
      rg= - in_xz.^2.*in_yy + 2.*in_xy.*in_xz.*in_yz - in_xx.*in_yz.^2- in_xy.^2.*in_zz + in_xx.*in_yy.*in_zz;

%    invert metric
      out_xx=(-in_yz.^2 + in_yy.*in_zz)./rg;
      out_xy=(in_xz.*in_yz - in_xy.*in_zz)./rg;
      out_yy=(-in_xz.^2 + in_xx.*in_zz)./rg;
      out_xz=(-in_xz.*in_yy + in_xy.*in_yz)./rg;
      out_yz=(in_xy.*in_xz - in_xx.*in_yz)./rg;
      out_zz=(-in_xy.^2 + in_xx.*in_yy)./rg;

%    assign meaning to rg depending on the flag

%     if 1, then the in_xx was the uppwe contravariant metric so 
%     the determinant that we have must be inverted to get the 
%     covariant determinant.
      if flag==1 
          rg = 1./rg;
      end
%     if -1, the in_xx of this program was the down covariant metric
%     so we do not need to do anything.

%     Finally, take the root of rg so it becomes what it was meant
%     to be (since the beginning of time...)

      rg = sqrt(rg);





