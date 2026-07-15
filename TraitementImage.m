classdef TraitementImage < matlab.apps.AppBase

    properties (Access = public)
        UIFigure        matlab.ui.Figure
        LeftPanel       matlab.ui.container.Panel
        RightPanel      matlab.ui.container.Panel
        TitreLabel      matlab.ui.control.Label
        ChargerButton   matlab.ui.control.Button
        TransformLabel  matlab.ui.control.Label
        TransformDD     matlab.ui.control.DropDown
        GammaLabel      matlab.ui.control.Label
        GammaField      matlab.ui.control.NumericEditField
        SeuilLabel      matlab.ui.control.Label
        SeuilField      matlab.ui.control.NumericEditField
        AppliquerBtn    matlab.ui.control.Button
        StatsTitre      matlab.ui.control.Label
        MoyLabel        matlab.ui.control.Label
        StdLabel        matlab.ui.control.Label
        MinLabel        matlab.ui.control.Label
        MaxLabel        matlab.ui.control.Label
        AxOrig          matlab.ui.control.UIAxes
        AxRes           matlab.ui.control.UIAxes
        AxHistOrig      matlab.ui.control.UIAxes
        AxHistRes       matlab.ui.control.UIAxes
    end

    properties (Access = private)
        imgOrig
        imgGray
    end

    methods (Access = private)

        function updateStats(app, img)
            if nargin < 2, img = app.imgGray; end
            if isempty(img), return; end
            g = double(img(:));
            app.MoyLabel.Text = sprintf('Moyenne    : %.2f', mean(g));
            app.StdLabel.Text = sprintf('Ecart-type : %.2f', std(g));
            app.MinLabel.Text = sprintf('Min        : %.2f', min(g));
            app.MaxLabel.Text = sprintf('Max        : %.2f', max(g));
        end

        function plotHisto(~, img, ax)
            cla(ax);
            data = double(img(:));
            histogram(ax, data, 64, ...
                'FaceColor',[0.2 0.5 0.8],'EdgeColor','none');
            ax.XLim = [0 255];
            ax.YLimMode = 'auto';
            ax.XLabel.String = 'Intensite';
            ax.YLabel.String = 'Pixels';
            ax.Box = 'off';
        end

        function res = applyTransform(app, choix)
            gray = app.imgGray;
            g    = double(gray)/255;
            switch choix
                case 'Image originale'
                    res = gray;
                case 'Gamma correction'
                    res = g .^ app.GammaField.Value;
                case 'Transformation log'
                    res = log(1+g)/log(2);
                case 'Transformation exp'
                    res = g.^2;
                case 'Etirement contraste'
                    mn = min(double(gray(:)));
                    mx = max(double(gray(:)));
                    res = (double(gray)-mn)/(mx-mn);
                case 'Egalisation histogramme'
                    [c,~] = histcounts(double(gray(:)),256);
                    cdf  = cumsum(c)/numel(gray);
                    res  = uint8(255*cdf(double(gray)+1));
                case 'Detection Sobel'
                    Kx = [-1 0 1;-2 0 2;-1 0 1];
                    Ky = [-1 -2 -1;0 0 0;1 2 1];
                    gx = conv2(double(gray),Kx,'same');
                    gy = conv2(double(gray),Ky,'same');
                    mg = sqrt(gx.^2+gy.^2);
                    res = mg/max(mg(:));
                case 'Segmentation OTSU'
                    [c,~] = histcounts(double(gray(:)),256);
                    prob  = c/sum(c);
                    om   = cumsum(prob);
                    mu   = cumsum(prob.*(1:256));
                    mu_t = mu(end);
                    sb   = (mu_t*om - mu).^2 ./ (om.*(1-om)+eps);
                    [~,idx] = max(sb);
                    thr  = (idx-1)/255;
                    app.SeuilField.Value = idx-1;
                    res  = double(gray)/255 > thr;
                case 'Seuillage manuel'
                    res = double(gray)/255 > (app.SeuilField.Value/255);
                otherwise
                    res = gray;
            end
        end

        % --- Callbacks ---
        function ChargerCB(app, ~)
            [f,d] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp;*.tif','Images'});
            if isequal(f,0), return; end
            app.imgOrig = imread(fullfile(d,f));
            if size(app.imgOrig,3)==3
                app.imgGray = rgb2gray(app.imgOrig);
            else
                app.imgGray = app.imgOrig;
            end
            imshow(app.imgGray,'Parent',app.AxOrig);
            app.AxOrig.Title.String = 'Image originale (gris)';
            app.plotHisto(app.imgGray, app.AxHistOrig);
            app.AxHistOrig.Title.String = 'Histogramme original';
            app.updateStats();
            cla(app.AxRes); cla(app.AxHistRes);
        end

        function AppliquerCB(app, ~)
            if isempty(app.imgGray)
                uialert(app.UIFigure,'Chargez une image d''abord.','Attention');
                return;
            end
            res = app.applyTransform(app.TransformDD.Value);
            imshow(res,[],'Parent',app.AxRes);
            app.AxRes.Title.String = ['Resultat : ' app.TransformDD.Value];
            if isa(res,'logical'), rh=uint8(res)*255;
            elseif max(res(:))<=1,  rh=uint8(res*255);
            else,                   rh=uint8(res); end
            app.plotHisto(rh, app.AxHistRes);
            app.AxHistRes.Title.String = 'Histogramme resultat';
            app.updateStats(rh);
        end

        function DropChangedCB(app, ~)
            v = app.TransformDD.Value;
            if strcmp(v,'Gamma correction')
                app.GammaField.Enable = 'on';
            else
                app.GammaField.Enable = 'off';
            end
            if strcmp(v,'Seuillage manuel')
                app.SeuilField.Enable = 'on';
            else
                app.SeuilField.Enable = 'off';
            end
        end

        % --- Build UI ---
        function buildUI(app)
            % Figure
            app.UIFigure = uifigure('Name','Traitement Image',...
                'Position',[80 60 1200 720],'Color',[0.95 0.95 0.97]);

            % Panel gauche
            app.LeftPanel = uipanel(app.UIFigure,'Position',[0 0 240 720],...
                'BackgroundColor',[0.12 0.22 0.42],'BorderType','none');

            % Titre
            app.TitreLabel = uilabel(app.LeftPanel,'Position',[10 665 220 44],...
                'Text','Traitement d''Image',...
                'FontSize',13,'FontWeight','bold','FontColor',[1 1 1],...
                'HorizontalAlignment','center');

            % Bouton charger
            app.ChargerButton = uibutton(app.LeftPanel,'push',...
                'Position',[10 615 220 36],'Text','  Charger une image',...
                'FontSize',12,'FontWeight','bold',...
                'BackgroundColor',[0.15 0.55 0.85],'FontColor',[1 1 1],...
                'ButtonPushedFcn',@(b,e)app.ChargerCB(e));

            % Label transformation
            app.TransformLabel = uilabel(app.LeftPanel,'Position',[10 580 220 20],...
                'Text','TRANSFORMATION','FontSize',10,'FontWeight','bold',...
                'FontColor',[0.65 0.82 1]);

            % DropDown
            app.TransformDD = uidropdown(app.LeftPanel,...
                'Position',[10 548 220 28],...
                'Items',{'Image originale','Gamma correction','Transformation log',...
                         'Transformation exp','Etirement contraste',...
                         'Egalisation histogramme','Detection Sobel',...
                         'Segmentation OTSU','Seuillage manuel'},...
                'FontSize',11,...
                'ValueChangedFcn',@(dd,e)app.DropChangedCB(e));

            % Gamma
            app.GammaLabel = uilabel(app.LeftPanel,'Position',[10 516 130 20],...
                'Text','Valeur gamma (g)','FontSize',10,'FontColor',[0.8 0.9 1]);
            app.GammaField = uieditfield(app.LeftPanel,'numeric',...
                'Position',[145 516 85 24],'Value',0.5,...
                'Limits',[0.1 5],'Enable','off');

            % Seuil
            app.SeuilLabel = uilabel(app.LeftPanel,'Position',[10 486 130 20],...
                'Text','Seuil (0-255)','FontSize',10,'FontColor',[0.8 0.9 1]);
            app.SeuilField = uieditfield(app.LeftPanel,'numeric',...
                'Position',[145 486 85 24],'Value',128,...
                'Limits',[0 255],'Enable','off');

            % Bouton appliquer
            app.AppliquerBtn = uibutton(app.LeftPanel,'push',...
                'Position',[10 444 220 36],'Text','  Appliquer',...
                'FontSize',12,'FontWeight','bold',...
                'BackgroundColor',[0.08 0.62 0.36],'FontColor',[1 1 1],...
                'ButtonPushedFcn',@(b,e)app.AppliquerCB(e));

            % Stats titre
            app.StatsTitre = uilabel(app.LeftPanel,'Position',[10 408 220 20],...
                'Text','STATISTIQUES','FontSize',10,'FontWeight','bold',...
                'FontColor',[0.65 0.82 1]);

            % Stats labels
            names  = {'MoyLabel','StdLabel','MinLabel','MaxLabel'};
            defTxt = {'Moyenne    : ---','Ecart-type : ---','Min        : ---','Max        : ---'};
            for i=1:4
                app.(names{i}) = uilabel(app.LeftPanel,...
                    'Position',[10 408-28*i 220 22],...
                    'Text',defTxt{i},'FontSize',10,...
                    'FontName','Courier New','FontColor',[0.88 0.94 1]);
            end

            % Panel droit
            app.RightPanel = uipanel(app.UIFigure,'Position',[240 0 960 720],...
                'BackgroundColor',[0.97 0.97 0.99],'BorderType','none');

            % 4 axes
            app.AxOrig     = uiaxes(app.RightPanel,'Position',[10  375 455 330]);
            app.AxRes      = uiaxes(app.RightPanel,'Position',[490 375 455 330]);
            app.AxHistOrig = uiaxes(app.RightPanel,'Position',[10  15  455 340]);
            app.AxHistRes  = uiaxes(app.RightPanel,'Position',[490 15  455 340]);

            for ax = [app.AxOrig app.AxRes]
                ax.XTick=[]; ax.YTick=[];
            end
            app.AxOrig.Title.String     = 'Image originale';
            app.AxRes.Title.String      = 'Image resultat';
            app.AxHistOrig.Title.String = 'Histogramme original';
            app.AxHistRes.Title.String  = 'Histogramme resultat';

            % Initialiser les axes histogramme
            for ax = [app.AxHistOrig app.AxHistRes]
                ax.XLabel.String = 'Intensite';
                ax.YLabel.String = 'Pixels';
                ax.Box = 'off';
            end

            app.UIFigure.Visible = 'on';
        end
    end

    methods (Access = public)
        function app = TraitementImage()
            buildUI(app);
            registerApp(app, app.UIFigure);
            if nargout == 0, clear app; end
        end
        function delete(app)
            delete(app.UIFigure)
        end
    end
end