module cast00:

Real->invoke(=> Real) :: $ * $;
Real->x(=> Any):: 9->sqrt + 2;

A = String;
B = Integer;

main = ^Array<String> => String :: {
    a = [a: 1, b: 2];
    b = [c: 3, d: 4];
    x = a.b + b.d->sqrt(null)(null)(null) * b.c;
    x->printed;
};