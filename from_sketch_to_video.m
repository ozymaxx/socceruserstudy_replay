clear;clc;close all;

filename = '../deney13/sketch_stream_1470681274856.sketch';

dimx = 1140;
dimy = 650;

sketchfile = fopen(filename);

numoflines = 0;
line = fgetl(sketchfile);
while ischar(line)
    numoflines = numoflines + 1;
    line = fgetl(sketchfile);
end

fclose(sketchfile);

sketchfile = fopen(filename);
%edit zaar.sketchelleam
%output = fopen('zaar.sketchelleam');
vw = VideoWriter('sketchvideo.avi');
open(vw);
frameRate = 30;
spf = 1 / frameRate;
disp(['Nspf = ' num2str(spf*1000000000)]);

soccerfield = imread('soccerfield.png');
line = fgetl(sketchfile);
delims = strsplit(line,',');
initTime = str2num(delims{end});
figure;
imshow(soccerfield);
strokes = cell(2,1);
width = cell(2,1);
%axis([0 dimx 0 dimy]);
disp(line);
writeVideo(vw,getframe(gca));
%writeVideo.FrameRate = frameRate;
frameCount = 1;
firstTime = 1;
while ischar(line)
    delims = strsplit(line,',');
    
    if ~firstTime
        time = str2num(delims{end});
        
        if time - initTime >= spf * 1000000 * frameCount
            type = delims{2};
            
            disp(line);
            
            while time - initTime >= spf * 1000000000 * frameCount
                writeVideo(vw,getframe(gca));
                frameCount = frameCount + 1;
            end
            
            if strcmp(delims{2},'STRSTART')
                strokes{str2num(delims{1})+1} = animatedline;
                set(strokes{str2num(delims{1})+1},'Color',[str2num(delims{4})/255 str2num(delims{5})/255 str2num(delims{6})/255 str2num(delims{7})/255]);
                set(strokes{str2num(delims{1})+1},'LineWidth',str2double(delims{3}));
            elseif strcmp(delims{2},'STREND')
            elseif strcmp(delims{2},'CLEAR')
                imshow(soccerfield);
            elseif strcmp(delims{2},'VIDEOOPEN')
            else
                addpoints(strokes{str2num(delims{1})+1},str2double(delims{2}),str2double(delims{3}));
            end
        end
    end
    
    line = fgetl(sketchfile);
    firstTime = 0;
end

close;
close(vw);
fclose(sketchfile);
%fclose(output);