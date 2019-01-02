%细胞毒性数据处理
%文件命名：cellviability.xls
%程序设计：龚林吉  gonglinji@outlook.com

clear all;
clc;
data = xlsread('cellviability.xls'); %读入原始数据
[m,n] = size(data); %原始数据矩阵大小
averge = mean(data); %平均值
standard_deviation = std(data, 0, 1); %标准差

%计算误差传递
errbar = [ ];
for i = 1:n-1
    errbar(i) = standard_deviation(i+1)/...
                  (averge(2)-averge(1))*100;
    i = i+1;
end
errbar;

%计算细胞存活率
cell_viability = [ ];
for i = 1:n-1
    cell_viability(i) = (averge(i+1)-averge(1))/...
                           (averge(2)-averge(1))*100;
    i=i+1;
end
cell_viability;

%输入材料最高浓度和细胞类型
concentration = double(input('请输入最高浓度：'));
dilution = input('浓度按倍半稀释(Y/N)：', 's');
if 'Y' == dilution
    celltype = input('请输入细胞类型：', 's');
    NPs = input('请输入材料名称：', 's');
    fig_name = input('请输入保存图片名称：','s');

    %计算每组浓度，倍半稀释
    group = [ ];
    group(1) = 0; %定义Control组浓度
    for i = 2:n-1
        group(i) = concentration/(2^(n-i-1)); 
    end
    group;

    group = string(group); %设置X轴显示
    group(1) = "Control"; %设置Control组X轴显示

    %绘制细胞存活率直方图
    bar = bar(1:n-1, cell_viability);
    bar.EdgeColor = [0,0,0];
    bar.LineStyle = 'none';
    hold on

    %添加细胞存活率误差棒
    er = errorbar(1:n-1, cell_viability, errbar);
    er.Color = [0 0 0];
    er.LineStyle = 'none'; %er.LineWidth=1;
    hold on

    %设置图注和坐标轴标注
    legend(string(celltype),'FontSize',12, 'box','off')
    xlabel(['Concentration of ', NPs, ' (μg/mL)'])
    ylabel('Cell viability (%)')
    
    set(gca, 'FontSize', 12);  %坐标轴字体大小
    set(get(gca,'XLabel'),'Fontsize',16);
    set(get(gca,'YLabel'),'Fontsize',16);
    set(gca,'looseInset',[0 0 0 0]); %去界面白边
    set(gca,'XTickLabel',group); %设置设置X轴显示
    set(gcf, 'color', [1 1 1]); %将窗口底色设为白色
    set(gcf,'color','white'); %将窗口底色设为白色

    saveas(gcf,['./',fig_name,'.eps']);%自动保存
    saveas(gcf,['./',fig_name,'.png']);
    saveas(gcf,['./',fig_name,'.tif']);
    saveas(gcf,['./',fig_name,'.pdf']);

    hold off

else
    fprintf('本程序不适用于您的数据！', 's')
end