%FLow Sampling Programme
clear all;
close all;
format long %��������С����λ����20λ
%��������
RunTime = 10000000;%��������ʱ�䣬34������൱��1G�������Ľ�����50%���ع���1����
%1000000000�൱��1G������50���ӹ���
ServerTime = 1000;%�����ն˳�������ʱ�䳤��
LongFlowProportion = 0.1;%��������ռ��
PacketSize = 1500;%���ݰ����
LongFlowThreshold = 15000;%�����ж���ֵ����ζ��10����
MaxFlowSize = 15000000;%��������
ServerNumber = 10;%ģ���ն˸���
p=0.00001;
p_first=0.00001;%�������ʣ���ʼ��ֵΪ50%

Switches_LongFlow_List=zeros(1,3);%����������
Controller_LongFlow_List=zeros(1,4);%����������
Controller_LongFlow_List_1=zeros(1,4);%���������澵��
LongFlowNumber=0;%��������������
HowLongController_LongFlow_List=zeros(1);%����������ƽ�����г���
TCPNumber=0;%��p��صĲ���
SamplingNumber=zeros(1,1);%�������
SamplingNum=0;%�������������

%��ʼ��(���ַ���������FlowLaunch�´��������߶�ȡdata���Ѿ��еģ�������Ҫ�Ƚϵ��ö�ȡ��ʽ)

FlowLauncher = FlowLaunch(ServerNumber,ServerTime,MaxFlowSize,LongFlowThreshold,LongFlowProportion);

%��ȡ����ģ��
%  for Initialization=1:ServerNumber
%     FlowLauncher{1,Initialization}=xlsread('data.xlsx',['Sheet',num2str(Initialization)],['A1:A',num2str(ServerTime)]);
%  end


%����������
FlowLauncher_Copy=FlowLauncher;

%��������
for i=1:RunTime
   %ת�����ݰ�
   
   SamplingNum=SamplingNum+1;
   Selection = unidrnd(ServerNumber);%�������ͻ�������
   
   if sum(sum(FlowLauncher{1,Selection}))~=0; %�жϾ���ȫΪ0
       
   flag = max(find(FlowLauncher{1,Selection}==0));
   flag = flag+1;
   if isempty(flag) == 1
       flag = 1;
   end
   if  FlowLauncher{1,Selection}(flag,1)>=1500
       TCPNumber=TCPNumber+1500;
       FlowLauncher{1,Selection}(flag,1) = FlowLauncher{1,Selection}(flag,1)-1500;
   else
       TCPNumber=TCPNumber+FlowLauncher{1,Selection}(flag,1);
       FlowLauncher{1,Selection}(flag,1) = FlowLauncher{1,Selection}(flag,1)-FlowLauncher{1,Selection}(flag,1);
   end
   
   
   
      %������ѯ��ע�ᣨp������������أ�
   LongFlow_Flag = find((Switches_LongFlow_List(:,1)==Selection&Switches_LongFlow_List(:,2)==flag)==1);
   if isempty(LongFlow_Flag) == 1   %����������������޶�Ӧ�������ݣ����ո���p���в�������¼
       
      if rand(1)<=p
      Switches_LongFlow_List=[Switches_LongFlow_List;Selection flag 1];
      SamplingNumber=[SamplingNumber;SamplingNum]; %��¼�������
      SamplingNum=0;
      
      %����pֵ
       if rem(TCPNumber,1500)==0
           p=0.1*p+0.9*p_first;
           %p=1.01*p;
           TCPNumber=0;
       else
           p=0.9*p+0.1*p_first;
           %p=0.9*p_first;
           TCPNumber=0;
       end
       
       end
   elseif Switches_LongFlow_List(LongFlow_Flag,3)<10
       Switches_LongFlow_List(LongFlow_Flag,3)=Switches_LongFlow_List(LongFlow_Flag,3)+1;
   elseif Switches_LongFlow_List(LongFlow_Flag,3) == 10
       if isempty(find((Controller_LongFlow_List(:,1)==Selection&Controller_LongFlow_List(:,2)==flag)==1))==1
       Controller_LongFlow_List = [Controller_LongFlow_List;Switches_LongFlow_List(LongFlow_Flag,:) (FlowLauncher_Copy{1,Selection}(flag,1)-FlowLauncher{1,Selection}(flag,1))/1500 ];%����ͳ�Ʋ�ͨ��
       Controller_LongFlow_List_1 = [Controller_LongFlow_List_1;Switches_LongFlow_List(LongFlow_Flag,:) (FlowLauncher_Copy{1,Selection}(flag,1)-FlowLauncher{1,Selection}(flag,1))/1500 ];
       %������ʧ���ɾ��
       if  isempty(Controller_LongFlow_List_1(:,1)==Selection&Controller_LongFlow_List_1(:,2)<flag-2)==0
            Controller_LongFlow_List_1(find(Controller_LongFlow_List_1(:,1)==Selection&Controller_LongFlow_List_1(:,2)<flag-2),:)=[];%ɾ����Ӧ��¼
       end
       end
   end
   
   
   
   
   
   %������ѯ��ע��(�ȼ������)
