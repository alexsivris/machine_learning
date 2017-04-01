classdef LSR
    %LSR Summary of this class goes here
    %   Detailed explanation goes here
    properties (Access = private)
        INPUT;
        OUTPUT;
        X1; %for x,y
        X2; %for theta
        outX;
        outY;
        outTheta;
        Y;
        n;
        p1;
        p2;
    end
    properties (Access = public)
        A;
    end
    
    methods
        function obj = LSR(in,out,range,p1,p2)
            obj.n=range;
            obj.INPUT=in;
            obj.OUTPUT=out;
            obj.outX = [out(1,range)'];
            obj.outY = [out(2,range)'];
            obj.outTheta = [out(3,range)'];
            obj.p1=p1;
            obj.p2=p2;
            obj.X1 = [ones(length(range),1) in(1,range)' in(2,range)'  in(1,range)'.*in(2,range)'];
            obj.X2 = [ones(length(range),1) in(1,range)' in(2,range)'  in(1,range)'.*in(2,range)'];
            switch obj.p1
                case 2
                    obj.X1 = [obj.X1 (obj.X1(:,2:end)).^2];
                case 3
                    obj.X1 = [obj.X1 (obj.X1(:,2:end)).^2 (obj.X1(:,2:end)).^3 ];
                case 4
                    obj.X1 = [obj.X1 (obj.X1(:,2:end)).^2 (obj.X1(:,2:end)).^3 (obj.X1(:,2:end)).^4];
                case 5
                    obj.X1 = [obj.X1 (obj.X1(:,2:end)).^2 (obj.X1(:,2:end)).^3 (obj.X1(:,2:end)).^4 (obj.X1(:,2:end)).^5];
                case 6
                    obj.X1 = [obj.X1 (obj.X1(:,2:end)).^2 (obj.X1(:,2:end)).^3 (obj.X1(:,2:end)).^4 (obj.X1(:,2:end)).^5 (obj.X1(:,2:end)).^6];
                otherwise
                    obj.X1 = [ones(length(range),1) in(1,range)' in(2,range)'  in(1,range)'.*in(2,range)'];
            end
            switch obj.p2
                case 2
                    obj.X2 = [obj.X2 (obj.X2(:,2:end)).^2];
                case 3
                    obj.X2 = [obj.X2 (obj.X2(:,2:end)).^2 (obj.X2(:,2:end)).^3 ];
                case 4
                    obj.X2 = [obj.X2 (obj.X2(:,2:end)).^2 (obj.X2(:,2:end)).^3 (obj.X2(:,2:end)).^4];
                case 5
                    obj.X2 = [obj.X2 (obj.X2(:,2:end)).^2 (obj.X2(:,2:end)).^3 (obj.X2(:,2:end)).^4 (obj.X2(:,2:end)).^5];
                case 6
                    obj.X2 = [obj.X2 (obj.X2(:,2:end)).^2 (obj.X2(:,2:end)).^3 (obj.X2(:,2:end)).^4 (obj.X2(:,2:end)).^5 (obj.X2(:,2:end)).^6];
                otherwise
                    obj.X2 = [ones(length(range),1) in(1,range)' in(2,range)'  in(1,range)'.*in(2,range)'];
            end
        end
        function X = getX(obj, range, number)
            in = obj.INPUT;
            X1 = [ones(length(range),1) in(1,range)' in(2,range)'  in(1,range)'.*in(2,range)'];
            X2 = [ones(length(range),1) in(1,range)' in(2,range)'  in(1,range)'.*in(2,range)'];
            switch obj.p1
                case 2
                    X1 = [X1 (X1(:,2:end)).^2];
                case 3
                    X1 = [X1 (X1(:,2:end)).^2 (X1(:,2:end)).^3 ];
                case 4
                    X1 = [X1 (X1(:,2:end)).^2 (X1(:,2:end)).^3 (X1(:,2:end)).^4];
                case 5
                    X1 = [X1 (X1(:,2:end)).^2 (X1(:,2:end)).^3 (X1(:,2:end)).^4 (X1(:,2:end)).^5];
                case 6
                    X1 = [X1 (X1(:,2:end)).^2 (X1(:,2:end)).^3 (X1(:,2:end)).^4 (X1(:,2:end)).^5 (X1(:,2:end)).^6];
                otherwise
                    X1 = [ones(length(range),1) in(1,range)' in(2,range)'  in(1,range)'.*in(2,range)'];
            end
            switch obj.p2
                case 2
                    X2 = [X2 (X2(:,2:end)).^2];
                case 3
                    X2 = [X2 (X2(:,2:end)).^2 (X2(:,2:end)).^3 ];
                case 4
                    X2 = [X2 (X2(:,2:end)).^2 (X2(:,2:end)).^3 (X2(:,2:end)).^4];
                case 5
                    X2 = [X2 (X2(:,2:end)).^2 (X2(:,2:end)).^3 (X2(:,2:end)).^4 (X2(:,2:end)).^5];
                case 6
                    X2 = [X2 (X2(:,2:end)).^2 (X2(:,2:end)).^3 (X2(:,2:end)).^4 (X2(:,2:end)).^5 (X2(:,2:end)).^6];
                otherwise
                    X2 = [ones(length(range),1) in(1,range)' in(2,range)'  in(1,range)'.*in(2,range)'];
            end
            if (number == 2)
                X = X2;
            else
                X = X1;
            end
        end
        
        
        function a = TrainingX(obj)
            a = (obj.X1' * obj.X1) \ obj.X1' * obj.outX;
        end
        function a = TrainingY(obj)
            a = (obj.X1' * obj.X1) \ obj.X1' * obj.outY;
        end
        function a = TrainingTheta(obj)
            a = (obj.X2' * obj.X2) \ obj.X2' * obj.outTheta;
        end
        function pe = PositionErrorXY(obj,params,params2,block)
            X = obj.getX(block,1);
            predX = X * params;
            predY = X * params2;
            x_err = (obj.OUTPUT(1,block) - predX').^2;
            y_err = (obj.OUTPUT(2,block) - predY').^2;
            pe = sum((x_err + y_err).^(1/2))/ length(block);
        end
        function oe = OrientationError(obj,params, block)
            X = obj.getX(block,2);
            predTheta = X * params;
            theta_err = (obj.OUTPUT(3,block) - predTheta').^2;
            oe =  sum((theta_err).^(1/2))/ length(block);
        end
    end
end

