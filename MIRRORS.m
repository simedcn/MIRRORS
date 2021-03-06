function varargout = MIRRORS(varargin)
%--------------------------------------------------------------------------
% MIRRORS (MultIspectRal imaging RadiOmetRy Software)
%--------------------------------------------------------------------------
% Version 1.7.6
% Written and tested on Matlab R2014a (Windows 7) & R2017a (OS X 10.13)

% Copyright 2018 Oliver Lord, Weiwei Wang
% email: oliver.lord@bristol.ac.uk
 
% This file is part of MIRRORS.
 
% MIRRORS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
 
% MIRRORS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
 
% You should have received a copy of the GNU General Public License
% along with MIRRORS.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
%MIRRORS M-file for MIRRORS.fig
%      MIRRORS, by itself, creates a new MIRRORS or raises the existing
%      singleton*.
%
%      H = MIRRORS returns the handle to a new MIRRORS or the handle to
%      the existing singleton*.
%
%      MIRRORS('Property','Value',...) creates a new MIRRORS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to MIRRORS_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MIRRORS('CALLBACK') and MIRRORS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MIRRORS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%      hObject    handle to checkbox1 (see GCBO)
%      eventdata  reserved - to be defined in a future version of MATLAB
%      handles    structure with handles and user data (see GUIDATA)

%      handles    structure with handles and user data (see GUIDATA)
%      varargin   unrecognized PropertyName/PropertyValue pairs from the
%           command line (see VARARGIN)
%      varargout  cell array for returning output args (see VARARGOUT);

%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MIRRORS

% Last Modified by GUIDE v2.5 24-Oct-2018 18:15:22


%--------------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MIRRORS_OpeningFcn, ...
                   'gui_OutputFcn',  @MIRRORS_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
% --- Executes just before MIRRORS is made visible.
function MIRRORS_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for MIRRORS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Creates array of handles to axes within the GUI
plots = [handles.axes2 handles.axes3 handles.axes4 handles.axes5...
    handles.axes6 handles.axes7];

% VERSION NUMBER
set(handles.text17,'String','1.7.6');

% Write current calibration file to GUI window
load('calibration.mat');
set(handles.text20,'String',name);

% Sets aspect ratio for all axes within the GUI to 1:1
for i=1:6
   axes(plots(i)); %#ok<LAXES>
   pbaspect([1 1 1])
end

% Initialises auto mode system flag and intitial filname
setappdata(0,'auto_flag',0);
auto_filename = ('blank');

% Makes auto mode system flag and intitial filname available to all
% functions within the GUI
setappdata(0,'auto_flag',0);
setappdata(0,'auto_filename',auto_filename);

% Forces GUI to screen centre at start-up 
movegui(gcf,'center');

% Initialise button colors and enabled state
control_colors({0 0 0 0 0 0 1 1 0 0 0 0},handles);

% Suppress non integer index and complex number warnings
warning('off','MATLAB:colon:nonIntegerIndex');
warning('off','MATLAB:plot:IgnoreImaginaryXYPart');

% Make Update Test Data button invisible
set(handles.pushbutton9,'visible','off')


