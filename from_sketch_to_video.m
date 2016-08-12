clear;clc;

sketchfile = fopen('../deney13/sketch_stream_1470681274856.sketch');

numoflines = 0;
line = fgetl(sketchfile);
while ischar(line)
    numoflines = numoflines + 1;
    line = fgetl(sketchfile);
end

fclose(sketchfile);

sketchfile = fopen('../deney13/sketch_stream_1470681274856.sketch');
%edit zaar.sketchelleam
%output = fopen('zaar.sketchelleam');
vw = VideoWriter('sketchvideo.avi');
open(vw);

arr = [];
frameRate = 60;
spf = 1 / frameRate;
disp(['Nspf = ' num2str(spf*1000000)]);

line = fgetl(sketchfile);
delims = strsplit(line,',');
initTime = str2num(delims{end});
figure;
axis([0 1100 0 600]);
disp(line);
writeVideo(vw,getframe(gca));
writeVideo.FrameRate = frameRate;
frameCount = 1;
firstTime = 1;
while ischar(line)
    delims = strsplit(line,',');
    
    if ~firstTime
        time = str2num(delims{end});
        
        if time - initTime >= spf * 1000000 * frameCount
            type = delims{2};
            
            if strcmp(delims{2},'STRSTART')
            elseif strcmp(delims{2},'STREND')
            elseif strcmp(delims{2},'CLEAR')
                disp(line);
                clf;
            elseif strcmp(delims{2},'VIDEOOPEN')
            else
                disp(line);
                hold on;
                plot(str2double(delims{2}),str2double(delims{3}),'xk');
            end
            
            while time - initTime >= spf * 1000000 * frameCount
                writeVideo(vw,getframe(gca));
                frameCount = frameCount + 1;
            end
        end
    end
    
    line = fgetl(sketchfile);
    firstTime = 0;
end

close;
close(vw);
fclose(sketchfile);
fclose(output);