function [Igrowth] = ContinuingGrowth(FT, Inew)

% Global variables
global LochData SillData Hypso Bdata Const D E Param
 
day     = Param.day;
airtemp = Bdata.Tair(day) ;
ro_ice  = Const.RhoIce ;
l_ice   = Const.LIce;
c_ice   = Const.IceCond;
n_step  = Const.deltaT;
frac_day = n_step/(60*60*24)


    
Igrowth = -(6.55*0 + 8.4) + sqrt((6.55*0+8.4)*(6.55*0+8.4)+12.9*fdd)    


end