module cast35:

NonNegativeInteger = Integer<0..>;

fibonacciHelper = ^NonNegativeInteger => [NonNegativeInteger, NonNegativeInteger] ::
    ?whenTypeOf(#) is {
        type{Integer<1..>} : {
            var{i, j} = fibonacciHelper(# - 1);
            [j, i + j]
        },
        ~ : [1, 1]
    };

fibonacci = ^NonNegativeInteger => NonNegativeInteger :: fibonacciHelper(#).0;

main = ^Array<String> => String :: {
    x = 0->upTo(10)->map(fibonacci);
    x->printed
};