%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = MIRRORS_OutputFcn(~, ~, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
% UNUSED CALLBACK FUNCTIONS

% --- Executes on button press in checkbox2.
function checkbox2_Callback(~, ~, handles) %#ok<DEFNU,INUSD>

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(~, ~, handles) %#ok<DEFNU,INUSD>

%--------------------------------------------------------------------------
% --- Executes when user presses LIVE button
function pushbutton1_Callback(~, ~, handles) %#ok<DEFNU>

if getappdata(0,'auto_flag') == 1
    
    % Update button states
    control_colors({0 0 0 0 0 0 1 1 0 0 0 0}, handles)
    
    % Reset auto_flag to 0
    setappdata(0,'auto_flag','0');
    
else
    
    % Reset auto_flag to 1
    setappdata(0,'auto_flag',1);
    
    % Clear all axes within GUI
    arrayfun(@cla,findall(0,'type','axes'))
    fclose('all');
    
    % Reset textboxes to 0
    set(handles.edit1,'String','0')
    set(handles.edit2,'String','0')
    
    % Switch on Save Output and disable
    set(handles.checkbox2,'Value',1,'Enable','off');
    
    % Update button states
    control_colors({1 0 0 0 0 0 1 1 0 0 0 0}, handles)
    
    % Deletes ROI if one already exists
    hfindROI = findobj(handles.axes1,'Type','hggroup');
    delete(hfindROI)
    
    % Default intensity cutoff to 25% and disable
    set(handles.slider1,'Value',0.25);
    set(handles.text12,'String','25 %');
    set(handles.slider1,'Enable','off');
    
    % Ask user to point to folder containing .TIF files to be processed
    upath = uigetdir('/Users/oliverlord/Dropbox/Work/EXPERIMENTS/');
    setappdata(0,'upath',upath);
 
    % Collect list of current .TIFF files
    dir_content = dir(strcat(upath,'/*.tiff'));
    initial_list = {dir_content.name};
    
    % Initialise counter c1
    c1 = 1;

    while getappdata(0,'auto_flag') == 1
        
        % Collects new list of filenames
        pause(0.1);
        dir_content = dir(strcat(upath,'/*.tiff'));
        new_list = {dir_content.name};
        
        % Executes if a new file appears in the target folder
        if length(new_list) > length(initial_list)
            
            % Determines path to unknown file
            filepath = char(strcat(upath,'/',(dir_content(end).name)));
            
            % Reads in unknown file and convert to double precision
            raw_image = imread(filepath);
            raw = im2double(raw_image);
            
            % Determines background intensity using image corners
            background = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
                raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));
            
            % Subtracts background
            raw = raw-background;
            
            % Reads in calibration .MAT file
            load('calibration.mat');
            
            % Subtract background
            cal = cal-background;
            
            % Divides background subtracted image into four quadrants
            cal_a = cal(1:size(cal,1)/2,1:size(cal,2)/2,:);
            cal_b = cal(size(cal,1)/2+1:size(cal,1),1:size(cal,2)/2,:);
            cal_c = cal(1:size(cal,1)/2,size(cal,2)/2+1:size(cal,2),:);
            cal_d = cal(size(cal,1)/2+1:size(cal,1),size(cal,2)/2+1:size(cal,2),:);
            
            % Calls DATA_PREP function on the first pass
            if c1 == 1
                
                % Determine center of top right quadrant and set halfwidth
                x = round(0.25*(length(raw(1,:))));
                y = round(0.25*(length(raw(:,1))));
                w = 200;
                setappdata(0,'subframe',[x-(w/2) y-(w/2) w w])
                
                [w,x,y,~,~,~,upath,savename,writerObj,expname]...
                    = data_prep(handles);
            end
                      
            % Divides background subtracted image into four quadrants
            a = raw(1:size(raw,1)/2,1:size(raw,2)/2,:);
            b = raw(size(raw,1)/2+1:size(raw,1),1:size(raw,2)/2,:);
            c = raw(1:size(raw,1)/2,size(raw,2)/2+1:size(raw,2),:);
            d = raw(size(raw,1)/2+1:size(raw,1),size(raw,2)/2+1:size...
                (raw,2),:);
            
            % Wavelengths of each quadrant at Bristol
            % a = top left (670 nm)
            % b = top right (750 nm)
            % c = bottom left (850 nm)
            % d = bottom right (580 nm)
            
            % Extracts filenumber from filename
            filenumber(c1) = extract_filenumber(dir_content(end).name);
            
            % Returns spatial correlation parameters for first file in the
            % dataset or if there is a gap of more than 1 between the last 
            % good file and the current file.
            if c1 == 1 || (c1 > 1 && filenumber(c1)-filenumber(c1-1) > 1)
                [bya,bxa,cya,cxa,dya,dxa] = correlate(a,b,c,d);
            end
            
            % Shifts quadrants based on offsets and pads by 4 pixels
            a = a(y-w-4:y+w+4,x-w-4:x+w+4);
            b = b(y-w+bya-4:y+w+bya+4,x-w+bxa-4:x+w+bxa+4);
            c = c(y-w+cya-4:y+w+cya+4,x-w+cxa-4:x+w+cxa+4);
            d = d(y-w+dya-4:y+w+dya+4,x-w+dxa-4:x+w+dxa+4);
            
            % Returns spatial correlation parameters for the calibration
            % file but only on the first pass through the loop. Note that 
            % with a sufficiently flat field, the offsets are likely to be
            % zero and this procedure will have no effect.
            if c1 == 1
                [cal_bya,cal_bxa,cal_cya,cal_cxa,cal_dya,cal_dxa] = ...
                    correlate(cal_a(y-w:y+w,x-w:x+w),cal_b...
                    (y-w:y+w,x-w:x+w),cal_c(y-w:y+w,x-w:x+w),cal_d...
                    (y-w:y+w,x-w:x+w));
            end
            
            % Shifts quadrants based on offsets and pads by 4 pixels
            cal_a=cal_a(y-w-4:y+w+4,x-w-4:x+w+4);
            cal_b=cal_b(y-w+cal_bya-4:y+w+cal_bya+4,x-w+cal_bxa-4:...
                x+w+cal_bxa+4);
            cal_c=cal_c(y-w+cal_cya-4:y+w+cal_cya+4,x-w+cal_cxa-4:...
                x+w+cal_cxa+4);
            cal_d=cal_d(y-w+cal_dya-4:y+w+cal_dya+4,x-w+cal_dxa-4:...
                x+w+cal_dxa+4);
            
            % Calls mapper function to calculate temperature, error and
            % emissivity maps, and also returns maximum T and associated
            % errors, intensities, wien slope and intercept and map indices
            % and smoothed b quadrant for plotting countours later
            [T,E_T,E_E,epsilon,T_max(c1),E_T_max(c1),E_E_max(c1),U_max,...
                m_max,C_max(c1),dx,dy,sb,bsz,nw] = mapper(cal_a,cal_b,cal_c,...
                cal_d,d,a,c,b,handles,filepath); %#ok<AGROW>
            
            % Calls difference function to calculate the difference map and
            % associated metric.
            [T_dif,T_dif_metric(c1)] = difference(T, sb, bsz, c1,...
                background); %#ok<AGROW>
            
            % Create concatenated summary output array and save to
            % workspace and save current map data to .txt file if Save
            % OUtput checkbox is ticked
            [result(c1,:),timevector] = data_output(handles,dir_content(end),...
                1,c1,T_max(c1),E_T_max(c1),C_max(c1),E_E_max(c1),...
                T_dif_metric(c1),T,E_T,epsilon,E_E,T_dif,upath,...
                savename); %#ok<AGROW>
            assignin('base', 'result', result);
            
            % Calculates job progress
            progress = 'N/A';            
         
            % Calls data_plot function
            data_plot(handles,nw,T_max,E_T_max,E_E_max,U_max,m_max,C_max,c1,...
                filenumber,raw,timevector,result(:,3),T_dif_metric,T,...
                dx,dy,progress,T_dif,E_T,sb,bsz,epsilon,c1,1);
            
            if get(handles.checkbox2,'Value') == 1
                % Writes current GUI frame to movie
                movegui(gcf,'center')
                frame=getframe(gcf);
                writeVideo(writerObj,frame);
            end
            
            % Increment counter c1
            c1 = c1 + 1;
            
            initial_list = new_list;
        end
    end
    
    if get(handles.checkbox2,'Value') == 1
        % Closes video file on loop exit
        close(writerObj);

        % Saves summary data to text file
        summary_file = char(strcat(upath,'/',savename,'/',expname(end),...
            '_SUMMARY.txt'));
        save (summary_file,'result','-ASCII','-double');
    end
