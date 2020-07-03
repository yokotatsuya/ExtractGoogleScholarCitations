clear all;
close all;

user_id = 'ULYa42YAAAAJ'; % please change here

[Titles, Authors, Journals, Citations, name] = extractGSC(user_id);

hindex = sum(Citations' >= (1:length(Citations)));

fprintf('Targeted author: %s (h-index = %d) \n  \n',name,hindex);

fprintf('ID   Titles       Authors      Journals      Citations\n');
for n = 1:length(Titles)
    fprintf('%03d, ',n);
    fprintf('%.20s..., ',Titles{n});
    fprintf('%.10s..., ',Authors{n});
    fprintf('%.20s..., ',Journals{n});
    fprintf('%d \n',Citations(n));
end