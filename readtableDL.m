function data = readtableDL(filename)
%READTABLEDL Import data from a text file
%  data = READTABLEDL(FILENAME) reads data from text file FILENAME for the
%  default selection.  Returns the data as a table.
%
%  See also READTABLE.
%

%% generate varName
fid=fopen(filename); 
idxStartLine = 1;
while ~feof(fid)
    str = fgetl(fid);
    idxStartLine = idxStartLine + 1;
    if regexp(str,'时间*')
        break
    elseif regexp(str,'扫描,时间*')
        break
    end
end 
fclose(fid);
S = regexp(str,',','split');
varNames = cell(1,length(S));
varTypes = cell(size(varNames));
for k = 1 : length(S)
    if regexp(S{k},'时间')
        varNames{k} = 'Time';
        varTypes{k} = 'char';
    elseif regexp(S{k},'扫描')
        varNames{k} = 'Series';
        varTypes{k} = 'double';
    elseif regexp(S{k},'报警.*')
        num = regexp(S{k},'\d*','match');
        varNames{k} = ['Warning',num2str(num{1})];
        varTypes{k} = 'double';
    else
        ch = regexp(S{k},'<.*>','match');
        varNames{k} = ch{1}(2:end-1);
        if strcmp(varNames{k},'电堆电流')
            varNames{k} = 'ADC';
        elseif strcmp(varNames{k},'电堆电压')
            varNames{k} = 'VDC';
        end
        varTypes{k} = 'double';
    end
end

%% create options
opts = delimitedTextImportOptions("NumVariables", length(varNames), "Encoding", "UTF16-LE");
    
% Specify range and delimiter
opts.DataLines = [idxStartLine,inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = varNames;
opts.VariableTypes = varTypes;

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Time", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Time", "EmptyFieldRule", "auto");

%% Import the data
data = readtable(filename, opts);
for k = 1:length(varNames)
    if regexp(varNames{k},'Series')
        data(:,varNames{k}) = [];
    elseif regexp(varNames{k},'Warning.*')
        data(:,varNames{k}) = [];
    end
end
datetime.setDefaultFormats('default',"yyyy/MM/dd HH:mm:ss:SSS")
data.Time = datetime(data.Time,"InputFormat","yyyy/MM/dd HH:mm:ss:SSS");

end