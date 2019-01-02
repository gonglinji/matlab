%ϸ���������ݴ���
%�ļ�������cellviability.xls
%������ƣ����ּ�  gonglinji@outlook.com

clear all;
clc;
data = xlsread('cellviability.xls'); %����ԭʼ����
[m,n] = size(data); %ԭʼ���ݾ����С
averge = mean(data); %ƽ��ֵ
standard_deviation = std(data, 0, 1); %��׼��

%��������
errbar = [ ];
for i = 1:n-1
    errbar(i) = standard_deviation(i+1)/...
                  (averge(2)-averge(1))*100;
    i = i+1;
end
errbar;

%����ϸ�������
cell_viability = [ ];
for i = 1:n-1
    cell_viability(i) = (averge(i+1)-averge(1))/...
                           (averge(2)-averge(1))*100;
    i=i+1;
end
cell_viability;

%����������Ũ�Ⱥ�ϸ������
concentration = double(input('���������Ũ�ȣ�'));
dilution = input('Ũ�Ȱ�����ϡ��(Y/N)��', 's');
if 'Y' == dilution
    celltype = input('������ϸ�����ͣ�', 's');
    NPs = input('������������ƣ�', 's');
    fig_name = input('�����뱣��ͼƬ���ƣ�','s');

    %����ÿ��Ũ�ȣ�����ϡ��
    group = [ ];
    group(1) = 0; %����Control��Ũ��
    for i = 2:n-1
        group(i) = concentration/(2^(n-i-1)); 
    end
    group;

    group = string(group); %����X����ʾ
    group(1) = "Control"; %����Control��X����ʾ

    %����ϸ�������ֱ��ͼ
    bar = bar(1:n-1, cell_viability);
    bar.EdgeColor = [0,0,0];
    bar.LineStyle = 'none';
    hold on

    %���ϸ�����������
    er = errorbar(1:n-1, cell_viability, errbar);
    er.Color = [0 0 0];
    er.LineStyle = 'none'; %er.LineWidth=1;
    hold on

    %����ͼע���������ע
    legend(string(celltype),'FontSize',12, 'box','off')
    xlabel(['Concentration of ', NPs, ' (��g/mL)'])
    ylabel('Cell viability (%)')
    
    set(gca, 'FontSize', 12);  %�����������С
    set(get(gca,'XLabel'),'Fontsize',16);
    set(get(gca,'YLabel'),'Fontsize',16);
    set(gca,'looseInset',[0 0 0 0]); %ȥ����ױ�
    set(gca,'XTickLabel',group); %��������X����ʾ
    set(gcf, 'color', [1 1 1]); %�����ڵ�ɫ��Ϊ��ɫ
    set(gcf,'color','white'); %�����ڵ�ɫ��Ϊ��ɫ

    saveas(gcf,['./',fig_name,'.eps']);%�Զ�����
    saveas(gcf,['./',fig_name,'.png']);
    saveas(gcf,['./',fig_name,'.tif']);
    saveas(gcf,['./',fig_name,'.pdf']);

    hold off

else
    fprintf('�������������������ݣ�', 's')
end