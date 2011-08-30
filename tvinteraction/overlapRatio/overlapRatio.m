

function ratio = overlapRatio(BoundingBoxA, BoundingBoxB, siz)
if ~any(BoundingBoxA) || ~any(BoundingBoxB)
    ratio = 0;
else    
    BoundingBoxA = checkValidate(BoundingBoxA, 'BoundingBox', siz);
    BoundingBoxB = checkValidate(BoundingBoxB, 'BoundingBox', siz);
    suba = BB2sub(BoundingBoxA);
    subb = BB2sub(BoundingBoxB);
    inda = sub2ind(siz, suba(:, 1), suba(:, 2));
    indb = sub2ind(siz, subb(:, 1), subb(:, 2));

    c = intersect(inda, indb);

    ratio = length(c) / (length(inda) + length(indb) - length(c));
end
