function N = nbdfn(P1,P2,sigmat)
    dis = norm(P1-P2)^2;
    N = exp(-dis/(2*sigmat*sigmat));
end