end


%--------------------------------------------------------------------------
% --- Executes on press of POST PROCESS button
function pushbutton2_Callback(~, ~, handles)

% Clear all axes within GUI
arrayfun(@cla,findall(0,'type','axes'))
fclose('all');

% Reset textboxes to 0
set(handles.edit1,'String','0')
set(handles.edit2,'String','0')

% Update button states
flag = {0 0 0 0 0 0 1 1 0 0 0 0};
control_colors(flag, handles)

% Deletes ROI if one already exists
hfindROI = findobj(gca,'Type','hggroup');    
delete(hfindROI)

% Default intensity cutoff to 25% and enable
set(handles.slider1,'Value',0.25);
set(handles.text12,'String','25 %');
set(handles.slider1,'Enable','on');
set(handles.checkbox2,'Enable','on');

% Determine path to app location
if isdeployed
    appRoot = ctfroot;
    if ismac
        appRootSplit = strsplit(appRoot,'MIRRORS.app');
    elseif ispc
        [~,pcroot] = system('path');
        appRoot = char(regexpi(pcroot, 'Path=(.*?);', 'tokens', 'once'));
        appRootSplit = strsplit(appRoot,'MIRRORS.exe');
    end
else
    appRootSplit = strsplit(pwd,'xxxx');
end

% Ask user to point to folder containing .TIF files to be processed
upath = uigetdir(appRootSplit{1},'Select folder containing images to be processed');

