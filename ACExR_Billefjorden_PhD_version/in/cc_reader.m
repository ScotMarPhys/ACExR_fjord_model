clear all; close all;
load CC_10YR_AIRPORT

var1 = CC(1:4:14600);
var2 = CC(2:4:14601);
var3 = CC(3:4:14602);
var4 = CC(4:4:14603);


V_all = [var1  var2  var3  var4];

Year    = Y(1:4:end);
Month   = M(1:4:end);
Day     = D(1:4:end);
cc_day  = nanmean(V_all,2);


mnth = [1:12];
yr   = [min(min(Y)):max(max(Y))];

mat = vec2mat(cc_day,10);

mat = nanmean(mat,2);

mat = repmat(mat,51,1);
 