clear all;

infile = 'ISA_2005_2065_ex14';
load(infile);

% first reduce the data set to start at 2012

[id idx] = find(year==2012);

strt = min(id);

year    = year(strt:end);
month   = month(strt:end);
day     = day(strt:end);
depth   = depth(strt:end);
S       = S(strt:end);
T       = T(strt:end);

% predicted temp increase
temp_change = [0:0.1:0.1*((max(max(year-2012))))] 

% Number of years
yrs         = unique(year);
yr_rnge     = [min(min(yrs)):1:max(max(yrs))];

% update the dataset with LOW impact increase
for i = 1:length(yrs)
    [ids idx]       = find(year==yr_rnge(i));
    T(ids,1)          = T(ids,1)+temp_change(i);
end

save ISA_2012_2065_HIGH year month day depth S T