% Create array containing file metadata on all .TIF files in folder that
% have a trailing number
dir_content = dir(strcat(upath,'/*.tiff'));
setappdata(0,'dir_content',dir_content);

% Determine number of .TIF files in folder
total=size(dir_content,1);

% Set string of text5 to current folder path
set(handles.text5,'string',upath);

% List filenames of .TIF files in folder
filenames = {dir_content.name};

% Get state of checkbox one: 1 if user wants to attempt to fit saturated
% images
saturate = get(handles.checkbox1,'value');

% Initialise c1
c1 = 1;

% Creates list of .TIF files to be fitted
for i=1:total

    char(strcat(upath,'/',(filenames(i))));
    % Reads in unknown file  
    raw=imread(char(strcat(upath,'/',(filenames(i)))));
    
    % Determines background intensity
    background = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
        raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));
    
    % Forces top right plot option to 'difference'
    set(handles.radiobutton5,'Value',1);
    
    % Divides background subtracted image into four quadrants
    a = raw(1:round(size(raw,1))/2,1:round(size(raw,2))/2,:);
    b = raw(size(raw,1)/2+1:size(raw,1),1:size(raw,2)/2,:);
    c = raw(1:size(raw,1)/2,size(raw,2)/2+1:size(raw,2),:);
    d = raw(size(raw,1)/2+1:size(raw,1),size(raw,2)/2+1:size(raw,2),:);

    % Wavelengths of each quadrant at Bristol
    % a = top left (670 nm)
    % b = bottom left (850 nm)
    % c = top right (750 nm)
    % d = bottom right (580 nm)
    
    % Automaticlly determines the bit depth of the .TIFF files being used
    % and sets the saturation limit to 99% of that value
    image_info = imfinfo(char(strcat(upath,'/',(filenames(i)))));
    saturation_limit = 2^image_info.BitDepth*.95;
    
    % Assigns each file in sequence to filenumber array if the weakest of
    % the four hotspots is stronger than double the background if user has
    % chosen to fit saturated images
    if saturate == 1 
        if min(max([d(:) a(:) c(:) b(:)])) > 2*background
            filenumber(c1) = extract_filenumber(cell2mat(filenames(i)));...
                %#ok<AGROW>
            listpos(c1)=i;
            if ~isnan(filenumber)
                data_plot(handles,[0 1],[NaN NaN],[NaN NaN],[NaN NaN],NaN,...
                    NaN,NaN,c1,filenumber,raw,0,[0 1],NaN,[1 2],1,1,[0 1],0,...
                    [0 1],[1 2],0,1,0,[NaN,NaN])
            end
            
            c1 = c1+1;
        end
    % Assigns each file in sequence to filenumber array if the weakest of
    % the four hotspots is stronger than double the background AND none are 
    %brighter than the detector bit depth if user has chosen NOT to fit
    %saturated images    
    else
        if (min(max([d(:) a(:) c(:) b(:)])) > 2*background) &&...
                (max(max([d(:) a(:) c(:) b(:)])) < saturation_limit)
            filenumber(c1) = extract_filenumber(cell2mat(filenames(i)))...
                ; %#ok<AGROW>  
            listpos(c1)=i;
            if ~isnan(filenumber)
                data_plot(handles,[0 1],[NaN NaN],[NaN NaN],[NaN NaN],NaN,...
                    NaN,NaN,c1,filenumber,raw,0,[0 1],NaN,[1 2],1,1,[0 1],0,...
                    [0 1],[1 2],0,1,0,0)
                    
            end
            
            c1 = c1+1;
        end
    end
end

% Update button states
flag = getappdata(0,'flag');
[flag{2},flag{9}] = deal(1);
control_colors(flag, handles)

% Eliminate and NaNs from filenumber; these will be .tiff files in the
% folder that do not contain a digit in the last position.
filenumber = filenumber(~isnan(filenumber));

% Make data available between functions within GUI
setappdata(0,'filenumber',filenumber)
setappdata(0,'listpos',listpos)
setappdata(0,'dir_content',dir_content)
setappdata(0,'upath',upath)


%--------------------------------------------------------------------------
% --- Executes on press of SELECT ROI button
function pushbutton3_Callback(~, ~, handles) %#ok<DEFNU>

% Update button states
flag = getappdata(0,'flag');
[flag{3},flag{6},flag{12}] = deal(0);
control_colors(flag, handles)

