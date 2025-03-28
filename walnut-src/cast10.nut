module cast10:
/* this is a test module */
PositiveInteger = Integer<1..>;

callMe = ^[a: Integer, b: Real] => Real :: #a + #b;

myFn = ^args: Array<String> => Any :: {
    ?whenTypeOf(args) is {
        type{Array<String, 2..>}: {
            x = args.0=>as(`Integer);
            y = args.1=>as(`Real);
            callMe[x, y]
        },
        ~: 0
    }
};

main = ^args: Array<String> => String :: {
    x = myFn(args);
    x->printed
};