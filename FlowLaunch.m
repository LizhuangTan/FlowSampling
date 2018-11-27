function varargout = FlowLaunch(ServerNumber,ServerTime,MaxFlowSize,LongFlowThreshold,LongFlowProportion);

delete('data.xlsx');%��ԭ����data�ļ�ɾ��

FlowLauncher = cell(1,ServerNumber);%Ԫ��������
for Initialization = 1:ServerNumber
    FlowLauncher_Initialization = zeros(ServerTime,1);
    for i=1:ServerTime
    if rand(1)<=LongFlowProportion
        FlowLauncher_Initialization(i,1) = LongFlowThreshold+rand(1)*(MaxFlowSize-LongFlowThreshold);
    else
        FlowLauncher_Initialization(i,1) = rand(1)*LongFlowThreshold;
    end
    end
    FlowLauncher{1,Initialization} = FlowLauncher_Initialization;
end

%�洢����ģ��
for i=1:ServerNumber
   xlswrite('data.xlsx',FlowLauncher{1,i},['Sheet',num2str(i)]);
end

if nargout
    varargout{1} = FlowLauncher;
end