module cast202 %% http-core:

myFn = ^Array<String> => Any :: {
    a = HttpProtocolVersion.HTTP1
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};