%    LongFlow_Flag = find((Switches_LongFlow_List(:,1)==Selection&Switches_LongFlow_List(:,2)==flag)==1);
%    
%    if isempty(LongFlow_Flag) == 1   %����������������޶�Ӧ�������ݣ����ո���p���в�������¼
%       if rand(1)<=p;
%       Switches_LongFlow_List=[Switches_LongFlow_List;Selection flag 1];
%       SamplingNumber=[SamplingNumber;SamplingNum]; %��¼�������
%       SamplingNum=0;
%        end
%    elseif Switches_LongFlow_List(LongFlow_Flag,3)<10
%        Switches_LongFlow_List(LongFlow_Flag,3)=Switches_LongFlow_List(LongFlow_Flag,3)+1;
%    elseif Switches_LongFlow_List(LongFlow_Flag,3) == 10
%        if isempty(find((Controller_LongFlow_List(:,1)==Selection&Controller_LongFlow_List(:,2)==flag)==1))==1
%        Controller_LongFlow_List = [Controller_LongFlow_List;Switches_LongFlow_List(LongFlow_Flag,:) (FlowLauncher_Copy{1,Selection}(1,flag)-FlowLauncher{1,Selection}(1,flag))/1500 ];%����ͳ�Ʋ�ͨ��
%        Controller_LongFlow_List_1 = [Controller_LongFlow_List_1;Switches_LongFlow_List(LongFlow_Flag,:) (FlowLauncher_Copy{1,Selection}(1,flag)-FlowLauncher{1,Selection}(1,flag))/1500 ];
%        %������ʧ���ɾ��
%        if  isempty(Controller_LongFlow_List_1(:,1)==Selection&Controller_LongFlow_List_1(:,2)<flag-2)==0
%             Controller_LongFlow_List_1(find(Controller_LongFlow_List_1(:,1)==Selection&Controller_LongFlow_List_1(:,2)<flag-2),:)=[];%ɾ����Ӧ��¼
%        end
%        end
%    end
    
   %������������г��Ȳ�ѯ
   if  rem(i,500) == 0 %���10000�β�ѯһ�ο�����������г���
   HowLongController_LongFlow_List=[HowLongController_LongFlow_List;size(Controller_LongFlow_List_1,1)];
   end
   
   
   
   
   end%�жϾ���ȫΪ0
end


%���
%©����
ControllerLongFlowNumber = size(Controller_LongFlow_List,1)-1;%�Ѳ�������������ȥ��1��ȫ0��
for i=1:ServerNumber
    LongFlowNumber=LongFlowNumber+size(find(FlowLauncher_Copy{1,i}>LongFlowThreshold),1);
end
RatioofFalsePositive=1-ControllerLongFlowNumber/LongFlowNumber%©����
%ƽ��������������ݰ�����
MaxController_LongFlow = max(Controller_LongFlow_List(2:size(Controller_LongFlow_List,1),4));%����������ݰ�����
MinController_LongFlow = min(Controller_LongFlow_List(2:size(Controller_LongFlow_List,1),4));%��С�������ݰ�����
MedianController_LongFlow = median(Controller_LongFlow_List(2:size(Controller_LongFlow_List,1),4));%��λ��
MeanController_LongFlow = mean(Controller_LongFlow_List(2:size(Controller_LongFlow_List,1),4));%��ֵ
VarController_LongFlow = var(Controller_LongFlow_List(2:size(Controller_LongFlow_List,1),4));%����
%���г��ȼ�¼
HowLongController_LongFlow_List;%��¼���г���
%ƽ���������
Mean_SamplingNumber = mean(SamplingNumber(2:size(SamplingNumber),1));%ƽ���������
Size_SamplingNumber = size(SamplingNumber)-1;%�����ܴ���



