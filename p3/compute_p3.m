function [sR,sT,sdepth1,sdepth2,sdepth3] = compute_p3(adapter)
% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2018, Pedro Miraldo
% 
% This file is part of the Minimal Multi-Perspective Pose
% code and is available under the terms of the MIT License
% provided in LICENSE. Please retain this notice and
% LICENSE if you use this file (or any portion of it)
% in your project.
% ---------------------------------------------------------


% get data from the adapter
%  camera info
C2 = adapter.camera.c2;
C3 = adapter.camera.c3;
D1 = adapter.camera.d1;
D2 = adapter.camera.d2;
D3 = adapter.camera.d3;

% world info
P1  = adapter.world.p1;
P2  = adapter.world.p2;
P3  = adapter.world.p3;

% compute the pose
d11 = D1(1); d12 = D1(2); d13 = D1(3);
d21 = D2(1); d22 = D2(2); d23 = D2(3);
d31 = D3(1); d32 = D3(2); d33 = D3(3);

c21 = C2(1); c22 = C2(2); c23 = C2(3);
c31 = C3(1); c32 = C3(2); c33 = C3(3);

p11 = P1(1); p12 = P1(2); p13 = P1(3);
p21 = P2(1); p22 = P2(2); p23 = P2(3);
p31 = P3(1); p32 = P3(2); p33 = P3(3);

% get the coefficients
k11 = - d11^2 - d12^2 - d13^2;
k12 = 2*d11*d21 + 2*d12*d22 + 2*d13*d23;
k13 = 2*c21*d11 + 2*c22*d12 + 2*c23*d13;
k14 = - d21^2 - d22^2 - d23^2;
k15 = - 2*c21*d21 - 2*c22*d22 - 2*c23*d23; 
k16 = (p11 - p21)^2 - c22^2 - c23^2 - c21^2 + (p12 - p22)^2 + (p13 - p23)^2;

k21 = - d11^2 - d12^2 - d13^2;
k22 = 2*d11*d31 + 2*d12*d32 + 2*d13*d33;
k23 = 2*c31*d11 + 2*c32*d12 + 2*c33*d13;
k24 = - d31^2 - d32^2 - d33^2;
k25 = - 2*c31*d31 - 2*c32*d32 - 2*c33*d33;
k26 = (p11 - p31)^2 - c32^2 - c33^2 - c31^2 + (p12 - p32)^2 + (p13 - p33)^2;
 
k31 = - d21^2 - d22^2 - d23^2;
k32 = 2*d21*d31 + 2*d22*d32 + 2*d23*d33;
k33 = - 2*d21*(c21 - c31) - 2*d22*(c22 - c32) - 2*d23*(c23 - c33);
k34 = - d31^2 - d32^2 - d33^2;
k35 = 2*d31*(c21 - c31) + 2*d32*(c22 - c32) + 2*d33*(c23 - c33);
k36 = (p21 - p31)^2 - (c22 - c32)^2 - (c23 - c33)^2 - (c21 - c31)^2 + (p22 - p32)^2 + (p23 - p33)^2;

i11 = k14^2*k21^2;
i12 = -k12*k14*k21*k22;
i13 = 2*k14*k15*k21^2 - k12*k14*k23*k21;
i14 = k21*k24*k12^2 + k11*k14*k22^2 - 2*k11*k14*k21*k24;
i15 = k21*k25*k12^2 - k15*k21*k22*k12 + 2*k11*k14*k22*k23 - k13*k14*k21*k22 - 2*k11*k14*k21*k25;
i16 = k26*k12^2*k21 - k12*k15*k21*k23 + k15^2*k21^2 + 2*k14*k16*k21^2 - k13*k14*k21*k23 - 2*k11*k14*k26*k21 + k11*k14*k23^2;
i17 = -k11*k12*k22*k24;
i18 = k11*k15*k22^2 - k11*k12*k25*k22 - k11*k12*k23*k24 + 2*k12*k13*k21*k24 - 2*k11*k15*k21*k24;
i19 = 2*k11*k15*k22*k23 - k11*k12*k23*k25 - k11*k12*k22*k26 + 2*k12*k13*k21*k25 - k12*k16*k21*k22 - k13*k15*k21*k22 - 2*k11*k15*k21*k25;
i110 = k11*k15*k23^2 + 2*k15*k16*k21^2 - k11*k12*k23*k26 + 2*k12*k13*k21*k26 - k12*k16*k21*k23 - k13*k15*k21*k23 - 2*k11*k15*k21*k26;
i111 = k11^2*k24^2;
i112 = 2*k24*k25*k11^2 - k13*k22*k24*k11;
i113 = k11^2*k25^2 + 2*k24*k26*k11^2 - k11*k13*k22*k25 - k23*k24*k11*k13 + k16*k11*k22^2 - 2*k16*k21*k24*k11 + k21*k24*k13^2;
i114 = k13^2*k21*k25 + 2*k11^2*k25*k26 - k11*k13*k22*k26 - k11*k13*k23*k25 + 2*k11*k16*k22*k23 - k13*k16*k21*k22 - 2*k11*k16*k21*k25;
i115 = k11^2*k26^2 - k11*k13*k23*k26 - 2*k11*k16*k21*k26 + k11*k16*k23^2 + k13^2*k21*k26 - k13*k16*k21*k23 + k16^2*k21^2;
 
