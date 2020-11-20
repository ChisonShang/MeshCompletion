function [x3,y3]=constrained_expansion(direction, searchRad, trgPos, srcPos, optS)

a = direction(1);
b = direction(2);
c = direction(3);
d = direction(4);

x1 = trgPos(1);
y1 = trgPos(2);
x2 = srcPos(1);
y2 = srcPos(2);

nor = (10-optS.iLvl);
r = 2*(rand() - 1/2)*10*nor;

if(searchRad>=10*nor)
    if(a==0||c==0)
            difX = abs(x1 - x2);
            difY = abs(y1 - y2);
            if(difX>10*nor && difY>10*nor)
                if (difX <= difY)
                    x3 = x1 + r;
                    y3 = searchRad;
                else
                    x3 = searchRad;
                    y3 = y1 + r;
                end
            else
                x3 = x2;
                y3 = y2;
            end  

    else
        k1 = b/a;
        k2 = d/c;
        b1=(y1-k1*x1);
        b2=(y1-k2*x1);
        [dif1,~,~] = point_to_line(x2,y2,k1,b1);
        [dif2,~,~] = point_to_line(x2,y2,k2,b2);

            if(dif1>10*nor && dif2>10*nor)
                if (dif1 <= dif2)
                    x3 = x1 + sqrt(searchRad*searchRad - r*r/(1+k1*k1));
                    y3 = y1 + r/sqrt(1+k1*k1);
                else
                    x3 = x1 + k2*r/sqrt(1+k2*k2);
                    y3 = y1 + sqrt(searchRad*searchRad - k2*k2*r*r/(1+k2*k2));
                end
            else
                x3 = x2;
                y3 = y2;
            end
    end
else
    x3 = x2;
    y3 = y2;
end

function [dis,x0,y0] = point_to_line(x2,y2,k,b)

x0 =(x2/k+y2-b)/(k+1/k);
y0 = k*x0+b;
dis = sqrt((y2-y0)*(y2-y0)+(x2-x0)*(x2-x0));