%Figure
figure(1)%���ֲ�
for i = 1: ServerNumber
    figure_1(i,:)= FlowLauncher_Copy{1,i};
    for j = 1:10
    figure_1_StatisticalValue(1,j) = length(find(figure_1>0.1*(j-1)*MaxFlowSize&figure_1<0.1*j*MaxFlowSize));
    figure_1_StatisticalSumValue = find(figure_1>=0.1*(j-1)*MaxFlowSize&figure_1<0.1*j*MaxFlowSize);
    figure_1_StatisticalSum(1,j)= sum(figure_1(figure_1_StatisticalSumValue));
    end
end
c = figure_1(1,1:1000);sz =35;
scatter(1:1000,figure_1(1,1:1000),sz,c,'square','filled')
axis([-10 1010 0 1600000]);
set(gcf, 'Color', [1,1,1]);
xlabel('Flow Sequence','FontName','Times New Roman','FontSize',15);
ylabel('Flow Size(KB)','FontName','Times New Roman','FontSize',15);

figure(2)%���������г���
plot(1:(size(HowLongController_LongFlow_List,1)-19),HowLongController_LongFlow_List(20:size(HowLongController_LongFlow_List),1),'color',[0 0 0],'LineWidth',1)
hold on;
line([1,(size(HowLongController_LongFlow_List,1)-19)],[max(HowLongController_LongFlow_List(20:size(HowLongController_LongFlow_List),1)),max(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List),1))],'linestyle',':','color',[20/255  68/255 106/255],'LineWidth',1)
hold on;
line([1,(size(HowLongController_LongFlow_List,1)-19)],[min(HowLongController_LongFlow_List(20:size(HowLongController_LongFlow_List),1)),min(HowLongController_LongFlow_List(20:size(HowLongController_LongFlow_List),1))],'linestyle',':','color',[69/255  39/255 39/255],'LineWidth',1)
% hold on;
% line([1,(size(HowLongController_LongFlow_List,1)-1)],[mean(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List),1)),mean(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List),1))],'linestyle','--','color',[131/255  175/255 155/255],'LineWidth',1)
text(50,0.65+max(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List),1)),'Maximum queue length','FontName','Times New Roman','FontSize',13)
text(620,-0.65+min(HowLongController_LongFlow_List(100:size(HowLongController_LongFlow_List),1)),'Minimum queue length','FontName','Times New Roman','FontSize',13)
%text(1,0.25+mean(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List),1)),'Average queue length','FontName','Times New Roman','FontSize',10)
xlabel('Simulation Time(s)','FontName','Times New Roman','FontSize',15);
ylabel('Controller Queue Length','FontName','Times New Roman','FontSize',15);
axis([0 size(HowLongController_LongFlow_List,1) 0.7*min(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List,1))) max(HowLongController_LongFlow_List)*1.2]);



figure(2)%���������г���
plot(1:1200,HowLongController_LongFlow_List(20:1219,1),'color',[0 0 0],'LineWidth',1)
% line([1,(size(HowLongController_LongFlow_List,1)-1)],[mean(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List),1)),mean(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List),1))],'linestyle','--','color',[131/255  175/255 155/255],'LineWidth',1)
xlabel('Simulation time(s)','FontName','Times New Roman','FontSize',15);
ylabel('Length of queue','FontName','Times New Roman','FontSize',15);
axis([1 1200 0.7*min(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List,1))) max(HowLongController_LongFlow_List)*1.2]);




figure(3)%�������
plot(1:50,SamplingNumber(1:50),'color',[0 0 0],'LineWidth',1)
xlabel('Number of Samples','FontName','Times New Roman','FontSize',15);
ylabel('Sample Interval Packet Number','FontName','Times New Roman','FontSize',15);
%axis([0 size(SamplingNumber,1) 0.7*min(HowLongController_LongFlow_List(2:size(HowLongController_LongFlow_List,1))) max(HowLongController_LongFlow_List)*1.2]);