% Deletes interactive ROI if one already exists
hfindROI = findobj(handles.axes1,'Type','hggroup');    
delete(hfindROI)

% Deletes fixed ROI if one already exists
hfindrect = findobj(handles.axes1,'Type','rectangle');
delete(hfindrect)

% Creates resizeable ROI rectangle and waits until user double clicks
% inside it, and then reads out position pixel position of top left corner
% and size (constrined to a square, and a region with a 20 pixel hold off
% from the edge of the frame to allow space for misalignment and padding
% pixel binning).
ROI = imrect(handles.axes1, [91 28 200 200]);
fcn = makeConstrainToRectFcn('imrect',[20 344],[20 235]);
setPositionConstraintFcn(ROI,fcn);
setFixedAspectRatioMode(ROI,'True');
subframe = wait(ROI);

% Make ROI position avaialble to other functions
setappdata(0,'subframe',subframe)

% Updates button states
flag = getappdata(0,'flag');
[flag{3},flag{10}] = deal(1);
control_colors(flag, handles)


%--------------------------------------------------------------------------
% --- Executes when user selects START box
function edit1_Callback(~, ~, handles) %#ok<DEFNU>

% Gets user entered value of first file to fit
fi = eval(get(handles.edit1,'string'));

% Access previously stored array filenumber
filenumber = getappdata(0,'filenumber');

% Converts fi to first GOOD file if user selects earlier file of last GOOD
% file if user selects a later file
if ~ismember(fi,filenumber(filenumber>0)) == 1
    [~,idx] = min(abs(filenumber-fi));
    fi= filenumber(idx);
end

% Set edit box to error checked fl
set(handles.edit1,'string',num2str(fi));

% Updates button states
flag = getappdata(0,'flag');
[flag{4},flag{11}] = deal(1);
control_colors(flag, handles)


%--------------------------------------------------------------------------
% --- Executes when user selects END box
function edit2_Callback(~, ~, handles) %#ok<DEFNU>

% Gets user entered value of last file to fit
fl = eval(get(handles.edit2,'string'));

% Access previously stored array filenumbers
filenumber = getappdata(0,'filenumber');

% Converts fl to last GOOD file if user selects later file
if ~ismember(fl,filenumber(filenumber>0)) == 1
    [~,idx] = min(abs(filenumber-fl));
    fl = filenumber(idx);
end
    
% Converts fl to fi if user enters a value of fl < fi    
if fl < eval(get(handles.edit1,'string'))
    fl = eval(get(handles.edit1,'string'));    
end

% Set edit box to error checked fl
set(handles.edit2,'string',num2str(fl));

% Updates button states
flag = getappdata(0,'flag');
flag{5} = 1;
control_colors(flag, handles)


%--------------------------------------------------------------------------
% --- Executes when user presses PROCESS button
function pushbutton4_Callback(~, ~, handles) 

% Reset auto_flag to 0
setappdata(0,'auto_flag','0');
    
% Calls DATA_PREP function which returns parameters for the sequential
% fitting
[w,x,y,fi,fl,filenumber,upath,savename,writerObj,expname]...
    = data_prep(handles);

% Get list of .TIFF files from appdata
dir_content = getappdata(0,'dir_content');

%Get list of positions in folder of files to be fitted
listpos = getappdata(0,'listpos');

