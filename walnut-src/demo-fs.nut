module demo-fs %% fs:

test = ^Any => Any :: {
    f = File['../walnut-src/openapi.json'];
    f=>content=>jsonDecode
};

main = ^Array<String> => String :: [
    test()
]->printed;