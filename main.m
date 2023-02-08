x0s = [1, 0; 4, 0; 1, 3; -2, 0; 1, -3; 0, -1];
delta =1;
func = @(x)(testfunc(x));
criter = @(n, ~)(testctr(n, 100));
search(x0s, delta, func, criter, true)
