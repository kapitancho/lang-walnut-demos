module demo-regexp:

getRegExp = ^ => RegExp :: RegExp('/\d(\d+)/');

fn = ^ => Any :: {
    tmp = type[String['help']];
    r1 = RegExp('/\d+/');
    r2 = RegExp('/sd.a/');
    r3 = getRegExp();
    u1 = Random()->uuid;
    u2 = Uuid('67c17642-2788-40e5-b07e-0198dabe63e4');
    u3 = Uuid('0123456789-0123456789-0123456789-abc');
    [r1, r2, r3, r3->matchString('1423'), r3->matchString('aasd'), u1, u2, u3]->printed
};

main = ^Array<String> => String :: fn()->printed;