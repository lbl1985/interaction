function cuboidsDetect(Type, Clip)
[srcdirI filenamesI] = rfdatabase(datadir_interaction(Type, 'tvinteraction'), [], '.avi');
% [srcdirA filenamesA] = rfdatabase(datadir_interaction(Type, 'tvinteractionAnnotation'), [], '.txt');
filename = [srcdirI filenamesI{Clip}]; outName = './sample.txt';
% filenameA = [srcdirA filenamesA{Clip}];

mat = movie2var(filename, 1, 1);
close all;
[R,subs,vals,cuboids,V] = stfeatures( mat, 2, 3, 1, 2e-3, [], 1.85, 2, 1, 1 );
figure;
playM_asVideo(R);