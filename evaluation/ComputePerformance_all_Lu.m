%====================================================================
% �������á�
%   �ο�Prasad���۷���������Fֵ��------����Arc�������ݷֱ�ΪTraffic=0.8958��Prasad=0.4781��PCB=0.9447��
%   ����ĳ���ݼ��ļ��������*.mat�ļ���
%   Ellipses_*.mat�ļ��д洢���Ǵ����ݼ���ÿ��ͼƬ��������Բ��(ÿ��Ԫ�ض�Ӧһ��)��
%   ����ÿ��ͼƬ�ļ����Բ���Ͳ�����Բ�����ص������������Fֵ��
%   �������ÿ��ͼƬ��Fֵ (�ۼ� / n) ���ƽ��ֵ����Ϊ�������ݼ���Fֵ��
%====================================================================
%====================================================================
% �������۷������Ƽ�ʹ��A1-Lu�����۷�������ӦLu��񻯲���������ݼ�
% 	'A1'����Lu-Arc���۷�������TP�ۼӷ����ֱ��кͰ���ͳ��TP��������TP��FN��FP�ۼӺ����Fֵ��
% 	'B2'����Jia-TIP���۷�����ͬTPƽ������ͳһ����ͳ��TP�����������ÿ��ͼ��Fֵ������ƽ��ֵ��
%====================================================================


%% ͳ��ĳ���ݼ���Ӧ��GT��Test����Բ����
% dataset = 'Dataset#2';
% files=dir(['./datasets/', dataset, '/gt/*.txt']); %���
% path_GT=(['./datasets/', dataset, '/gt/']); %���
% for f=1:length(files)
%     file_GT=[path_GT files(f).name];
%     data = importdata(file_GT); 
%     ellipse_param = reshape(data(2:end),5,data(1));
%     count(f) = data(1);
% end
% disp(sum(count));
%%====================================================================


% clear all; close all; clc;
function [resultFM, Precision, Recall] = ComputePerformance_all_Lu(selectEveFun)
    %%

%     ѡ�����۵����ݼ������·���������ض�Ӧĳ���ݼ��ļ��������*.mat�ļ� / ���ߴ��¼�����ɵ�det_*.txt�ļ��ж�ȡ�����Բ��������
     dataset = 'ged';  % Dataset#2��Dataset#1��Calibration
%     dataset = 'Prasad_plus';%Prasad Dataset��Prasad_plus
%     dataset = 'ged';%Prasad Dataset��Prasad_plus, new_traffic,new_ged
%     dataset = 'Industrial PCB Image Dataset';
%     dataset = 'Traffic Sign Dataset';
    files=dir(['./datasets/', dataset, '/gt0/*.txt']); %���
    path_GT=(['./datasets/', dataset, '/gt0/']); %���
