module cast000:

m = ^[Integer, ... String] => Array<String> :: #_;
n = ^[a: Integer, ... String] => Map<String> :: #_;

main = ^Array<String> => String :: {
    t2 = `Integer;
    ?whenValueOf(t2) is { 1 : 2 };
    ?whenTypeOf(t2) is { `Integer : 3 };
    ?whenIsTrue { 1 : 2 };
    ?when(1) { 2 } ~ {3};
    ?whenIsError(t2) { 4 } ~ {5};
    [t2, m[1, 'Hello'], n[a: 1, b: 'Hello']]->printed
};