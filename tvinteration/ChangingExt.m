function ChangingExt
dExt = 'txt'; % dExt stands for Destination Ext
for i = 0 : 3
    [srcdirA filenamesA] = rfdatabase(datadir_interaction(i, 'tvinteractionAnnotation'), [], '.annotations');
    for j = 1 : length(filenamesA)
        comm = ['!mv ' srcdirA filenamesA{j} ' ' srcdirA filenamesA{j}(1:end - 12) '.' dExt];
        eval(comm);
    end
end