%     % ��*.mat�ļ��м��ؼ����Բ������
%     load(['./evaluation/results_ԭ/', dataset, '/Ellipses_CNC.mat']); % ��Բ�ͬ���㷨�в�ͬ��Ellipses_*.mat�ļ���Ellipses_lcs.mat��Ellipses_prasad.mat��Ellipses_rht.mat
%     algoParamTmp = Ellipses_CNC;
    % ��     
    filesDet=dir(['./datasets/', dataset, '/arcsl-oneStage-RDETR_KFLoss/50thEpoch/det/*.txt']);
    path_Det=(['./datasets/', dataset, '/arcsl-oneStage-RDETR_KFLoss/50thEpoch/det/']);
    
    % ��׼Բ�Ͳ���Բ�ص���������ֵ
    %for bi = 0 : 6
    %beta=0.65+bi*0.05;  %0.8
    beta = 0.8;
    % ѡ�����۷������ͣ�selectFun = 'A1'����A1��Lu-Arc���۷�����selectFun = 'B2'����B2��Jia-TIP���۷�����
    if nargin < 1
        selectEveFun = 'A1';   % 'A1' / 'B2'
    end
    disp(selectEveFun);
    
    % ����ĳ���ݼ�GroundTruth��ÿ��txt�ļ�������׼��Բ��
    for f=1:length(files)	% length(files)/5
        % file_GT����ǰgt_*.txt�ļ�������ӦĳͼƬ�ı�׼��Բ�������������Ͳ�����Բ���Ա��ص��̶�
        file_GT=[path_GT files(f).name];
        %load(file_GT);

        % ���ص�ǰgt�ļ������׼��Բ�����ݣ�����ĳͼƬ��������Բ����+ÿ����Բ�������������ÿ����Բ�������ֵ��(5 X size)�ľ���ellipse_param�У���ÿ��Ϊһ����Բ
        %load(file_GT);
        data = importdata(file_GT); %loading the ground true datas. first data is the number of ellipses, while others are elliptic parameters.
        ellipse_param = reshape(data(2:end),5,data(1));%reshape to 5 x n, each column is 5 x 1,(cx,cy,a,b,theta_rad)
        %========================================================
        %show detected ellipses and gt ellipses.
        %path_img = 'D:\Graduate Design\Method comparing 2\Ellipse datasets\Industrial PCB Image Dataset\images\';
        %[path_string,name,ext] = fileparts(files(f).name);
        %im = imread([path_img, name, '.bmp']);
        %det_param = Param_det_cells{6, 1}{f};%detected ellipses
        %drawEllipses(det_param,im,'r');
        %drawEllipses(ellipse_param,im,'g');
        %========================================================

        % ��ĳͼƬ�ı�׼��Բ��cx�������У�������ÿ��Ϊһ����Բ�����������������˳���Ϊ(a,b,x,y,phi)
        ellipse_param=sortrows(ellipse_param.').';
        ellipse_param=ellipse_param([3 4 1 2 5],:); %���䣬�������ǱȽ�������Բ�ĸ�ʽ��(a,b,x,y,phi)
        % // TODO��Դ�����ʽΪ[3 4 2 1 5]������ע��˵����һ�£��ʸ�Ϊ[3 4 1 2 5]���������֪��ʽһ�º������΢��������ʵ���߲���Ӧ��Ӱ�첻��ɣ�
        
 %        det_param = algoParamTmp{f};
        % file_Det����ǰDet_*.txt�ļ�������ӦĳͼƬ�Ĳ�����Բ�������������ͱ�׼��Բ���Ա��ص��̶�
        file_Det=[path_Det filesDet(f).name];
%         disp(file_Det);	% �����ǰ���۵����ĸ�ͼƬ
        % ���ص�ǰdet�ļ����������Բ�����ݣ�����ĳͼƬ��������Բ����+ÿ����Բ�������������ÿ����Բ�������ֵ��(5 X size)�ľ���det_param�У���ÿ��Ϊһ����Բ
        data2 = importdata(file_Det); %loading the ground true datas. first data is the number of ellipses, while others are elliptic parameters.
        det_param = reshape(data2(2:end),5,data2(1));%reshape to 5 x n, each column is 5 x 1,(cx,cy,a,b,theta_rad)
        % ����ͼƬ�ı�׼��Բ�������Բ������Ϊ0����FֵΪ0
        if size(det_param,2) == 0 || size(ellipse_param,2) == 0
            TP(f) = 0;
            FN(f) = size(ellipse_param,2)-TP(f);
            FP(f) = 0;
            % FMeasure(f) = 0;
            continue;
        end

        % ��������Բ��cx�������У�������ÿ��Ϊһ����Բ�����������������˳���Ϊ(a,b,x,y,phi)
        det_param=sortrows(det_param.').';
        det_param=det_param([3 4 1 2 5],:); %���䣬�������ǱȽ�������Բ�ĸ�ʽ��(a,b,x,y,phi)
        % // TODO��Դ�����ʽΪ[3 4 2 1 5]������ע��˵����һ�£��ʸ�Ϊ[3 4 1 2 5]���������֪��ʽһ�º������΢��������ʵ���߲���Ӧ��Ӱ�첻��ɣ�
        %     [gt,det]=meshgrid(1:size(ellipse_param,2),1:size(det_param,2));

        % ������׼��Բ����������ǰ��׼Բ��ÿ������Բ(����)�Ƚϣ����ȽϽ������Overlap�����Ӧλ��---������ߵ��ص�������
        Overlap = zeros(size(ellipse_param,2),size(det_param,2)); %�洢M X N ��
        for ii=1:size(ellipse_param,2)
            for jj=1:size(det_param,2)
                max_x=max(ellipse_param(3,ii)+ellipse_param(1,ii),det_param(3,jj)+det_param(1,jj));
                max_y=max(ellipse_param(4,ii)+ellipse_param(1,ii),det_param(4,jj)+det_param(1,jj));
                Overlap(ii,jj)=check_overlap1(ellipse_param(:,ii),det_param(:,jj),[max_x,max_y]+5);
            end
        end
        
        % // TODO���������зֿ�ͳ�Ƶģ�����˼���Ͼ��ǲ��Եģ�c��TP��һ�£��ֱ���ͳ�� / ����ͳ�ƣ��Ҽ���ʱҲ�ֱ�ʹ��TP
        % Precision(f)=sum(max(Overlap,[],1)>beta)/size(det_param,2); % ͳ��ÿ��������ص����� > beta�ı�����������������Բ��������׼ȷ��
        % Recall(f)=sum(max(Overlap,[],2)>beta)/size(ellipse_param,2); % ͳ��ÿ��������ص����� > beta�ı��������������׼��Բ���������ٻ���
        % if Precision(f) == 0 || Recall(f) == 0
        %     FMeasure(f) = 0;
        % else
        %     FMeasure(f) = 2*Precision(f)*Recall(f) / (Precision(f) + Recall(f));
        % end
        
        if selectEveFun == 'A1'
            % ���ݴ�ͼƬ��׼Բ�Ͳ���Բ���ص������������ͼƬ��Ӧ��TP��FP��FN��������a��TP��һ�£��ֱ���ͳ�� / ����ͳ�ƣ�������ʱȫ��ʹ�ð���ͳ�Ƶ�TP
            TP(f) = sum(max(Overlap,[],2)>beta);
            FN(f) = size(ellipse_param,2)-TP(f);
            FP(f) = size(det_param,2)-sum(max(Overlap,[],1)>beta);	% a��b����֮��
        end
        if selectEveFun  == 'B2'
            % ���ݴ�ͼƬ��׼Բ�Ͳ���Բ���ص������������ͼƬ��Ӧ��TP��FP��FN��������b��TPһ�£�ȫ������ͳ�ƣ�����ʱ��ȻҲȫ��ʹ�ð���ͳ�Ƶ�TP
            TP(f) = sum(max(Overlap,[],2)>beta);
            FN(f) = size(ellipse_param,2)-TP(f);
            FP(f) = size(det_param,2)-TP(f);    % a��b����֮��
        end
        
        clear Overlap
    end

    if selectEveFun  == 'A1'
        % ��1����ʽ+ a����ʽ = Lu���۷�����
        % 1�����㲢���ĳ���ݼ�������Fֵ�������е�TP��FP��FN�ۼӺ�����ܵ�Precision��Recall����2*Precision*Recall / (Precision + Recall) = �ܵ�Fֵ
        TPs = sum(TP, 2);
        FPs = sum(FP, 2);
        FNs = sum(FN, 2);
        if TPs == 0
            Precision = 0;
            Recall = 0;
            resultFM = 0;
        else
            Precision = TPs / (TPs + FPs);
            Recall = TPs / (TPs + FNs);
            resultFM = 2*Precision*Recall / (Precision + Recall);
        end
    end
    if selectEveFun  == 'B2'
        % ��2����ʽ + b����ʽ = Jia���۷�����
        % 2�����㲢���ĳ���ݼ�������Fֵ����ÿ��ͼƬ��TP��FP��FN�����Fֵ���ٽ�����Fֵ�ۼ� / ͼƬ���� = �ܵ�ƽ��Fֵ
        for f=1:length(files)
            if TP(f) == 0
                PrecisionArr(f) = 0;
                RecallArr(f) = 0;
                FMeasure(f) = 0;
            else
                PrecisionArr(f) = TP(f) / (TP(f) + FP(f));
                RecallArr(f) = TP(f) / (TP(f) + FN(f));
                FMeasure(f) = 2*PrecisionArr(f)*RecallArr(f) / (PrecisionArr(f) + RecallArr(f));
            end
        end
        Precision = sum(PrecisionArr, 2) ./ size(PrecisionArr, 2);
        Recall = sum(RecallArr, 2) ./ size(RecallArr, 2);
        resultFM = sum(FMeasure, 2) ./ size(FMeasure, 2);
    end
     disp([dataset, '_���յ�����ֵ��[pre=', num2str(Precision), ']��[re=', num2str(Recall), ']��[f-m=', num2str(resultFM), ']']);
    
    %==================================================================
    % for iAlgo = 1:6
    %     TPs(iAlgo, bi+1) = sum(TP(iAlgo, :));
    %     FPs(iAlgo, bi+1) = sum(FP(iAlgo, :));
    %     FNs(iAlgo, bi+1) = sum(FN(iAlgo, :));
    %     if (TPs(iAlgo, bi+1)+FPs(iAlgo, bi+1)) == 0
    %         Precision(iAlgo, bi+1) = 1;
    %     else
    %         Precision(iAlgo, bi+1) =  TPs(iAlgo, bi+1)/( TPs(iAlgo, bi+1)+ FPs(iAlgo, bi+1));  %׼ȷ��
    %     end
    %     if ( TPs(iAlgo, bi+1)+ FNs(iAlgo, bi+1)) == 0
    %         Recall(iAlgo, bi+1) = 1;
    %     else
    %         Recall(iAlgo, bi+1)    = TPs(iAlgo, bi+1)/( TPs(iAlgo, bi+1)+ FNs(iAlgo, bi+1));  %�ٻ���
    %     end
    %     FMeasure(iAlgo, bi+1)  = 2*Precision(iAlgo, bi+1)*Recall(iAlgo, bi+1)/(Precision(iAlgo, bi+1)+Recall(iAlgo, bi+1));
    % end
    %end

    % output_pathroot = ['.././', dataset, '/']; %���
    % save(strcat(output_pathroot, 'TPs.mat'),'-mat', 'TPs'); %���
    % save(strcat(output_pathroot, 'FPs.mat'),'-mat', 'FPs'); %���
    % save(strcat(output_pathroot, 'FNs.mat'),'-mat', 'FNs'); %���
    % save(strcat(output_pathroot, 'Precision.mat'),'-mat', 'Precision'); %���
    % save(strcat(output_pathroot, 'Recall.mat'),'-mat', 'Recall'); %���
    % save(strcat(output_pathroot, 'FMeasure.mat'),'-mat', 'FMeasure'); %���
	%==================================================================
end