% Determine start and end positions within file list;
[start_file,~] = find(filenumber'==fi);
[end_file,~] = find(filenumber'==fl);

% Initialise c1
c1 = 1;

% Calculates temperature, error and difference maps and associated output
% for each file and plots and stores the results.
for i=start_file:end_file
    
    % Determines path to unknown file
    filepath = char(strcat(upath,'/',(dir_content(listpos(i)).name)));
    
    % Reads in unknown file and convert to double precision
    raw_image = imread(filepath);
    raw = im2double(raw_image);
    
    % Determines background intensity using image corners of unknown file
    background = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
        raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));
    
    % Subtracts background
    raw = raw-background;   
  
    % Divides background subtracted image into four quadrants
    a = raw(1:size(raw,1)/2,1:size(raw,2)/2,:);
    b = raw(size(raw,1)/2+1:size(raw,1),1:size(raw,2)/2,:);
    c = raw(1:size(raw,1)/2,size(raw,2)/2+1:size(raw,2),:);
    d = raw(size(raw,1)/2+1:size(raw,1),size(raw,2)/2+1:size(raw,2),:);
    
    % Wavelengths of each quadrant at Bristol
    % a = top left (670 nm)
    % b = top right (750 nm)
    % c = bottom left (850 nm)
    % d = bottom right (580 nm)
    
    % Reads in calibration .MAT file
    load('calibration.mat');
    
    % Subtract background. Note that this is the background determined from
    % the current unknown, applied retrospectively to the calibration file.
    % This is technically unreasonable, but determining a true background
    % for the calibration file, which may consist of images that completely
    % fill the frame, by looking at the corners or edges is risky.
    cal = cal-background;

    % Divides background subtracted image into four quadrants
    cal_a = cal(1:size(cal,1)/2,1:size(cal,2)/2,:);
    cal_b = cal(size(cal,1)/2+1:size(cal,1),1:size(cal,2)/2,:);
    cal_c = cal(1:size(cal,1)/2,size(cal,2)/2+1:size(cal,2),:);
    cal_d = cal(size(cal,1)/2+1:size(cal,1),size(cal,2)/2+1:size(cal,2),:);
    
    % Returns spatial correlation parameters for first file in the dataset
    % or if there is a gap of more than 1 between the last good file and 
    % the current file. 
    if c1 == 1 || (c1 > 1 && filenumber(c1)-filenumber(c1-1) > 1)
        [bya,bxa,cya,cxa,dya,dxa] = correlate(a,b,c,d);
    end
    
    % Shifts quadrants based on offsets and pads by 4 pixels
    a = a(y-w-4:y+w+4,x-w-4:x+w+4);
    b = b(y-w+bya-4:y+w+bya+4,x-w+bxa-4:x+w+bxa+4);
    c = c(y-w+cya-4:y+w+cya+4,x-w+cxa-4:x+w+cxa+4);
    d = d(y-w+dya-4:y+w+dya+4,x-w+dxa-4:x+w+dxa+4);
    
    % Returns spatial correlation parameters for the calibration file but
    % only on the first pass through the loop. Note that with a
    % sufficiently flat field, the offsets are likely to be zero and this
    % procedure will have no effect.
    if c1 == 1
       [cal_bya,cal_bxa,cal_cya,cal_cxa,cal_dya,cal_dxa] = correlate(...
           cal_a(y-w:y+w,x-w:x+w),cal_b(y-w:y+w,x-w:x+w),...
           cal_c(y-w:y+w,x-w:x+w),cal_d(y-w:y+w,x-w:x+w));
    end
    
    % Shifts quadrants based on offsets and pads by 4 pixels
    cal_a=cal_a(y-w-4:y+w+4,x-w-4:x+w+4);
    cal_b=cal_b(y-w+cal_bya-4:y+w+cal_bya+4,x-w+cal_bxa-4:x+w+cal_bxa+4);
    cal_c=cal_c(y-w+cal_cya-4:y+w+cal_cya+4,x-w+cal_cxa-4:x+w+cal_cxa+4);
    cal_d=cal_d(y-w+cal_dya-4:y+w+cal_dya+4,x-w+cal_dxa-4:x+w+cal_dxa+4);
    
    % Calls mapper function to calculate temperature, error and emissivity
    % maps, and also returns maximum T and associated errors, intensities,
    % wien slope and intercept and map indices and smoothed b quadrant for
    % plotting countours later
    [T,E_T,E_E,epsilon,T_max(c1),E_T_max(c1),E_E_max(c1),U_max,m_max,...
        C_max(c1),dx,dy,sb,bsz,nw] = mapper(cal_a,cal_b,cal_c,cal_d,d,a,c,b,...
        handles,filepath); %#ok<AGROW>
    
    % Calls difference function to calculate the difference map and
    % associated metric.
    [T_dif,T_dif_metric(c1)] = difference(T, sb, bsz, c1, background);...
        %#ok<AGROW>
    
    % Create concatenated summary output array and save to workspace and
    % save current map data to .txt file if Save Output checkbox ticked
    [result(c1,:),timevector] = data_output(handles,dir_content(listpos(i)),...
        1,c1,T_max(c1),E_T_max(c1),C_max(c1),E_E_max(c1),...
        T_dif_metric(c1),T,E_T,epsilon,E_E,T_dif,upath,savename);...
        %#ok<AGROW>
    assignin('base', 'result', result);
        
    % Calculates job progress
    progress = ceil(c1/length(listpos(start_file:end_file))*100);

    % Calls data_plot function
    data_plot(handles,nw,T_max,E_T_max,E_E_max,U_max,m_max,C_max,i,...
        filenumber,raw,timevector,result(:,3),T_dif_metric,T,dx,dy,...
        progress,T_dif,E_T,sb,bsz,epsilon,c1,1);
    
    if get(handles.checkbox2,'Value') == 1
        % Writes current GUI frame to movie
        movegui(gcf,'center')
        frame=getframe(gcf);
        setappdata(0,'frame',frame);
        writeVideo(writerObj,frame);
    end
    
    % Increment counter c1
    c1 = c1 + 1;
  
