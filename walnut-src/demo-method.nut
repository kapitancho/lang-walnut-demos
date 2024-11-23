module demo-method:

MyType = $[a: Integer, b: Integer];

MyType[a: Integer, b: Integer, c: Integer] :: [a: #.a, b: #.b + #.c];
MyType[a: Integer, b: Integer, c: Integer] :: [a: #.a + 4, b: #.b + #.c];

MyType->sum(^Null => Integer) :: $.a + $.b;
MyType->sum(^Null => Integer) :: $.a + 102;

MyType ==> Integer :: $.a + $.b;
MyType ==> Integer :: $.a + 205;

==> MyType :: MyType[1, 2, 3];
==> MyType :: MyType[111, 2, 3];

test = ^Any => Any :: {
    t = DependencyContainer[]=>valueOf(type{MyType});
    [
        t->sum,
        t->asInteger
    ]
};

main = ^Array<String> => String :: {
    x = test[0];
    x->printed
};