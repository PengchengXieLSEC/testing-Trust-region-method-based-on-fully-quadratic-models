%Trust-region method based on fully quadratic models
%Copyright: Pengcheng Xie
%xpc@lsec.cc.ac.cn


function search(x0s, delta, func, criter, level)
    % init search function
    fs = zeros(length(x0s), 1);
    for idx = 1:length(x0s)
        fs(idx) = func(x0s(idx, :));
    end
    [fmin, jdx] = min(fs);
    xs = x0s;
    n = 1;
    delta0 = delta;
    % main loop
    while (criter(n, fmin))
        % log debug info
        if (level)
            disp(['[#', num2str(n), ']:'])
            disp(['min point:', mat2str(xs(jdx, :))])
            disp(['current points:', mat2str(xs)])
        end
        % interplotation
        [hess, grad, ~] = qdtintlp(xs, fs);
        % log debug info
        if (level)
            disp(['curr g: ', mat2str((grad + hess * xs(jdx, :)')')])
            disp(['curr G: ', mat2str(hess)])
        end
        % get next point
        [deltax, ~, ~, ~] = tCG(xs(jdx, :)', grad + hess * xs(jdx, :)', hess, delta, {});
        xnew = xs(jdx, :) + deltax';
        fnew = func(xnew);
        % log debug info
        if (level)
            disp(['curr delta: ', num2str(delta), ' curr eta: ', num2str(deltax')])
            disp(['curr xnew: ', mat2str(xnew), ' curr fnew: ', num2str(fnew)])
        end
        % find max f value
        [fmax, kdx] = max(fs);
        if (fmax < fnew)
            kdx = 0;
        end
        % if succeed
        if (kdx)
            % set new xs for interplotation
            xs(kdx, :) = xnew;
            fs(kdx) = fnew;
            % find current min
            [fmin, jdx] = min(fs);
            % reset delta
            delta = delta0;
        % if failed
        else
            delta = delta / 2;
        end
        % log debug info
        if (level)
            disp(['current min function value: ', num2str(fmin)])
        end
        % increase n
        n = n + 1;
    end
end
