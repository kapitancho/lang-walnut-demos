module demo-result:

A = Integer;
B = String;
C = Result<A, B>;
D = Error<B>;
E = Error;
F = Result<A>;

a = ^Any => A :: 1;
b = ^Any => B :: 'hello';
c1 = ^Any => C :: 1;
c2 = ^Any => C :: Error('error');
d = ^Any => D :: @'error';
e = ^Any => E :: @true;
f1 = ^Any => F :: 1;
f2 = ^Any => F :: Error(true);

test = ^Any => Any :: {
    [
        a: a(),
        b: b(),
        c1: c1(),
        c2: c2(),
        d: d(),
        e: e(),
        f1: f1(),
        f2: f2()
    ]
};

main = ^Array<String> => String :: {
    x = test[];
    x->printed
};