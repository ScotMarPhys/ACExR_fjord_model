clear all; close all;
Read_txt_file_wind_data

wnd1 = V(1:4:end);
wnd2 = V(2:4:end);
wnd3 = V(3:4:end);
wnd4 = V(4:4:end);


V_all = [wnd1  wnd2  wnd3  wnd4];

Year    = Year(1:4:end);
Month   = Month(1:4:end);
Day     = Day(1:4:end);
v_day   = nanmean(V_all,2);


mnth = [1:12];
yr   = [2006:2015];

jan = nan(1,12);

for i = 1:length(yr)
    
for ii = 1:length(mnth)
    
    
end

end