c1 = i11^2*k34^4 - i11*i12*k32*k34^3 - 2*i11*i14*k31*k34^3 + i11*i14*k32^2*k34^2 + 3*i11*i17*k31*k32*k34^2 - i11*i17*k32^3*k34 + 2*i11*i111*k31^2*k34^2 - 4*i11*i111*k31*k32^2*k34 + i11*i111*k32^4 + i12^2*k31*k34^3 - i12*i14*k31*k32*k34^2 - 2*i12*i17*k31^2*k34^2 + i12*i17*k31*k32^2*k34 + 3*i12*i111*k31^2*k32*k34 - i12*i111*k31*k32^3 + i14^2*k31^2*k34^2 - i14*i17*k31^2*k32*k34 - 2*i14*i111*k31^3*k34 + i14*i111*k31^2*k32^2 + i17^2*k31^3*k34 - i17*i111*k31^3*k32 + i111^2*k31^4;
c2 = 4*k35*i11^2*k34^3 - 3*k35*i11*i12*k32*k34^2 - k33*i11*i12*k34^3 - 6*k35*i11*i14*k31*k34^2 + 2*k35*i11*i14*k32^2*k34 + 2*k33*i11*i14*k32*k34^2 + 6*k35*i11*i17*k31*k32*k34 + 3*k33*i11*i17*k31*k34^2 - k35*i11*i17*k32^3 - 3*k33*i11*i17*k32^2*k34 + 2*i112*i11*k31^2*k34^2 + 4*i111*k35*i11*k31^2*k34 - 4*i112*i11*k31*k32^2*k34 - 4*i111*k35*i11*k31*k32^2 + 3*i18*i11*k31*k32*k34^2 - 8*i111*k33*i11*k31*k32*k34 - 2*i15*i11*k31*k34^3 + i112*i11*k32^4 - i18*i11*k32^3*k34 + 4*i111*k33*i11*k32^3 + i15*i11*k32^2*k34^2 - i13*i11*k32*k34^3 + 3*k35*i12^2*k31*k34^2 - 2*k35*i12*i14*k31*k32*k34 - k33*i12*i14*k31*k34^2 - 4*k35*i12*i17*k31^2*k34 + k35*i12*i17*k31*k32^2 + 2*k33*i12*i17*k31*k32*k34 + 3*i112*i12*k31^2*k32*k34 + 3*i111*k35*i12*k31^2*k32 - 2*i18*i12*k31^2*k34^2 + 3*i111*k33*i12*k31^2*k34 - i112*i12*k31*k32^3 + i18*i12*k31*k32^2*k34 - 3*i111*k33*i12*k31*k32^2 - i15*i12*k31*k32*k34^2 + 2*i13*i12*k31*k34^3 + 2*k35*i14^2*k31^2*k34 - k35*i14*i17*k31^2*k32 - k33*i14*i17*k31^2*k34 - 2*i112*i14*k31^3*k34 - 2*i111*k35*i14*k31^3 + i112*i14*k31^2*k32^2 - i18*i14*k31^2*k32*k34 + 2*i111*k33*i14*k31^2*k32 + 2*i15*i14*k31^2*k34^2 - i13*i14*k31*k32*k34^2 + k35*i17^2*k31^3 - i112*i17*k31^3*k32 + 2*i18*i17*k31^3*k34 - i111*k33*i17*k31^3 - i15*i17*k31^2*k32*k34 - 2*i13*i17*k31^2*k34^2 + i13*i17*k31*k32^2*k34 + 2*i111*i112*k31^4 - i18*i111*k31^3*k32 - 2*i15*i111*k31^3*k34 + i15*i111*k31^2*k32^2 + 3*i13*i111*k31^2*k32*k34 - i13*i111*k31*k32^3;
c3 = 4*k36*i11^2*k34^3 + 6*i11^2*k34^2*k35^2 - 3*k36*i11*i12*k32*k34^2 - 3*i11*i12*k32*k34*k35^2 - 3*i11*i12*k33*k34^2*k35 - 3*i11*i13*k32*k34^2*k35 - i11*i13*k33*k34^3 - 6*k36*i11*i14*k31*k34^2 - 6*i11*i14*k31*k34*k35^2 + 2*k36*i11*i14*k32^2*k34 + i11*i14*k32^2*k35^2 + 4*i11*i14*k32*k33*k34*k35 + i11*i14*k33^2*k34^2 - 6*i11*i15*k31*k34^2*k35 + 2*i11*i15*k32^2*k34*k35 + 2*i11*i15*k32*k33*k34^2 + 6*k36*i11*i17*k31*k32*k34 + 3*i11*i17*k31*k32*k35^2 + 6*i11*i17*k31*k33*k34*k35 - k36*i11*i17*k32^3 - 3*i11*i17*k32^2*k33*k35 - 3*i11*i17*k32*k33^2*k34 + 6*i11*i18*k31*k32*k34*k35 + 3*i11*i18*k31*k33*k34^2 - i11*i18*k32^3*k35 - 3*i11*i18*k32^2*k33*k34 + 4*i11*i112*k31^2*k34*k35 - 4*i11*i112*k31*k32^2*k35 - 8*i11*i112*k31*k32*k33*k34 + 4*i11*i112*k32^3*k33 + 2*i113*i11*k31^2*k34^2 + 4*i111*k36*i11*k31^2*k34 + 2*i111*i11*k31^2*k35^2 - 4*i113*i11*k31*k32^2*k34 - 4*i111*k36*i11*k31*k32^2 - 8*i111*i11*k31*k32*k33*k35 + 3*i19*i11*k31*k32*k34^2 - 4*i111*i11*k31*k33^2*k34 - 2*i16*i11*k31*k34^3 + i113*i11*k32^4 - i19*i11*k32^3*k34 + 6*i111*i11*k32^2*k33^2 + i16*i11*k32^2*k34^2 + 3*k36*i12^2*k31*k34^2 + 3*i12^2*k31*k34*k35^2 + 6*i12*i13*k31*k34^2*k35 - 2*k36*i12*i14*k31*k32*k34 - i12*i14*k31*k32*k35^2 - 2*i12*i14*k31*k33*k34*k35 - 2*i12*i15*k31*k32*k34*k35 - i12*i15*k31*k33*k34^2 - 4*k36*i12*i17*k31^2*k34 - 2*i12*i17*k31^2*k35^2 + k36*i12*i17*k31*k32^2 + 2*i12*i17*k31*k32*k33*k35 + i12*i17*k31*k33^2*k34 - 4*i12*i18*k31^2*k34*k35 + i12*i18*k31*k32^2*k35 + 2*i12*i18*k31*k32*k33*k34 + 3*i12*i112*k31^2*k32*k35 + 3*i12*i112*k31^2*k33*k34 - 3*i12*i112*k31*k32^2*k33 + 3*i113*i12*k31^2*k32*k34 + 3*i111*k36*i12*k31^2*k32 + 3*i111*i12*k31^2*k33*k35 - 2*i19*i12*k31^2*k34^2 - i113*i12*k31*k32^3 + i19*i12*k31*k32^2*k34 - 3*i111*i12*k31*k32*k33^2 - i16*i12*k31*k32*k34^2 + i13^2*k31*k34^3 - 2*i13*i14*k31*k32*k34*k35 - i13*i14*k31*k33*k34^2 - i13*i15*k31*k32*k34^2 - 4*i13*i17*k31^2*k34*k35 + i13*i17*k31*k32^2*k35 + 2*i13*i17*k31*k32*k33*k34 - 2*i13*i18*k31^2*k34^2 + i13*i18*k31*k32^2*k34 + 3*i13*i112*k31^2*k32*k34 - i13*i112*k31*k32^3 + 3*i111*i13*k31^2*k32*k35 + 3*i111*i13*k31^2*k33*k34 - 3*i111*i13*k31*k32^2*k33 + 2*k36*i14^2*k31^2*k34 + i14^2*k31^2*k35^2 + 4*i14*i15*k31^2*k34*k35 - k36*i14*i17*k31^2*k32 - i14*i17*k31^2*k33*k35 - i14*i18*k31^2*k32*k35 - i14*i18*k31^2*k33*k34 - 2*i14*i112*k31^3*k35 + 2*i14*i112*k31^2*k32*k33 - 2*i113*i14*k31^3*k34 - 2*i111*k36*i14*k31^3 + i113*i14*k31^2*k32^2 - i19*i14*k31^2*k32*k34 + i111*i14*k31^2*k33^2 + 2*i16*i14*k31^2*k34^2 + i15^2*k31^2*k34^2 - i15*i17*k31^2*k32*k35 - i15*i17*k31^2*k33*k34 - i15*i18*k31^2*k32*k34 - 2*i15*i112*k31^3*k34 + i15*i112*k31^2*k32^2 - 2*i111*i15*k31^3*k35 + 2*i111*i15*k31^2*k32*k33 + k36*i17^2*k31^3 + 2*i17*i18*k31^3*k35 - i17*i112*k31^3*k33 - i113*i17*k31^3*k32 + 2*i19*i17*k31^3*k34 - i16*i17*k31^2*k32*k34 + i18^2*k31^3*k34 - i18*i112*k31^3*k32 - i111*i18*k31^3*k33 + i112^2*k31^4 + 2*i111*i113*k31^4 - i19*i111*k31^3*k32 - 2*i16*i111*k31^3*k34 + i16*i111*k31^2*k32^2;
c4 = i12^2*k31*k35^3 + 4*i11^2*k34*k35^3 + i18^2*k31^3*k35 + i11*i114*k32^4 + 2*i111*i114*k31^4 + 2*i112*i113*k31^4 - i11*i12*k32*k35^3 - 2*i11*i14*k31*k35^3 - i11*i17*k33^3*k34 - i11*i18*k32^3*k36 - i11*i19*k32^3*k35 + 2*i17*i18*k31^3*k36 + 2*i17*i19*k31^3*k35 + 2*i18*i19*k31^3*k34 - i11*i110*k32^3*k34 + 4*i11*i111*k32*k33^3 - i12*i111*k31*k33^3 + 4*i11*i113*k32^3*k33 - i12*i114*k31*k32^3 - i13*i113*k31*k32^3 + 2*i17*i110*k31^3*k34 - 2*i14*i112*k31^3*k36 - 2*i14*i113*k31^3*k35 - 2*i14*i114*k31^3*k34 - 2*i15*i111*k31^3*k36 - 2*i15*i112*k31^3*k35 - 2*i15*i113*k31^3*k34 - 2*i16*i111*k31^3*k35 - 2*i16*i112*k31^3*k34 - i17*i113*k31^3*k33 - i17*i114*k31^3*k32 - i18*i112*k31^3*k33 - i18*i113*k31^3*k32 - i19*i111*k31^3*k33 - i19*i112*k31^3*k32 - i110*i111*k31^3*k32 + i11*i15*k32^2*k35^2 + i11*i15*k33^2*k34^2 + 2*i14*i15*k31^2*k35^2 - 2*i12*i18*k31^2*k35^2 - 2*i13*i17*k31^2*k35^2 + 2*i15*i16*k31^2*k34^2 - 2*i13*i19*k31^2*k34^2 - 2*i12*i110*k31^2*k34^2 + 6*i11*i112*k32^2*k33^2 + 2*i11*i112*k31^2*k35^2 + 2*i11*i114*k31^2*k34^2 + i14*i112*k31^2*k33^2 + i15*i111*k31^2*k33^2 + i14*i114*k31^2*k32^2 + i15*i113*k31^2*k32^2 + i16*i112*k31^2*k32^2 + 3*i13^2*k31*k34^2*k35 + 2*i15^2*k31^2*k34*k35 + 12*i11^2*k34^2*k35*k36 + 2*i14^2*k31^2*k35*k36 - 3*i11*i12*k33*k34*k35^2 - 3*i11*i13*k32*k34*k35^2 + 2*i11*i14*k32*k33*k35^2 + 6*i12*i13*k31*k34*k35^2 - i12*i14*k31*k33*k35^2 - i12*i15*k31*k32*k35^2 - i13*i14*k31*k32*k35^2 - 3*i11*i12*k33*k34^2*k36 - 3*i11*i13*k32*k34^2*k36 - 3*i11*i13*k33*k34^2*k35 - 6*i11*i15*k31*k34*k35^2 + 2*i11*i16*k32*k33*k34^2 + 6*i12*i13*k31*k34^2*k36 - i12*i16*k31*k33*k34^2 - i13*i15*k31*k33*k34^2 - i13*i16*k31*k32*k34^2 + 2*i11*i14*k33^2*k34*k35 - 6*i11*i15*k31*k34^2*k36 - 6*i11*i16*k31*k34^2*k35 + 3*i11*i17*k31*k33*k35^2 + 3*i11*i18*k31*k32*k35^2 + 2*i11*i14*k32^2*k35*k36 + 2*i11*i15*k32^2*k34*k36 + 2*i11*i16*k32^2*k34*k35 - 3*i11*i17*k32*k33^2*k35 - 3*i11*i18*k32*k33^2*k34 + 3*i11*i19*k31*k33*k34^2 + i12*i17*k31*k33^2*k35 + i12*i18*k31*k33^2*k34 + i13*i17*k31*k33^2*k34 - 3*i11*i17*k32^2*k33*k36 - 3*i11*i18*k32^2*k33*k35 - 3*i11*i19*k32^2*k33*k34 + i12*i18*k31*k32^2*k36 + i12*i19*k31*k32^2*k35 + i13*i17*k31*k32^2*k36 + i13*i18*k31*k32^2*k35 + i13*i19*k31*k32^2*k34 + 4*i14*i15*k31^2*k34*k36 + 4*i14*i16*k31^2*k34*k35 - 4*i12*i17*k31^2*k35*k36 - 4*i12*i18*k31^2*k34*k36 - 4*i12*i19*k31^2*k34*k35 - 4*i13*i17*k31^2*k34*k36 - 4*i13*i18*k31^2*k34*k35 - i14*i17*k31^2*k33*k36 - i14*i18*k31^2*k32*k36 - i14*i18*k31^2*k33*k35 - i14*i19*k31^2*k32*k35 - i14*i19*k31^2*k33*k34 - i15*i17*k31^2*k32*k36 - i15*i17*k31^2*k33*k35 - i15*i18*k31^2*k32*k35 - i15*i18*k31^2*k33*k34 - i15*i19*k31^2*k32*k34 - i16*i17*k31^2*k32*k35 - i16*i17*k31^2*k33*k34 - i16*i18*k31^2*k32*k34 + 3*i11*i110*k31*k32*k34^2 + i12*i110*k31*k32^2*k34 - 3*i12*i112*k31*k32*k33^2 - 3*i13*i111*k31*k32*k33^2 - 4*i11*i111*k31*k33^2*k35 - 4*i11*i112*k31*k33^2*k34 - 3*i12*i113*k31*k32^2*k33 - 3*i13*i112*k31*k32^2*k33 - i14*i110*k31^2*k32*k34 - 4*i11*i112*k31*k32^2*k36 - 4*i11*i113*k31*k32^2*k35 - 4*i11*i114*k31*k32^2*k34 + 3*i12*i111*k31^2*k33*k36 + 3*i12*i112*k31^2*k32*k36 + 3*i12*i112*k31^2*k33*k35 + 3*i12*i113*k31^2*k32*k35 + 3*i12*i113*k31^2*k33*k34 + 3*i12*i114*k31^2*k32*k34 + 3*i13*i111*k31^2*k32*k36 + 3*i13*i111*k31^2*k33*k35 + 3*i13*i112*k31^2*k32*k35 + 3*i13*i112*k31^2*k33*k34 + 3*i13*i113*k31^2*k32*k34 + 2*i14*i113*k31^2*k32*k33 + 2*i15*i112*k31^2*k32*k33 + 2*i16*i111*k31^2*k32*k33 + 4*i11*i111*k31^2*k35*k36 + 4*i11*i112*k31^2*k34*k36 + 4*i11*i113*k31^2*k34*k35 + 6*i12^2*k31*k34*k35*k36 - 6*i11*i12*k32*k34*k35*k36 + 4*i11*i14*k32*k33*k34*k36 + 4*i11*i15*k32*k33*k34*k35 - 2*i12*i14*k31*k32*k35*k36 - 2*i12*i14*k31*k33*k34*k36 - 2*i12*i15*k31*k32*k34*k36 - 2*i12*i15*k31*k33*k34*k35 - 2*i12*i16*k31*k32*k34*k35 - 2*i13*i14*k31*k32*k34*k36 - 2*i13*i14*k31*k33*k34*k35 - 2*i13*i15*k31*k32*k34*k35 - 12*i11*i14*k31*k34*k35*k36 + 2*i12*i17*k31*k32*k33*k36 + 2*i12*i18*k31*k32*k33*k35 + 2*i12*i19*k31*k32*k33*k34 + 2*i13*i17*k31*k32*k33*k35 + 2*i13*i18*k31*k32*k33*k34 + 6*i11*i17*k31*k32*k35*k36 + 6*i11*i17*k31*k33*k34*k36 + 6*i11*i18*k31*k32*k34*k36 + 6*i11*i18*k31*k33*k34*k35 + 6*i11*i19*k31*k32*k34*k35 - 8*i11*i111*k31*k32*k33*k36 - 8*i11*i112*k31*k32*k33*k35 - 8*i11*i113*k31*k32*k33*k34;
c5 = i11^2*k35^4 + i113^2*k31^4 + i19^2*k31^3*k34 + i18^2*k31^3*k36 + 6*i11^2*k34^2*k36^2 + i14^2*k31^2*k36^2 + i15^2*k31^2*k35^2 + i16^2*k31^2*k34^2 + i11*i111*k33^4 + i11*i115*k32^4 + 2*i111*i115*k31^4 + 2*i112*i114*k31^4 - i11*i12*k33*k35^3 - i11*i13*k32*k35^3 + 2*i12*i13*k31*k35^3 - 2*i11*i15*k31*k35^3 - i11*i17*k33^3*k35 - i11*i18*k33^3*k34 - i11*i19*k32^3*k36 + 2*i17*i19*k31^3*k36 + 2*i18*i19*k31^3*k35 - i11*i110*k32^3*k35 + 4*i11*i112*k32*k33^3 - i12*i112*k31*k33^3 - i13*i111*k31*k33^3 + 4*i11*i114*k32^3*k33 - i12*i115*k31*k32^3 - i13*i114*k31*k32^3 + 2*i17*i110*k31^3*k35 + 2*i18*i110*k31^3*k34 - 2*i14*i113*k31^3*k36 - 2*i14*i114*k31^3*k35 - 2*i14*i115*k31^3*k34 - 2*i15*i112*k31^3*k36 - 2*i15*i113*k31^3*k35 - 2*i15*i114*k31^3*k34 - 2*i16*i111*k31^3*k36 - 2*i16*i112*k31^3*k35 - 2*i16*i113*k31^3*k34 - i17*i114*k31^3*k33 - i17*i115*k31^3*k32 - i18*i113*k31^3*k33 - i18*i114*k31^3*k32 - i19*i112*k31^3*k33 - i19*i113*k31^3*k32 - i110*i111*k31^3*k33 - i110*i112*k31^3*k32 + i11*i14*k32^2*k36^2 + i11*i14*k33^2*k35^2 + i11*i16*k32^2*k35^2 + i11*i16*k33^2*k34^2 - 2*i12*i17*k31^2*k36^2 + 2*i14*i16*k31^2*k35^2 - 2*i12*i19*k31^2*k35^2 - 2*i13*i18*k31^2*k35^2 - 2*i13*i110*k31^2*k34^2 + 2*i11*i111*k31^2*k36^2 + 6*i11*i113*k32^2*k33^2 + 2*i11*i113*k31^2*k35^2 + 2*i11*i115*k31^2*k34^2 + i14*i113*k31^2*k33^2 + i15*i112*k31^2*k33^2 + i16*i111*k31^2*k33^2 + i14*i115*k31^2*k32^2 + i15*i114*k31^2*k32^2 + i16*i113*k31^2*k32^2 + 3*i12^2*k31*k34*k36^2 + 3*i13^2*k31*k34*k35^2 + 3*i12^2*k31*k35^2*k36 + 3*i13^2*k31*k34^2*k36 + 12*i11^2*k34*k35^2*k36 + 2*i15^2*k31^2*k34*k36 - 3*i11*i12*k32*k34*k36^2 - i12*i14*k31*k32*k36^2 - 3*i11*i12*k32*k35^2*k36 - 3*i11*i13*k33*k34*k35^2 - 6*i11*i14*k31*k34*k36^2 + 2*i11*i15*k32*k33*k35^2 - i12*i15*k31*k33*k35^2 - i12*i16*k31*k32*k35^2 - i13*i14*k31*k33*k35^2 - i13*i15*k31*k32*k35^2 - 3*i11*i13*k33*k34^2*k36 - 6*i11*i14*k31*k35^2*k36 - 6*i11*i16*k31*k34*k35^2 + 3*i11*i17*k31*k32*k36^2 - i13*i16*k31*k33*k34^2 + 2*i11*i14*k33^2*k34*k36 + 2*i11*i15*k33^2*k34*k35 - 6*i11*i16*k31*k34^2*k36 + 3*i11*i18*k31*k33*k35^2 + 3*i11*i19*k31*k32*k35^2 + 2*i11*i15*k32^2*k35*k36 + 2*i11*i16*k32^2*k34*k36 - 3*i11*i17*k32*k33^2*k36 - 3*i11*i18*k32*k33^2*k35 - 3*i11*i19*k32*k33^2*k34 + i12*i17*k31*k33^2*k36 + i12*i18*k31*k33^2*k35 + i12*i19*k31*k33^2*k34 + i13*i17*k31*k33^2*k35 + i13*i18*k31*k33^2*k34 - 3*i11*i18*k32^2*k33*k36 - 3*i11*i19*k32^2*k33*k35 + i12*i19*k31*k32^2*k36 + i13*i18*k31*k32^2*k36 + i13*i19*k31*k32^2*k35 + 4*i14*i15*k31^2*k35*k36 + 4*i14*i16*k31^2*k34*k36 + 4*i15*i16*k31^2*k34*k35 - 4*i12*i18*k31^2*k35*k36 - 4*i12*i19*k31^2*k34*k36 - 4*i13*i17*k31^2*k35*k36 - 4*i13*i18*k31^2*k34*k36 - 4*i13*i19*k31^2*k34*k35 - i14*i18*k31^2*k33*k36 - i14*i19*k31^2*k32*k36 - i14*i19*k31^2*k33*k35 - i15*i17*k31^2*k33*k36 - i15*i18*k31^2*k32*k36 - i15*i18*k31^2*k33*k35 - i15*i19*k31^2*k32*k35 - i15*i19*k31^2*k33*k34 - i16*i17*k31^2*k32*k36 - i16*i17*k31^2*k33*k35 - i16*i18*k31^2*k32*k35 - i16*i18*k31^2*k33*k34 - i16*i19*k31^2*k32*k34 + 3*i11*i110*k31*k33*k34^2 - 3*i11*i110*k32^2*k33*k34 + i12*i110*k31*k32^2*k35 + i13*i110*k31*k32^2*k34 - 3*i12*i113*k31*k32*k33^2 - 3*i13*i112*k31*k32*k33^2 - 4*i11*i111*k31*k33^2*k36 - 4*i11*i112*k31*k33^2*k35 - 4*i11*i113*k31*k33^2*k34 - 4*i12*i110*k31^2*k34*k35 - 3*i12*i114*k31*k32^2*k33 - 3*i13*i113*k31*k32^2*k33 - i14*i110*k31^2*k32*k35 - i14*i110*k31^2*k33*k34 - i15*i110*k31^2*k32*k34 - 4*i11*i113*k31*k32^2*k36 - 4*i11*i114*k31*k32^2*k35 - 4*i11*i115*k31*k32^2*k34 + 3*i12*i112*k31^2*k33*k36 + 3*i12*i113*k31^2*k32*k36 + 3*i12*i113*k31^2*k33*k35 + 3*i12*i114*k31^2*k32*k35 + 3*i12*i114*k31^2*k33*k34 + 3*i12*i115*k31^2*k32*k34 + 3*i13*i111*k31^2*k33*k36 + 3*i13*i112*k31^2*k32*k36 + 3*i13*i112*k31^2*k33*k35 + 3*i13*i113*k31^2*k32*k35 + 3*i13*i113*k31^2*k33*k34 + 3*i13*i114*k31^2*k32*k34 + 2*i14*i114*k31^2*k32*k33 + 2*i15*i113*k31^2*k32*k33 + 2*i16*i112*k31^2*k32*k33 + 4*i11*i112*k31^2*k35*k36 + 4*i11*i113*k31^2*k34*k36 + 4*i11*i114*k31^2*k34*k35 - 6*i11*i12*k33*k34*k35*k36 - 6*i11*i13*k32*k34*k35*k36 + 4*i11*i14*k32*k33*k35*k36 + 4*i11*i15*k32*k33*k34*k36 + 4*i11*i16*k32*k33*k34*k35 + 12*i12*i13*k31*k34*k35*k36 - 2*i12*i14*k31*k33*k35*k36 - 2*i12*i15*k31*k32*k35*k36 - 2*i12*i15*k31*k33*k34*k36 - 2*i12*i16*k31*k32*k34*k36 - 2*i12*i16*k31*k33*k34*k35 - 2*i13*i14*k31*k32*k35*k36 - 2*i13*i14*k31*k33*k34*k36 - 2*i13*i15*k31*k32*k34*k36 - 2*i13*i15*k31*k33*k34*k35 - 2*i13*i16*k31*k32*k34*k35 - 12*i11*i15*k31*k34*k35*k36 + 2*i12*i18*k31*k32*k33*k36 + 2*i12*i19*k31*k32*k33*k35 + 2*i13*i17*k31*k32*k33*k36 + 2*i13*i18*k31*k32*k33*k35 + 2*i13*i19*k31*k32*k33*k34 + 6*i11*i17*k31*k33*k35*k36 + 6*i11*i18*k31*k32*k35*k36 + 6*i11*i18*k31*k33*k34*k36 + 6*i11*i19*k31*k32*k34*k36 + 6*i11*i19*k31*k33*k34*k35 + 2*i12*i110*k31*k32*k33*k34 + 6*i11*i110*k31*k32*k34*k35 - 8*i11*i112*k31*k32*k33*k36 - 8*i11*i113*k31*k32*k33*k35 - 8*i11*i114*k31*k32*k33*k34;
c6 = i13^2*k31*k35^3 + 4*i11^2*k35^3*k36 + i19^2*k31^3*k35 + i11*i112*k33^4 + 2*i112*i115*k31^4 + 2*i113*i114*k31^4 - i11*i13*k33*k35^3 - 2*i11*i16*k31*k35^3 - i11*i17*k33^3*k36 - i11*i18*k33^3*k35 - i11*i19*k33^3*k34 + 2*i18*i19*k31^3*k36 - i11*i110*k32^3*k36 + 4*i11*i113*k32*k33^3 - i12*i113*k31*k33^3 - i13*i112*k31*k33^3 + 4*i11*i115*k32^3*k33 - i13*i115*k31*k32^3 + 2*i17*i110*k31^3*k36 + 2*i18*i110*k31^3*k35 + 2*i19*i110*k31^3*k34 - 2*i14*i114*k31^3*k36 - 2*i14*i115*k31^3*k35 - 2*i15*i113*k31^3*k36 - 2*i15*i114*k31^3*k35 - 2*i15*i115*k31^3*k34 - 2*i16*i112*k31^3*k36 - 2*i16*i113*k31^3*k35 - 2*i16*i114*k31^3*k34 - i17*i115*k31^3*k33 - i18*i114*k31^3*k33 - i18*i115*k31^3*k32 - i19*i113*k31^3*k33 - i19*i114*k31^3*k32 - i110*i112*k31^3*k33 - i110*i113*k31^3*k32 + i11*i15*k32^2*k36^2 + i11*i15*k33^2*k35^2 + 2*i14*i15*k31^2*k36^2 - 2*i12*i18*k31^2*k36^2 - 2*i13*i17*k31^2*k36^2 + 2*i15*i16*k31^2*k35^2 - 2*i13*i19*k31^2*k35^2 - 2*i12*i110*k31^2*k35^2 + 2*i11*i112*k31^2*k36^2 + 6*i11*i114*k32^2*k33^2 + 2*i11*i114*k31^2*k35^2 + i14*i114*k31^2*k33^2 + i15*i113*k31^2*k33^2 + i16*i112*k31^2*k33^2 + i15*i115*k31^2*k32^2 + i16*i114*k31^2*k32^2 + 3*i12^2*k31*k35*k36^2 + 12*i11^2*k34*k35*k36^2 + 2*i16^2*k31^2*k34*k35 + 2*i15^2*k31^2*k35*k36 - 3*i11*i12*k32*k35*k36^2 - 3*i11*i12*k33*k34*k36^2 - 3*i11*i13*k32*k34*k36^2 + 2*i11*i14*k32*k33*k36^2 + 6*i12*i13*k31*k34*k36^2 - i12*i14*k31*k33*k36^2 - i12*i15*k31*k32*k36^2 - i13*i14*k31*k32*k36^2 - 3*i11*i12*k33*k35^2*k36 - 3*i11*i13*k32*k35^2*k36 - 6*i11*i14*k31*k35*k36^2 - 6*i11*i15*k31*k34*k36^2 + 2*i11*i16*k32*k33*k35^2 + 6*i12*i13*k31*k35^2*k36 - i12*i16*k31*k33*k35^2 - i13*i15*k31*k33*k35^2 - i13*i16*k31*k32*k35^2 - 6*i11*i15*k31*k35^2*k36 + 3*i11*i17*k31*k33*k36^2 + 3*i11*i18*k31*k32*k36^2 + 2*i11*i14*k33^2*k35*k36 + 2*i11*i15*k33^2*k34*k36 + 2*i11*i16*k33^2*k34*k35 + 3*i11*i19*k31*k33*k35^2 + 2*i11*i16*k32^2*k35*k36 - 3*i11*i18*k32*k33^2*k36 - 3*i11*i19*k32*k33^2*k35 + i12*i18*k31*k33^2*k36 + i12*i19*k31*k33^2*k35 + i13*i17*k31*k33^2*k36 + i13*i18*k31*k33^2*k35 + i13*i19*k31*k33^2*k34 - 3*i11*i19*k32^2*k33*k36 + i13*i19*k31*k32^2*k36 + 4*i14*i16*k31^2*k35*k36 + 4*i15*i16*k31^2*k34*k36 - 4*i12*i19*k31^2*k35*k36 - 4*i13*i18*k31^2*k35*k36 - 4*i13*i19*k31^2*k34*k36 - i14*i19*k31^2*k33*k36 - i15*i18*k31^2*k33*k36 - i15*i19*k31^2*k32*k36 - i15*i19*k31^2*k33*k35 - i16*i17*k31^2*k33*k36 - i16*i18*k31^2*k32*k36 - i16*i18*k31^2*k33*k35 - i16*i19*k31^2*k32*k35 - i16*i19*k31^2*k33*k34 + 3*i11*i110*k31*k32*k35^2 - 3*i11*i110*k32*k33^2*k34 + i12*i110*k31*k33^2*k34 - 3*i11*i110*k32^2*k33*k35 + i12*i110*k31*k32^2*k36 + i13*i110*k31*k32^2*k35 - 3*i12*i114*k31*k32*k33^2 - 3*i13*i113*k31*k32*k33^2 - 4*i11*i112*k31*k33^2*k36 - 4*i11*i113*k31*k33^2*k35 - 4*i11*i114*k31*k33^2*k34 - 4*i12*i110*k31^2*k34*k36 - 3*i12*i115*k31*k32^2*k33 - 4*i13*i110*k31^2*k34*k35 - 3*i13*i114*k31*k32^2*k33 - i14*i110*k31^2*k32*k36 - i14*i110*k31^2*k33*k35 - i15*i110*k31^2*k32*k35 - i15*i110*k31^2*k33*k34 - i16*i110*k31^2*k32*k34 - 4*i11*i114*k31*k32^2*k36 - 4*i11*i115*k31*k32^2*k35 + 3*i12*i113*k31^2*k33*k36 + 3*i12*i114*k31^2*k32*k36 + 3*i12*i114*k31^2*k33*k35 + 3*i12*i115*k31^2*k32*k35 + 3*i12*i115*k31^2*k33*k34 + 3*i13*i112*k31^2*k33*k36 + 3*i13*i113*k31^2*k32*k36 + 3*i13*i113*k31^2*k33*k35 + 3*i13*i114*k31^2*k32*k35 + 3*i13*i114*k31^2*k33*k34 + 3*i13*i115*k31^2*k32*k34 + 2*i14*i115*k31^2*k32*k33 + 2*i15*i114*k31^2*k32*k33 + 2*i16*i113*k31^2*k32*k33 + 4*i11*i113*k31^2*k35*k36 + 4*i11*i114*k31^2*k34*k36 + 4*i11*i115*k31^2*k34*k35 + 6*i13^2*k31*k34*k35*k36 - 6*i11*i13*k33*k34*k35*k36 + 4*i11*i15*k32*k33*k35*k36 + 4*i11*i16*k32*k33*k34*k36 - 2*i12*i15*k31*k33*k35*k36 - 2*i12*i16*k31*k32*k35*k36 - 2*i12*i16*k31*k33*k34*k36 - 2*i13*i14*k31*k33*k35*k36 - 2*i13*i15*k31*k32*k35*k36 - 2*i13*i15*k31*k33*k34*k36 - 2*i13*i16*k31*k32*k34*k36 - 2*i13*i16*k31*k33*k34*k35 - 12*i11*i16*k31*k34*k35*k36 + 2*i12*i19*k31*k32*k33*k36 + 2*i13*i18*k31*k32*k33*k36 + 2*i13*i19*k31*k32*k33*k35 + 6*i11*i18*k31*k33*k35*k36 + 6*i11*i19*k31*k32*k35*k36 + 6*i11*i19*k31*k33*k34*k36 + 2*i12*i110*k31*k32*k33*k35 + 2*i13*i110*k31*k32*k33*k34 + 6*i11*i110*k31*k32*k34*k36 + 6*i11*i110*k31*k33*k34*k35 - 8*i11*i113*k31*k32*k33*k36 - 8*i11*i114*k31*k32*k33*k35 - 8*i11*i115*k31*k32*k33*k34;
c7 = 6*i11^2*k35^2*k36^2 + 4*k34*i11^2*k36^3 - i11*i12*k32*k36^3 - 3*i11*i12*k33*k35*k36^2 - 3*i11*i13*k32*k35*k36^2 - 3*i11*i13*k33*k35^2*k36 - 3*k34*i11*i13*k33*k36^2 - 6*i11*i15*k31*k35*k36^2 + 2*i11*i15*k32*k33*k36^2 + 2*i11*i15*k33^2*k35*k36 - 6*i11*i16*k31*k35^2*k36 - 6*k34*i11*i16*k31*k36^2 + i11*i16*k32^2*k36^2 + 4*i11*i16*k32*k33*k35*k36 + i11*i16*k33^2*k35^2 + 2*k34*i11*i16*k33^2*k36 + 3*i11*i19*k31*k32*k36^2 + 6*i11*i19*k31*k33*k35*k36 - 3*i11*i19*k32*k33^2*k36 - i11*i19*k33^3*k35 + 6*i11*i110*k31*k32*k35*k36 + 3*i11*i110*k31*k33*k35^2 + 6*k34*i11*i110*k31*k33*k36 - 3*i11*i110*k32^2*k33*k36 - 3*i11*i110*k32*k33^2*k35 - k34*i11*i110*k33^3 + 4*i11*i114*k31^2*k35*k36 - 8*i11*i114*k31*k32*k33*k36 - 4*i11*i114*k31*k33^2*k35 + 4*i11*i114*k32*k33^3 + 2*i115*i11*k31^2*k35^2 + 2*i113*i11*k31^2*k36^2 + 4*i115*k34*i11*k31^2*k36 - 4*i115*i11*k31*k32^2*k36 - 8*i115*i11*k31*k32*k33*k35 - 4*i113*i11*k31*k33^2*k36 - 4*i115*k34*i11*k31*k33^2 + 3*i18*i11*k31*k33*k36^2 - 2*i14*i11*k31*k36^3 + 6*i115*i11*k32^2*k33^2 + i113*i11*k33^4 - i18*i11*k33^3*k36 + i14*i11*k33^2*k36^2 + i12^2*k31*k36^3 + 6*i12*i13*k31*k35*k36^2 - i12*i15*k31*k33*k36^2 - i12*i16*k31*k32*k36^2 - 2*i12*i16*k31*k33*k35*k36 - 2*i12*i19*k31^2*k36^2 + i12*i19*k31*k33^2*k36 - 4*i12*i110*k31^2*k35*k36 + 2*i12*i110*k31*k32*k33*k36 + i12*i110*k31*k33^2*k35 + 3*i12*i114*k31^2*k33*k36 - i12*i114*k31*k33^3 + 3*i115*i12*k31^2*k32*k36 + 3*i115*i12*k31^2*k33*k35 - 3*i115*i12*k31*k32*k33^2 + 3*i13^2*k31*k35^2*k36 + 3*k34*i13^2*k31*k36^2 - i13*i15*k31*k32*k36^2 - 2*i13*i15*k31*k33*k35*k36 - 2*i13*i16*k31*k32*k35*k36 - i13*i16*k31*k33*k35^2 - 2*k34*i13*i16*k31*k33*k36 - 4*i13*i19*k31^2*k35*k36 + 2*i13*i19*k31*k32*k33*k36 + i13*i19*k31*k33^2*k35 - 2*i13*i110*k31^2*k35^2 - 4*k34*i13*i110*k31^2*k36 + i13*i110*k31*k32^2*k36 + 2*i13*i110*k31*k32*k33*k35 + k34*i13*i110*k31*k33^2 + 3*i13*i114*k31^2*k32*k36 + 3*i13*i114*k31^2*k33*k35 - 3*i13*i114*k31*k32*k33^2 + 3*i115*i13*k31^2*k32*k35 + 3*i113*i13*k31^2*k33*k36 + 3*i115*k34*i13*k31^2*k33 - 2*i18*i13*k31^2*k36^2 - 3*i115*i13*k31*k32^2*k33 - i113*i13*k31*k33^3 + i18*i13*k31*k33^2*k36 - i14*i13*k31*k33*k36^2 + i15^2*k31^2*k36^2 + 4*i15*i16*k31^2*k35*k36 - i15*i19*k31^2*k33*k36 - i15*i110*k31^2*k32*k36 - i15*i110*k31^2*k33*k35 - 2*i15*i114*k31^3*k36 + i15*i114*k31^2*k33^2 - 2*i115*i15*k31^3*k35 + 2*i115*i15*k31^2*k32*k33 + i16^2*k31^2*k35^2 + 2*k34*i16^2*k31^2*k36 - i16*i19*k31^2*k32*k36 - i16*i19*k31^2*k33*k35 - i16*i110*k31^2*k32*k35 - k34*i16*i110*k31^2*k33 - 2*i16*i114*k31^3*k35 + 2*i16*i114*k31^2*k32*k33 - 2*i113*i16*k31^3*k36 - 2*i115*k34*i16*k31^3 + i115*i16*k31^2*k32^2 + i113*i16*k31^2*k33^2 - i18*i16*k31^2*k33*k36 + 2*i14*i16*k31^2*k36^2 + i19^2*k31^3*k36 + 2*i19*i110*k31^3*k35 - i19*i114*k31^3*k33 - i115*i19*k31^3*k32 + k34*i110^2*k31^3 - i110*i114*k31^3*k32 - i113*i110*k31^3*k33 + 2*i18*i110*k31^3*k36 - i14*i110*k31^2*k33*k36 + i114^2*k31^4 + 2*i113*i115*k31^4 - i18*i115*k31^3*k33 - 2*i14*i115*k31^3*k36 + i14*i115*k31^2*k33^2;
c8 = 4*k35*i11^2*k36^3 - 3*k35*i11*i13*k33*k36^2 - k32*i11*i13*k36^3 - 6*k35*i11*i16*k31*k36^2 + 2*k35*i11*i16*k33^2*k36 + 2*k32*i11*i16*k33*k36^2 + 6*k35*i11*i110*k31*k33*k36 + 3*k32*i11*i110*k31*k36^2 - k35*i11*i110*k33^3 - 3*k32*i11*i110*k33^2*k36 + 2*i114*i11*k31^2*k36^2 + 4*i115*k35*i11*k31^2*k36 - 4*i114*i11*k31*k33^2*k36 - 4*i115*k35*i11*k31*k33^2 + 3*i19*i11*k31*k33*k36^2 - 8*i115*k32*i11*k31*k33*k36 - 2*i15*i11*k31*k36^3 + i114*i11*k33^4 - i19*i11*k33^3*k36 + 4*i115*k32*i11*k33^3 + i15*i11*k33^2*k36^2 - i12*i11*k33*k36^3 + 3*k35*i13^2*k31*k36^2 - 2*k35*i13*i16*k31*k33*k36 - k32*i13*i16*k31*k36^2 - 4*k35*i13*i110*k31^2*k36 + k35*i13*i110*k31*k33^2 + 2*k32*i13*i110*k31*k33*k36 + 3*i114*i13*k31^2*k33*k36 + 3*i115*k35*i13*k31^2*k33 - 2*i19*i13*k31^2*k36^2 + 3*i115*k32*i13*k31^2*k36 - i114*i13*k31*k33^3 + i19*i13*k31*k33^2*k36 - 3*i115*k32*i13*k31*k33^2 - i15*i13*k31*k33*k36^2 + 2*i12*i13*k31*k36^3 + 2*k35*i16^2*k31^2*k36 - k35*i16*i110*k31^2*k33 - k32*i16*i110*k31^2*k36 - 2*i114*i16*k31^3*k36 - 2*i115*k35*i16*k31^3 + i114*i16*k31^2*k33^2 - i19*i16*k31^2*k33*k36 + 2*i115*k32*i16*k31^2*k33 + 2*i15*i16*k31^2*k36^2 - i12*i16*k31*k33*k36^2 + k35*i110^2*k31^3 - i114*i110*k31^3*k33 + 2*i19*i110*k31^3*k36 - i115*k32*i110*k31^3 - i15*i110*k31^2*k33*k36 - 2*i12*i110*k31^2*k36^2 + i12*i110*k31*k33^2*k36 + 2*i114*i115*k31^4 - i19*i115*k31^3*k33 - 2*i15*i115*k31^3*k36 + i15*i115*k31^2*k33^2 + 3*i12*i115*k31^2*k33*k36 - i12*i115*k31*k33^3;
c9 = i11^2*k36^4 - i11*i13*k33*k36^3 - 2*i11*i16*k31*k36^3 + i11*i16*k33^2*k36^2 + 3*i11*i110*k31*k33*k36^2 - i11*i110*k33^3*k36 + 2*i11*i115*k31^2*k36^2 - 4*i11*i115*k31*k33^2*k36 + i11*i115*k33^4 + i13^2*k31*k36^3 - i13*i16*k31*k33*k36^2 - 2*i13*i110*k31^2*k36^2 + i13*i110*k31*k33^2*k36 + 3*i13*i115*k31^2*k33*k36 - i13*i115*k31*k33^3 + i16^2*k31^2*k36^2 - i16*i110*k31^2*k33*k36 - 2*i16*i115*k31^3*k36 + i16*i115*k31^2*k33^2 + i110^2*k31^3*k36 - i110*i115*k31^3*k33 + i115^2*k31^4;

