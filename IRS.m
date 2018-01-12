function varargout = IRS(varargin)
% IRS MATLAB code for IRS.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
set(0, 'DefaulttextInterpreter', 'none');
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IRS_OpeningFcn, ...
                   'gui_OutputFcn',  @IRS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before IRS is made visible.
function IRS_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for IRS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

plots = [handles.axes2 handles.axes3 handles.axes4 handles.axes5 handles.axes6 handles.axes7];
for i=1:6
   axes(plots(i));
   pbaspect([1 1 1])
end
%makes aspect ratio 1:1 for all output plots
auto_flag = 0;
auto_filename = ('blank');
setappdata(0,'auto_flag',auto_flag);
setappdata(0,'auto_filename',auto_filename);
%sets system flag for auto mode to zero

% --- Outputs from this function are returned to the command line.
function varargout = IRS_OutputFcn(~, ~, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, ~)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%--------------------------------------------------------------------------
%END OF GUIDE GENERATED GENERIC CODE
%--------------------------------------------------------------------------

%sets plot attributes and is called whenever data is plotted
function plot_axes(xlab, ylab, title_string, x, y, plot_type, dy, dx, sa, microns)
    x(x==0) = -1;
    y(y==0) = 1;
    if length(y) == 1
        y(isnan(y)) = 0.00001;
    end
    ylim ([(nanmin(y(:))-0.01*nanmin(y(:))) (nanmax(y(:))+0.01*nanmax(y(:)))])
    xlim ([(nanmin(x(:))-0.01*nanmin(x(:))) abs((nanmax(x(:))+0.01*nanmax(x(:))))])
    xlabel(xlab, 'FontSize', 16);
    ylabel(ylab, 'FontSize', 16);
    title(title_string, 'FontSize', 18);
    
    if plot_type == 1
       originalSize = get(gca, 'Position');
       colormap jet;
       colorbar('location','NorthOutside');
       set(gca, 'Position', originalSize);
       hold on
       contour(microns,microns,sa,10,'k');
       plot(microns(dy),microns(dx),'ws','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','w','MarkerFaceColor','w')
       hold off
    end
    drawnow;

%updates colors and strings
function control_colors(flag,handles)

h = [handles.pushbutton1 handles.pushbutton2 handles.pushbutton3 handles.edit2 handles.edit3 handles.text5];
%creates object array

for i = 1:5
    if flag{i} == 0
        set(h(i),'Backgroundcolor',[1.0 0.6 0.784]);
    else
        set(h(i),'Backgroundcolor',[0 .8 0]);
    end
end

if (flag{1} == 1) && (flag{2} == 1) && (flag{4} == 1) && (flag{5} == 1)
    set(h(3),'Backgroundcolor',[0 .8 0]);
end
%if all are green, make run green too

for i = 6:8
    set(h(i-2),'string',flag{i});
end

setappdata(0,'flag',flag);

% --- Executes on button press in checkbox1.
function checkbox1_Callback(~, ~, ~)

% --- Executes on button press in checkbox2.
function checkbox2_Callback(~, ~, handles)

if get(handles.checkbox2,'Value') == 1
    set(handles.pushbutton2,'BackgroundColor',[0 .8 0])
    set(handles.pushbutton2,'Enable','off');
else
    set(handles.pushbutton2,'BackgroundColor',[1.0 0.6 0.784])
    set(handles.pushbutton2,'Enable','on');
end

% --- Executes on slider movement.
function slider1_Callback(~, ~, handles)

Icut = get(handles.slider1,'value');
Icut_100 = num2str(round(Icut*100));
set(handles.text12,'String',strcat(Icut_100,' %'));

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(~, ~, ~)

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(~, ~, handles)

arrayfun(@cla,findall(0,'type','axes'))
fclose('all');
%clear axes

hfindROI = findobj(gca,'Type','hggroup');    
delete(hfindROI)
%deletes ROI if one already exists

[flag(1:5), flag(6:9)] = deal({0},{' '});
control_colors(flag, handles);
%initialises flag array and re-initialises colours and strings