end

if get(handles.checkbox2,'Value') == 1
    % Closes video file on loop exit
    close(writerObj);
    
    % Saves summary data to text file
    summary_file = char(strcat(upath,'/',savename,'/',expname(end),...
        '_SUMMARY.txt'));
    save (summary_file,'result','-ASCII','-double');
end

%--------------------------------------------------------------------------
% --- Executes on slider movement.
function slider1_Callback(~, ~, handles) %#ok<DEFNU>

% Get current slider value
slider_val = get(handles.slider1,'Value')*100;

%Set textbox to current slider value
set(handles.text12,'String',strcat(num2str(round(slider_val)),{' '},'%'));

%--------------------------------------------------------------------------
% --- Executes on button press in Fit saturated images chackbox.
function checkbox1_Callback(~, ~, handles) %#ok<DEFNU>

%--------------------------------------------------------------------------
% --- Executes when user clicks on the Update Hardware Parameters button
function pushbutton6_Callback(~, ~, ~) %#ok<DEFNU>
hardware_parameters

%--------------------------------------------------------------------------
% --- Executes when user clisks on the Update Calibration Image button
function pushbutton8_Callback(~, ~, handles) %#ok<DEFNU>

% Load current hardware_parameters
calmat = matfile('calibration.mat','Writable',true);

% Determine path to app location
if isdeployed
    appRoot = ctfroot;
    if ismac
        appRootSplit = strsplit(appRoot,'MIRRORS.app');
    elseif ispc
        [~,pcroot] = system('path');
        appRoot = char(regexpi(pcroot, 'Path=(.*?);', 'tokens', 'once'));
        appRootSplit = strsplit(appRoot,'MIRRORS.exe');
    end
else
    appRootSplit = strsplit(pwd,'xxxx');
end

% Ask user to select new Calibration Image   
[cal_file,cal_path] = uigetfile(strcat(appRootSplit{1},'/*.tiff'),...
    'Select new Calibration Image');

% Read in data and convert to double
cal_image = imread(strcat(cal_path,cal_file));
cal_data = im2double(cal_image);

% Save data to .MAT file
calmat.cal = cal_data;
calmat.name = cal_file

% Write current calibration name to GUI
set(handles.text20,'String',calmat.name);


%--------------------------------------------------------------------------
% --- Executes when BENCHMARK button is pushed
function pushbutton5_Callback(~, ~, handles)

% Determine path to app location
if isdeployed
    appRoot = ctfroot;
    if ismac
        appRootSplit = strsplit(appRoot,'MIRRORS.app');
    elseif ispc
        [~,pcroot] = system('path');
        appRoot = char(regexpi(pcroot, 'Path=(.*?);', 'tokens', 'once'));
        appRootSplit = strsplit(appRoot,'MIRRORS.exe');
    end
else
    appRootSplit = strsplit(pwd);
end

% Ask user to select folder containing example data    
example_data = uigetdir(appRootSplit{1},'Select folder containing example data');
    
% Get new directory content
dir_content = dir(strcat(example_data,'/example_0*'));
    
% Update timestamps by reading and re-writing a single byte IF they are
% equal
if strcmp(dir_content(1).date,dir_content(2).date) == 1
    for i = 1:length(dir_content)
        current = dir_content(i).name;
        pause(1)
        fid = fopen(strcat(example_data,'/',current),'r+');
        byte = fread(fid, 1);
        fseek(fid, 0, 'bof');
        fwrite(fid, byte);
        fclose(fid);
    end
    % Update directory content
    dir_content = dir(strcat(example_data,'/example_0*'));
end

% Set directory content and listpos into appdata
setappdata(0,'dir_content',dir_content)
listpos = length(dir_content)-10:1:length(dir_content);
setappdata(0,'listpos',listpos)