sl3 = roots([c1 c2 c3 c4 c5 c6 c7 c8 c9]);
sl3 = sl3(sl3==real(sl3));

sdepth1 = zeros(size(sl3));
sdepth2 = zeros(size(sl3));
sdepth3 = sl3;

sR = [];
sT = [];

for iter = 1 : numel(sl3)
    
    % get depths
    l3 = sl3(iter);
    % several hypothesis for l1 an l2
    l2_  =  -(k33 + k32*l3 + (k32^2*l3^2 + 2*k32*k33*l3 + k33^2 - 4*k31*k34*l3^2 - 4*k31*k35*l3 - 4*k31*k36)^(1/2))/(2*k31);
    l2__ =  -(k33 + k32*l3 - (k32^2*l3^2 + 2*k32*k33*l3 + k33^2 - 4*k31*k34*l3^2 - 4*k31*k35*l3 - 4*k31*k36)^(1/2))/(2*k31);
    l1_  = -(k23 + k22*l3 + (k22^2*l3^2 + 2*k22*k23*l3 + k23^2 - 4*k21*k24*l3^2 - 4*k21*k25*l3 - 4*k21*k26)^(1/2))/(2*k21);
    l1__ = -(k23 + k22*l3 - (k22^2*l3^2 + 2*k22*k23*l3 + k23^2 - 4*k21*k24*l3^2 - 4*k21*k25*l3 - 4*k21*k26)^(1/2))/(2*k21);
    % get the right l1 and l2
    l1 = l1_; l2 = l2_;
    t1 = abs(k11*l1^2 + k12*l1*l2 + k13*l1 + k14*l2^2 + k15*l2 + k16);
    l1 = l1_; l2 = l2__;
    t2 = abs(k11*l1^2 + k12*l1*l2 + k13*l1 + k14*l2^2 + k15*l2 + k16);
    l1 = l1__; l2 = l2_;
    t3 = abs(k11*l1^2 + k12*l1*l2 + k13*l1 + k14*l2^2 + k15*l2 + k16);
    l1 = l1__; l2 = l2__;
    t4 = abs(k11*l1^2 + k12*l1*l2 + k13*l1 + k14*l2^2 + k15*l2 + k16);
    [~,I] = min([t1,t2,t3,t4]);
    if I == 1; l1 = l1_; l2 = l2_;
    elseif I == 2; l1 = l1_; l2 = l2__;
    elseif I == 3; l1 = l1__; l2 = l2_;
    else l1 = l1__; l2 = l2__;
    end
    % save depths
    sdepth1(iter) = l1;
    sdepth2(iter) = l2;
    
    
    % compute rotation and translation parameters that align Pi with cPi
    Q1 = l1*D1;
    Q2 = l2*D2 + C2;
    Q3 = l3*D3 + C3;
    
    q11 = Q1(1); q12 = Q1(2); q13 = Q1(3);
    q21 = Q2(1); q22 = Q2(2); q23 = Q2(3);
    q31 = Q3(1); q32 = Q3(2); q33 = Q3(3);
    
    p11 = P1(1); p12 = P1(2); p13 = P1(3);
    p21 = P2(1); p22 = P2(2); p23 = P2(3);
    p31 = P3(1); p32 = P3(2); p33 = P3(3);

   RM = [ -(p11 - p21)/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2),  (p12 - p22)/((1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2)), -((p11 - p21)*(p13 - p23))/((1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2));
          -(p12 - p22)/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2), -(p11 - p21)/((1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2)), -((p12 - p22)*(p13 - p23))/((1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2));
          -(p13 - p23)/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2),                                                                                                                                              0,                                                                              (1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)];
 
   RN = [ -(q11 - q21)/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2),  (q12 - q22)/((1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2)), -((q11 - q21)*(q13 - q23))/((1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2));
          -(q12 - q22)/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2), -(q11 - q21)/((1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2)), -((q12 - q22)*(q13 - q23))/((1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2));
          -(q13 - q23)/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2),                                                                                                                                              0,                                                                              (1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2) ];
 
   u1 = ((p11 - p21)*(p11 - p31))/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2) + ((p12 - p22)*(p12 - p32))/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2) + ((p13 - p23)*(p13 - p33))/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2); 
   u2 = ((p11 - p21)*(p12 - p32))/((1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2)) - ((p12 - p22)*(p11 - p31))/((1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)^(1/2));
   u3 = ((p11 - p21)*(p13 - p23)*(p11 - p31))/((1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2)) - (1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*(p13 - p33) + ((p12 - p22)*(p13 - p23)*(p12 - p32))/((1 - (p13 - p23)^2/((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2))^(1/2)*((p11 - p21)^2 + (p12 - p22)^2 + (p13 - p23)^2));
   v1 = ((q11 - q21)*(q11 - q31))/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2) + ((q12 - q22)*(q12 - q32))/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2) + ((q13 - q23)*(q13 - q33))/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2);
   v2 = ((q11 - q21)*(q12 - q32))/((1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2)) - ((q12 - q22)*(q11 - q31))/((1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)^(1/2));
   v3 = ((q11 - q21)*(q13 - q23)*(q11 - q31))/((1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2)) - (1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*(q13 - q33) + ((q12 - q22)*(q13 - q23)*(q12 - q32))/((1 - (q13 - q23)^2/((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2))^(1/2)*((q11 - q21)^2 + (q12 - q22)^2 + (q13 - q23)^2));
 
   
   a = (u2*v2 + u3*v3)/(v2^2 + v3^2);
   b = -(u2*v3 - u3*v2)/(v2^2 + v3^2);

   if a >= 0; a = min([1,a]);
   else a = max([-1,a]);
   end
   
   if b >= 0; b = norm(sin(acos(a)));
   else  b = -norm(sin(acos(a)));
   end
   
    RV = [1, 0,  0; ...
          0, a, -b; ...
          0, b,  a];
    
     
    Rest = RM*RV*RN';
    test = -Rest*Q1+P1;
    
    sR = [sR, Rest];
    sT = [sT, test];
    
            
      
end



end