[upath]=uigetdir('/Users/oliverlord/Dropbox/Work/EXPERIMENTS/');
dir_content = dir(strcat(upath,'/*.tiff'));
total=size(dir_content,1);

%determines number of .TIFF files in directory

good_data = zeros(1,total);
%pre-allocates good_data array with zeros

filenames = {dir_content.name};
%lists filenames of .TIFF files in directory

saturate = get(handles.checkbox1,'value');
%determines whether user wants to fit saturated images

counter_1 = 1;

for i=1:total
    
    raw=imread(char(strcat(upath,'/',(filenames(i)))));
    %reads unknown file  

    noise = mean(mean([raw(1:10,1:10) raw(1:10,755:765) raw(501:510,1:10) raw(501:510,755:765)]));
    %determines background intensity
    
    raw = raw-noise;
    %subtracts background
    
    [d,a,c,b] = deal(raw(1:255,1:382),raw(1:255,384:765),raw(256:510,1:382),raw(256:510,384:765));                     
    %quarters image: d=tl 670nm, a=tr 750nm, c=bl 850nm, b=br 580nm

    if saturate == 1 
        if min(max([d(:) a(:) c(:) b(:)])) > noise*2;
            good_data(i) = i;
            axes(handles.axes1);
            imagesc(raw)
            plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},(num2str(i))),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
            flag(1) = {1};
            counter_1 = counter_1+1;
        end
    else
        if min(max([d(:) a(:) c(:) b(:)])) > noise*2 && max(max([d(:) a(:) c(:) b(:)])) <64000;
            good_data(i) = i;
            axes(handles.axes1);
            imagesc(raw)
            plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},(num2str(i))),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
            flag(1) = {1};
            counter_1 = counter_1+1;
        end
    end
    %adds file numbers into their equivalent indices good_data array if
    %s:n>2 (for fitting saturated images) and if max < 64000 (if not)
end

[flag(1),flag(8),flag(9)] = deal({1},{total},{upath});
control_colors(flag, handles)
%updates colors and strings

setappdata(0,'good_data',good_data);
setappdata(0,'dir_content',dir_content);
setappdata(0,'upath',upath);
%makes variables global

function edit2_Callback(~, ~, handles)

fi = eval(get(handles.edit2,'string'));
%gets user entered value of fi

if fi < find(getappdata(0,'good_data'),1)
    fi = find(getappdata(0,'good_data'),1);
    set(handles.edit2,'string',fi);
end
%converts fi to fIRSt good file if user selects earlier file

flag = getappdata(0,'flag');
[flag(4),flag(6)] = deal({1},{fi});
control_colors(flag, handles)
%updates colors and strings

function edit3_Callback(~, ~, handles)

fl = eval(get(handles.edit3,'string'));
set(handles.edit3,'Backgroundcolor',[0 .8 0]);
%gets user entered value of fl

if fl > find(getappdata(0,'good_data'),1,'last')
    fl = find(getappdata(0,'good_data'),1,'last');
    set(handles.edit3,'string',fl);
elseif fl < eval(get(handles.edit2,'string'))
    fl = eval(get(handles.edit2,'string'));    
end
%converts fl to last good file if user selects later file of to fi if user
%user selects fl < fi

flag = getappdata(0,'flag');
[flag(5),flag(7)] = deal({1},{fl});
control_colors(flag, handles)
%updates colors and strings

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, handles)

hfindROI = findobj(gca,'Type','hggroup');    
delete(hfindROI)
%deletes ROI if one already exists

flag = getappdata(0,'flag');
flag(2:3) = {0};
control_colors(flag, handles)
%updates colors and strings

ROI = imrect(handles.axes1, [91 28 200 200]);
fcn = makeConstrainToRectFcn('imrect',[20 362],[20 235]);
setPositionConstraintFcn(ROI,fcn);
setFixedAspectRatioMode(ROI,'True');
subframe = wait(ROI);
%creates ROI square and returns opsition and size

