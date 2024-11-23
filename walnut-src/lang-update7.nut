module lang-update7:

ret1 = ^Null => Impure<String> :: 'Hello World';
ret2 = ^Null => Impure<String> :: @ExternalError[
    errorType: 'error type', originalError: null, errorMessage: 'error message'
];

p1 = ^Null => *Integer :: {?noExternalError(ret1())}->length;
p2 = ^Null => *Integer :: {?noExternalError(ret2())}->length;
p3 = ^Null => *Integer :: {?noError(ret1())}->length;
p4 = ^Null => *Integer :: {?noError(ret2())}->length;
p5 = ^Null => *Integer :: ret1=>invoke->length;
p6 = ^Null => *Integer :: ret2=>invoke->length;
p7 = ^Null => *Integer :: ret2|>invoke->length;

testFn = ^Null => Any :: {
    t1 = type{Impure};
    t2 = type{Impure<String>};
    [
        t1,
        t2,
        t1->isSubtypeOf(t2),
        t2->isSubtypeOf(t1),
        ret1(),
        ret2(),
        p1(),
        p2(),
        p3(),
        p4(),
        p5(),
        p6()
    ]
};

main = ^Array<String> => String :: testFn()->printed;