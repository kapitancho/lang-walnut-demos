module cast21:

Point = #[x: Real, y: Real];

InvalidIntegerRange = $[from: Integer, to: Integer];
MyIntegerRange = #[from: Integer, to: Integer] @ InvalidIntegerRange :: {
    ?whenIsTrue { #.from > #.to : Error(InvalidIntegerRange(#)), ~: # }
};

fn = ^Any => Result<Integer, Any> :: #->as(`Integer);

bimbo = ^MyIntegerRange => Result<MyIntegerRange, InvalidIntegerRange> :: #->with[to: 5];

upToFn = ^[from: Integer<5..10>, to: Integer<12..20>] => Array<Integer<5..20>, 3..16> :: #.from->upTo(#.to);

downToFn = ^[from: Integer<5..20>, to: Integer<8..24>] => Array<Integer<8..20>, ..13> :: #.from->downTo(#.to);

myFn = ^Array<String> => Any :: {
    a = [x: 4, y: 7];
    b = a->with[y: 9];
    p = Point[4, 7];
    q = p->with[y: 9];
    t = MyIntegerRange[14, 7];
    u = ?noError(MyIntegerRange[4, 7]);
    v = ?noError(u->with[to: 9]);
    w = v->with[from: 15];
    f = fn(15);
    g = fn('Hello');
    c = 5->upTo(12);
    d = 12->upTo(5);
    m = 5->downTo(12);
    n = 12->downTo(5);
    x = InvalidIntegerRange[5, -12];
    y = fn(x);
    z = bimbo(u);
    [a, b, p, q, t, u, v, w, f, g, c, d, m, n, x, y, z]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};