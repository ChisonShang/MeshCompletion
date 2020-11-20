function [bestline]=cal_ransac(data)
 iter = 100; 

 number = size(data,2); % total number of points
 sigma = 1;
 pretotal=0;     %

 for i=1:iter
 %select ranodm two points
     idx = randperm(number,2); 
     sample = data(:,idx); 

     %cal linear equation y=kx+b
     line = zeros(1,3);
     x = sample(:, 1);
     y = sample(:, 2);

     k=(y(1)-y(2))/(x(1)-x(2));
     b = y(1) - k*x(1);
     line = [k -1 b];

     mask=abs(line*[data; ones(1,size(data,2))]);    %disatance between every points to line
     total=sum(mask<sigma);              %number of points under the setted threshold

     if total>pretotal            
         pretotal=total;
         bestline=line;          %find the best matched line
    end  
 end