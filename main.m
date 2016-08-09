clear;clc;

firstSegment1 = 4.5;
firstSegment2 = 3.5;

[y1,fs1] = audioread('../deney13/userstudy_1470681274856.mp4');
[y2,fs2] = audioread('../deney13/userstudy_1470681283338.mp4');

y1mono = (y1(:,1)+y1(:,2)) / 2;
y2mono = (y2(:,1)+y2(:,2)) / 2;

y1first = y1mono(1:(firstSegment1*fs1));
y2first = y2mono(1:(firstSegment2*fs2));

[r,lag] = xcorr(y1first,y2first);
[maxlag,maxloc] = max(r);

delay = lag(maxloc);

if size(y1,1)>size(y2,1)+delay
    y1aligned = y1mono;
    y2aligned = [zeros(delay,1);y2mono;zeros(size(y1,1)-delay-size(y2,1),1)];
else
    y2aligned = [zeros(delay,1);y2mono];
    y1aligned = [y1mono;zeros(delay+size(y2,1)-size(y1,1),1)];
end

sound(y1aligned+y2aligned,fs1);