setappdata(0,'subframe',subframe);
%save ROI position data

flag(2) = {1};
control_colors(flag, handles)
%updates colors and strings

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(~, ~, handles)

tic

auto_flag = getappdata(0,'auto_flag');
dir_content = getappdata(0,'dir_content');

if auto_flag <= 1

    clear T_hist E_hist acq timestamp elapsedSec timeSec difT_metric

end
    
persistent kiac kibc kicc kidc nw savename videofile writerObj T_hist E_hist acq timestamp elapsedSec timeSec difT_metric

if auto_flag == 0
    
    subframe = getappdata(0,'subframe');
    w = round(subframe(3)/2);
    x = round(subframe(1))+w;
    y = round(subframe(2))+w;
    %calculate center and half-width of subframe
    
    fi = eval(get(handles.edit2,'string'));
    fl = eval(get(handles.edit3,'string'));
    %get first and last files to be analysed

    good_data = getappdata(0,'good_data');
    upath = getappdata(0,'upath');
    %gets list of unknown files files and file path
    
    a = 10
    arrayfun(@cla,findall(0,'type','axes'))
    fclose('all');
    %clear axes
    
end

if auto_flag > 0
    [fi,fl,good_data] = deal(1);
    dir_content(1) = dir_content(length(dir_content));
    prefix = strsplit(dir_content(1).name,'-');
    upath = getappdata(0,'upath');
    
    fullframe = imread(strcat(upath,'/',dir_content(1).name));
    a = fullframe(1:255,1:382);
    [~, idx] = max(a(:));
    [y, x] = ind2sub(size(a),idx);
    w = 100;
    counter_1 = auto_flag;
else
    prefix = strsplit(dir_content(1).name,'-');
    counter_1 = 1;
end
%removes extension from filename

if auto_flag < 2
    
    savename=strcat(prefix{1},'IRiS_',date);
    mkdir(upath,savename);
    %creates directory for output
    
    fullframe = imread('tc.tiff');
    %opens and reads .TIFF
    
    [kiac,kibc,kicc,kidc]= correlate(fullframe,x, y, w, 0, 1);
    %determines offsets based on thermal calibration file 
    
    nw = horzcat(ones(324,1),[repmat((14384000/752.97),81,1); repmat((14384000/578.61),81,1); repmat((14384000/851.32),81,1); repmat((14384000/670.08),81,1)]);
    %determines normalised wavelengths for the four filters

    videofile=strcat(upath,'/',savename,'/',savename,'.avi');
    
    writerObj = VideoWriter(videofile);
    writerObj.FrameRate = 2;
    open(writerObj);
    setappdata(0,'writerObj',writerObj);
    %sets up video recording
    
    window = get(gcf,'position');
    setappdata(0,'window',window);
end;