% Fix subframe position
setappdata(0,'subframe',[91 28 200 200])

% Fix file range
set(handles.edit1,'string','1')
set(handles.edit2,'string','11')

% Fix filenumber list and upath
setappdata(0,'filenumber',[1 2 3 4 5 6 7 8 9 10 11]);
setappdata(0,'upath',example_data);

% Set user options
set(handles.slider1,'Value',0.25)
set(handles.checkbox1,'Value',1)
set(handles.checkbox2,'Value',1)

% --- TEST LOOP -----------------------------------------------------------
% Tests every peak temperature option against every optional plot option in
% turn with cutoff at 25% and fit saturated images on.

% Initialise counter
t1 = 1;

for m = 1:4
    for n = 5:8
        % Set peak temperature radiobutton
        set(handles.(['radiobutton' num2str(m)]),'Value',1)
        
        % Set optional plot radiobutton
        set(handles.(['radiobutton' num2str(n)]),'Value',1)

        % Run PROCESS button
        pushbutton4_Callback([], [], handles)

        % Get folder name of output directory
        savename = getappdata(0,'savename');

        new = textread(strcat(example_data,'/',savename,...
            '/example_SUMMARY.txt'));
        benchmark = textread(strcat(example_data,'/test_',num2str(t1),...
            '/example_SUMMARY.txt'));
        difference = new-benchmark

        % Increment counter
        t1 = t1 + 1;
    end
end


%--------------------------------------------------------------------------
% --- Executes when Update Test Data button is pushed
function pushbutton9_Callback(~, ~, handles)

% Determine path to app location
if isdeployed
    appRoot = ctfroot;
    if ismac
        appRootSplit = strsplit(appRoot,'MIRRORS.app');
    elseif ispc
        [~,pcroot] = system('path');
        appRoot = char(regexpi(pcroot, 'Path=(.*?);', 'tokens', 'once'));
        appRootSplit = strsplit(appRoot,'MIRRORS.exe');
    end
else
    appRootSplit = strsplit(pwd);
end

% Ask user to select folder containing example data    
example_data = uigetdir(appRootSplit{1},'Select folder containing example data');

% Get current directory content
dir_content = dir(example_data);

% Remove existing folders
for i = 1:length(dir_content) 
    if dir_content(i).isdir == 1 & dir_content(i).name ~= '.' %#ok<AND2>
       rmdir(strcat(example_data,'/',dir_content(i).name),'s');
    end
end

% Update directory content
dir_content = dir(strcat(example_data,'/example_0*'));

% Set directory content and listpos into appdata
setappdata(0,'dir_content',dir_content)
listpos = length(dir_content)-4:1:length(dir_content);
setappdata(0,'listpos',listpos)

% Fix subframe position
setappdata(0,'subframe',[91 28 200 200])

% Fix file range
set(handles.edit1,'string','1')
set(handles.edit2,'string','5')

% Fix filenumber list and upath
setappdata(0,'filenumber',[1 2 3 4 5]);
setappdata(0,'upath',example_data);

% Set user options
set(handles.slider1,'Value',0.25)
set(handles.checkbox1,'Value',1)
set(handles.checkbox2,'Value',1)

% Initialise counter
t1 = 1;

% Load current calibration file
calmat = matfile('calibration.mat','Writable',true);

% Read in data and convert to double
cal_image = imread(strcat(example_data,'/tc_example.tiff'));
cal_data = im2double(cal_image);

% Save data to .MAT file
calmat.cal = cal_data;
calmat.name = 'tc_example.tiff';

% Write current calibration name to GUI
set(handles.text20,'String',calmat.name);

for m = 1:4
    for n = 5:8
        
        % Set peak temperature radiobutton
        set(handles.(['radiobutton' num2str(m)]),'Value',1)
        
        % Set optional plot radiobutton
        set(handles.(['radiobutton' num2str(n)]),'Value',1)

        % Run PROCESS button
        pushbutton4_Callback([], [], handles)

        % Get folder name of output directory
        savename = getappdata(0,'savename');
        
        % Change output folder name to test_1
        movefile(strcat(example_data,'/',savename),...
            strcat(example_data,'/','test_',num2str(t1)))

        % Get last frame of GUI window
        frame = getappdata(0,'frame');
        imwrite(frame.cdata,strcat(example_data,'/test_',num2str(t1),...
            '/test_',num2str(t1),'.png'))
        
        % Increment counter
        t1 = t1 + 1;
    end
end
