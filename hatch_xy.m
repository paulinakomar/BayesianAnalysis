function [xi,yi,x,y]=hatch_xy(x,y,varargin);
%
% M_HATCH Draws hatched or speckled interiors to a patch
%       
%    M_HATCH(LON,LAT,STYL,ANGLE,STEP,...line parameters);
%
% INPUTS:
%     X,Y - vectors of points.
%     STYL - style of fill
%     ANGLE,STEP - parameters for style
%
%     E.g.
%                 
%      'single',45,5  - single cross-hatch, 45 degrees,  5 points apart 
%      'cross',40,6   - double cross-hatch at 40 and 90+40, 6 points apart
%      'speckle',7,1  - speckled (inside) boundary of width 7 points, density 1
%                               (density >0, .1 dense 1 OK, 5 sparse)
%      'outspeckle',7,1 - speckled (outside) boundary of width 7 points, density 1
%                               (density >0, .1 dense 1 OK, 5 sparse)
%
%     
%      H=M_HATCH(...) returns handles to hatches/speckles.
%
%      [XI,YI,X,Y]=MHATCH(...) does not draw lines - instead it returns
%      vectors XI,YI of the hatch/speckle info, and X,Y of the original
%      outline modified so the first point==last point (if necessary).
%
%     Note that inside and outside speckling are done quite differently
%     and 'outside' speckling on large coastlines can be very slow.

%
% Hatch Algorithm originally by K. Pankratov, with a bit stolen from 
% Iram Weinsteins 'fancification'. Speckle modifications by R. Pawlowicz.
%
% R Pawlowicz 15/Dec/2005
  
styl='speckle';
angle=7;
step=1/2;

if length(varargin)>0 & isstr(varargin{1}),
  styl=varargin{1};
  varargin(1)=[];  
end;
if length(varargin)>0 & ~isstr(varargin{1}),
  angle=varargin{1};
  varargin(1)=[];  
end;
if length(varargin)>0 & ~isstr(varargin{1}),
  step=varargin{1};
  varargin(1)=[];
end;

I = zeros(1,length(x));
%[x,y,I]=m_ll2xy(lon,lat,'clip','patch');
 
  
if x(end)~=x(1) & y(end)~=y(1),
  x=x([1:end 1]);
  y=y([1:end 1]);
  I=I([1:end 1]);
end;

if strcmp(styl,'speckle') | strcmp(styl,'outspeckle'),
  angle=angle*(1-I);
end;

if size(x,1)~=1,
 x=x(:)';
 angle=angle(:)';
end;
if size(y,1)~=1,
 y=y(:)';
end;


% Code stolen from Weinstein hatch
oldu = get(gca,'units');
set(gca,'units','points');
sza = get(gca,'pos'); sza = sza(3:4);
set(gca,'units',oldu)   % Set axes units back

xlim = get(gca,'xlim');
ylim = get(gca,'ylim');
xsc = sza(1)/(xlim(2)-xlim(1)+eps);
ysc = sza(2)/(ylim(2)-ylim(1)+eps);

switch lower(styl),
 case 'single',
  [xi,yi]=drawhatch(x,y,angle,step,xsc,ysc,0);
  if nargout<2,
    xi=line(xi,yi,varargin{:});
  end;  
 case 'cross',
  [xi,yi]=drawhatch(x,y,angle,step,xsc,ysc,0);
  [xi2,yi2]=drawhatch(x,y,angle+90,step,xsc,ysc,0);
  xi=[xi,xi2];
  yi=[yi,yi2];
  if nargout<2,
    xi=line(xi,yi,varargin{:});
  end;  
 case 'speckle',
  [xi,yi ]  =drawhatch(x,y,45,   step,xsc,ysc,angle);
  [xi2,yi2 ]=drawhatch(x,y,45+90,step,xsc,ysc,angle);
  xi=[xi,xi2];
  yi=[yi,yi2];
  if nargout<2,
    if any(xi),
      xi=line(xi,yi,'marker','.','linest','none','markersize',2,varargin{:});
    else
      xi=NaN;
    end;    
  end; 
 case 'outspeckle',
  [xi,yi ]  =drawhatch(x,y,45,   step,xsc,ysc,-angle);
  [xi2,yi2 ]=drawhatch(x,y,45+90,step,xsc,ysc,-angle);
  xi=[xi,xi2];
  yi=[yi,yi2];
  inside=logical(inpolygon(xi,yi,x,y)); % logical needed for v6!
  xi(inside)=[];yi(inside)=[];
  if nargout<2,
    if any(xi),
      xi=line(xi,yi,'marker','.','linest','none','markersize',2,varargin{:});
    else
      xi=NaN;
    end;    
  end; 
    
end;
