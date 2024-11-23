module cast10:
/* this is a test module */
PositiveInteger = Integer<1..>;

callMe = ^[a: Integer, b: Real] => Real :: #.a + #.b;

myFn = ^Array<String> => Any :: {
    ?whenTypeOf(#) is {
        type{Array<String, 2..>}: {
            x = ?noError({#->item(0)}->as(type{Integer}));
            y = ?noError({#->item(1)}->as(type{Real}));
            callMe[x, y]
        },
        ~: 0
    }
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};