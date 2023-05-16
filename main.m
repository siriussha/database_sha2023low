%% Step 1
clc,clear,close all
c = colororder;
fontN = 'Times New Roman';
fontS = 10;

dlDirStep1 = dir('raw\Step 1*.csv');
iTarget = 20:10:500;
data = array2table(zeros(length(iTarget),6),...
    "VariableNames",{'idc','udc','uneg','upos','ineg','ipos'});

for iter = 1:length(dlDirStep1)
    fig = figure("Name",['Step 1_',num2str(iter)]);
    dataRaw = readtableDL(fullfile(dlDirStep1(iter).folder,dlDirStep1(iter).name));
    iSet = getISet(dataRaw.ADC);
    for k = 1:length(iTarget)
        idx = find(abs(iSet-iTarget(k))<2.5);
        if (length(idx) > 15)
            idxIdx = find(idx - [idx(1)-1;idx(1:end-1)] > 1);
            idxIdx = idxIdx(find(idxIdx>6,1));
            if  ~isempty(idxIdx)
                idx = [idx(idxIdx-6:idxIdx-2);idx(end-6:end-2)];
            else
                idx = idx(end-11:end-2);
            end
        end
        data.udc(k) = mean(dataRaw.VDC(idx));
        data.idc(k) = mean(dataRaw.ADC(idx));
        data.upos(k) = max(dataRaw.VDC(idx)) - data.udc(k);
        data.uneg(k) = -min(dataRaw.VDC(idx)) + data.udc(k);
        data.ipos(k) = max(dataRaw.ADC(idx)) - data.idc(k);
        data.ineg(k) = -min(dataRaw.ADC(idx)) + data.idc(k);
    end
    writetable(data,['processed\Step1_',num2str(iter),'.csv']);
    plot(data.idc,data.udc,'ko','MarkerFaceColor','k','MarkerSize',5),hold on
    xlabel('Current/A',"FontName",fontN,"FontSize",fontS)
    ylabel('Voltage/V',"FontName",fontN,"FontSize",fontS)
    title(['Step 1(',num2str(iter),')'],"FontName",fontN,"FontSize",fontS+3,...
        'Position',[50,22.5,-1])
    ax = gca;
    ax.Box = 'off';
    ax.Position = [0.1300 0.1100 0.7400 0.7800];
    xlim([0,500]);
    ylim([16,22]);
    ax = axes('Position',get(ax,'Position'),...
               'XAxisLocation','bottom',...
               'YAxisLocation','right',...
               'Color','none',...
               'XColor','k','YColor','r');
    hold on
    errorbar(data.idc,zeros(size(data.idc)),data.uneg,data.upos,'Color','r')
    xlim([0,500])
    ylabel('error bar of voltage/V',"FontName",fontN,"FontSize",fontS)
    ax = axes('Position',get(ax,'Position'),...
               'XAxisLocation','top',...
               'YAxisLocation','left',...
               'Color','none',...
               'XColor',c(1,:),'YColor','k');
    hold on
    errorbar(zeros(size(data.udc)),data.udc,data.ineg,data.ipos,'horizontal','Color',c(1,:))
    ylim([16,22])
    xlabel('error bar of Currrnt/A',"FontName",fontN,"FontSize",fontS)
    ax.TickDir = 'in';
    saveas(fig,['fig\',fig.Name],'svg')
end
% errorbar(data.idc,data.udc,data.uneg,data.upos,data.ineg,data.ipos,...
%     '.','CapSize',2,'MarkerEdgeColor','r','Color','k')


%% Step 2
clc,clear,close all
fontN = 'Times New Roman';
fontS = 10;

dlDirStep2 = dir('raw\Step 2*.csv');
iTarget = [0.95,1.35,2.50,3.43,4.62,5.50,6.70,7.67,8.80];
data = array2table(zeros(length(iTarget),6),...
    "VariableNames",{'idc','udc','uneg','upos','ineg','ipos'});
% dataRaw = readtableDL(fullfile(dlDirStep2(1).folder,dlDirStep2(1).name));
% dataRaw = dataRaw(dataRaw.ADC<10,:);
% yyaxis right
% plot(dataRaw.Time,dataRaw.ADC)
% yyaxis left
% plot(dataRaw.Time,dataRaw.VDC)
for iter = 1:length(dlDirStep2)
    fig = figure("Name",['Step 2_',num2str(iter)]);
    dataRaw = readtableDL(fullfile(dlDirStep2(iter).folder,dlDirStep2(iter).name));
    dataRaw = dataRaw(dataRaw.ADC<10,:);
    for k = 1:length(iTarget)
        idx = find(abs(dataRaw.ADC-iTarget(k))<0.15);
        idxIdx = find(idx - [idx(1)-1;idx(1:end-1)] > 1);
        idxIdx = idxIdx(find(idxIdx>10,1));
        if  ~isempty(idxIdx)
            idx = [idx(idxIdx-6:idxIdx-2);idx(end-6:end-2)];
        else
            idx = idx(end-11:end-2);
        end
        data.udc(k) = mean(dataRaw.VDC(idx));
        data.idc(k) = mean(dataRaw.ADC(idx));
        data.upos(k) = max(dataRaw.VDC(idx)) - data.udc(k);
        data.uneg(k) = -min(dataRaw.VDC(idx)) + data.udc(k);
        data.ipos(k) = max(dataRaw.ADC(idx)) - data.idc(k);
        data.ineg(k) = -min(dataRaw.ADC(idx)) + data.idc(k);
    end
    writetable(data,['processed\Step2_',num2str(iter),'.csv']);
    errorbar(data.idc,data.udc,data.uneg,data.upos,data.ineg,data.ipos,...
        '*','CapSize',5,'MarkerEdgeColor','k','Color','r')
    xlim([0,9]),ylim([10,17])
    xlabel('Current/A',"FontName",fontN,"FontSize",fontS)
    ylabel('Voltage/V',"FontName",fontN,"FontSize",fontS)
    title(['Step 2(',num2str(iter),')'],"FontName",fontN,"FontSize",fontS+3)
    saveas(fig,['fig\',fig.Name],'svg')
end

%% Step 3
clc,clear,close all
c = colororder;
fontN = 'Times New Roman';
fontS = 10;

dlDirStep3 = dir('raw\Step 3*.csv');
numData = 300;
idxSelect = [3,4,5,6];
varNames = cell(length(idxSelect)*3,1);
for k = 1:length(idxSelect)
    varNames{3*k-2} = ['tExp',num2str(idxSelect(k))];
    varNames{3*k-1} = ['uExp',num2str(idxSelect(k))];
    varNames{3*k-0} = ['iExp',num2str(idxSelect(k))];
end
data = array2table(zeros(numData,length(idxSelect)*3),...
    "VariableNames",varNames);
for iter = 1:length(dlDirStep3)
    fig = figure("Name",['Step 3_',num2str(iter)]);
    dataRaw = readtableDL(fullfile(dlDirStep3(iter).folder,dlDirStep3(iter).name));
    idxPulse = find(dataRaw.ADC > 0.5);
    idxT1 = idxPulse(idxPulse-[0;idxPulse(1:end-1)] > 1);
    idxT1 = idxT1(2:end-1);
    numExp = length(idxT1);
    tiledlayout(ceil(sqrt(numExp)),ceil(numExp/ceil(sqrt(numExp))),...
        "TileSpacing","compact")
    for k = 1:numExp
        nexttile(k);
        idx = idxT1(k)-9:idxT1(k)-10+numData;
        ts = seconds(dataRaw.Time(idx) - dataRaw.Time(idx(1)));
        yyaxis left
        plot(ts,dataRaw.VDC(idx));
        ylim([0,10])
        yyaxis right
        plot(ts,dataRaw.ADC(idx));
        idxRecord = find(k==idxSelect);
        if (~isempty(idxRecord))
            data(:,3*idxRecord-2) = array2table(ts);
            data(:,3*idxRecord-1) = array2table(dataRaw.VDC(idx));
            data(:,3*idxRecord-0) = array2table(dataRaw.ADC(idx));
        end
    end
    sgtitle('Step 3 (x:t, y:left-u, y:right-i)')
    writetable(data,['processed\Step3_',num2str(iter),'.csv']);
    saveas(fig,['fig\',fig.Name],'svg')
end


%% adjust current set
function iSet = getISet(idc)
    iSet = (idc+11.6794)/1.0271;
end