for i=good_data(good_data>=fi & good_data<=fl)
    filename=dir_content(i).name;
    filepath=char(strcat(upath,'/',(filename)));
    %reads unknown file
   
    fullframe = imread(filepath);
    %opens and reads .TIFF
    
    axes(handles.axes1);
    imagesc(fullframe);
    hold on
    hRectangle = rectangle('position',[x-w y-w w*2 w*2],'EdgeColor','w','LineWidth',2);
    hold off
    plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},filename(end-7:end-5)),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
    %plots fullframe   
    
    [a, b, c, d]= correlate(fullframe, x, y, w, auto_flag, counter_1);
    %determines offsets based on first unknown file
    
    [Tmax,Emax,T,error,emissivity,umax,slope_max,intercept_max,dx,dy,sa]=mapper(kiac,kibc,kicc,kidc,nw,d,a,c,b,handles);
    %calls mapper function to calculate temperature map
  
    [difT, difT_metric(counter_1)] = difference(T, sa, counter_1, w);
    %determines difference map and difference metric
    
    T_hist(counter_1)=Tmax;
    E_hist(counter_1)=Emax;
    
    acq(counter_1) = str2double(filename(end-7:end-5));
    %store max T and associated error
           
    timestamp(counter_1) = datenum(dir_content(i).date);
    %get timestamp
     
    timevector = datevec(timestamp(counter_1));
    %vectorise timestamp
     
    timeSec(counter_1) = (timevector(1,6) + (timevector(1,5)*60) + (timevector(1,4)*60*60));
    %convert timevector to seconds
    
    elapsedSec(counter_1) = round(timeSec(counter_1)-timeSec(1));
    %determine seconds elapsed since start of experiment
    
    autoresult = [acq',timestamp',elapsedSec',T_hist',E_hist',difT_metric'];
    assignin('base', 'autoresult', autoresult);
    %create output array and assign to workspace
            
    [x1,y1] = meshgrid(1:length(T),1:length(T));
    %lists pixel x and y coordinates

    xyz = [x1(:) y1(:) T(:) error(:) emissivity(:) difT(:)];
    %generates data table containing all three maps for each data point

    map=char(strcat(upath,'/',savename,'/',filename(1:end-5),'_map.txt'));
    save(map,'xyz','-ASCII');
    %creates unique file name for map data and saves it
    
    progress = round(counter_1/length(good_data(good_data>=fi & good_data<=fl))*100);
    %calculates job progress
    
    if get(handles.pushbutton4,'Value') == 1
        progress = 100;
    end;
    
    microns=linspace(-(w*.18),w*.18,(w*2));
    %pixel to micron conversion
    
    plot_type = 0;
    %sets plot type to 'graph' so plot_axes function performs correctly
    
    %TOP LEFT PLOT: normalised intensity vs normalised wavelength of hottest pixel
    axes(handles.axes2)
    plot(nw(:,2),umax,'O');
    plot_axes('Normalised wavelength', 'Normalised intensity', strcat({'Peak temperature: '},(num2str(round(Tmax))),' +/- ',(num2str(round(Emax)))), nw(:,2), umax, plot_type, dy, dx, sa, microns);
    hold on
    xline=linspace(min(nw(:,2)),max(nw(:,2)),100);
    yline=intercept_max+(slope_max*xline);
    plot(xline,yline,'-r')
    hold off
    %overlays the best fit line onto the wien plot
    
    %TOP MIDDLE PLOT: Peak Temperature History
    axes(handles.axes3)
    plot(elapsedSec,T_hist,'--rs','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
    plot_axes('Elapsed Time (s)', 'Temperature (K)', strcat(num2str(timevector(1,4)),':',num2str(timevector(1,5)),':',num2str(timevector(1,6)),{'  '},num2str(progress),'%'),elapsedSec,T_hist, plot_type, dy, dx, sa, microns);
    
    if get(handles.radiobutton3,'Value') == 1
        %TOP RIGHT PLOT: Difference Metric History
        axes(handles.axes4)
        plot(elapsedSec,difT_metric,'--rs','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
        plot_axes('Elapsed Time (s)', 'Image difference metric', 'Image difference metric',elapsedSec,difT_metric, plot_type, dy, dx, sa, microns);
    else
        %TOP RIGHT PLOT: cross-sections
        axes(handles.axes4)
        plot(microns,T(dx,(1:length(T))),'r');
        hold on
        plot(microns,T(1:length(T),dy),'g');
        hold off
        plot_axes('Distance (microns)', 'Temperature (K)', 'Temperature Cross-sections',microns,T(T>0), plot_type, dy, dx, sa, microns);
        legend('horizontal','vertical');
    end
    
    plot_type = 1;
    %sets plot type to 'map' so plot_axes function performs correctly
    
    %BOTTOM LEFT PLOT: difference map
    axes(handles.axes5)
    [Clim_min(counter_1), Clim_max(counter_1)] = deal(min(difT(:)), max(difT(:)));
    [Clim_min(isnan(Clim_min)), Clim_max(isnan(Clim_max))] = deal(0,0.001);
    plot(.18*y-(microns/2)-.18,.18*x-(microns/2)-.18,'ws','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','w','MarkerFaceColor','w') 
    imagesc(microns,microns,difT,[min(Clim_min) max(Clim_max)]);
    plot_axes('Distance (microns)', 'Distance (microns)', 'DIFFERENCE MAP',microns, microns, plot_type, dy, dx, sa, microns);

    %BOTTOM MIDDLE PLOT: error map
    axes(handles.axes6)
    imagesc(microns,microns,error,[(min(error(:))) (max(error(:)))]);    
    plot_axes('Distance (microns)', 'Distance (microns)', 'ERROR MAP',microns, microns, plot_type, dy, dx, sa, microns);

    %BOTTOM RIGHT PLOT: temperature map
    axes(handles.axes7)
    imagesc(microns,microns,T,[(min(min(T(T>0)))) max(T(:))]);
    plot_axes('Distance (microns)', 'Distance (microns)', 'TEMPERATURE MAP',microns, microns, plot_type, dy, dx, sa, microns);
    
    window = getappdata(0,'window');
    set(gcf,'position',window);
    frame=getframe(gcf);
    writeVideo(writerObj,frame);
    %writes frame to .avi
           
    counter_1 = counter_1 + 1;
end

result=strcat(upath,'/',savename,'/',savename,'.txt');
result=char(result);
save (result,'autoresult','-ASCII','-double');
%saves summary data to text file

if get(handles.pushbutton4,'Value') == 0
    close(writerObj);
end
%closes video file unless in automode

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(~, ~, handles)

auto_flag = getappdata(0,'auto_flag');

hfindROI = findobj(gca,'Type','hggroup');    
delete(hfindROI)
%deletes ROI if one already exists

arrayfun(@cla,findall(0,'type','axes'))
fclose('all');
%clear axes

[flag(1:5), flag(6:9)] = deal({0},{' '});
control_colors(flag, handles);
%initialises flag array and re-initialises colours and strings

if get(handles.pushbutton4,'Value') == 0
    set(handles.pushbutton4,'BackgroundColor',[1.0 0.6 0.784]);
    set(handles.pushbutton4,'String','auto off');
    %sets auto mode button to off state
    
    set(handles.pushbutton1,'Enable','on');
    set(handles.pushbutton2,'Enable','on');
    set(handles.pushbutton3,'Enable','on');
    %unlocks other buttons on exit of auto mode
    
    auto_flag = 0;
    setappdata(0,'auto_flag',auto_flag);
    %resets auto flag to 0 off state
    
    writerObj = getappdata(0,'writerObj');
    close(writerObj);
else
    set(handles.pushbutton4,'BackgroundColor',[0 0.8 0]);
    set(handles.pushbutton4,'String','auto on')
    %sets auto mode button to on state
    
    set(handles.slider1,'Value',0.25);
    set(handles.text12,'String','25 %');
    %force intensity cutoff to be 25%
    
    set(handles.pushbutton1,'Enable','off');
    set(handles.pushbutton2,'Enable','off');
    set(handles.pushbutton3,'Enable','off');
    %locks other buttons during auto mode
    
    upath = uigetdir('/Users/oliverlord/Dropbox/Work/EXPERIMENTS/');
    dir_content = dir(strcat(upath,'/*.tiff'));
    initial_list = {dir_content.name};
    setappdata(0,'upath',upath);
    %collect list of current .TIFF files
    
    while get(handles.pushbutton4,'Value') == 1
    
        pause(1);
        dir_content = dir(strcat(upath,'/*.tiff'));
        new_list = {dir_content.name};
        %collects new list of filenames
    
        new_filename = setdiff(new_list,initial_list);
        %determines list of new files
    
        if ~isempty(new_filename)
            
            auto_flag = auto_flag + 1;
            setappdata(0,'auto_flag',auto_flag);
            setappdata(0,'auto_filename',new_filename);
            setappdata(0,'dir_content',dir_content);
            %increments auto_flag each time a new file is processed
            
            pushbutton3_Callback(0, 0, handles)
            %calls main processing subroutine
            
            initial_list = new_list;
        end
    end
end