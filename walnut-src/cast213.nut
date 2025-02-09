module cast213:

V = [a: Integer, b: Boolean, c: String];
W = [d: Boolean, e: Real];
X = [f: Any];
Y = Result<W, X>;
S = ^V => V;
T = Result<V, X>;
U = ^V => T;
R = ^T => T;

Mz = [
    handlers: Array<^V => Y>,
    default: ^V => W
];

ha1 = ^ ~V => Y :: ?whenIsTrue {
    v.b: [d: v.b, e: v.a + 1],
    ~: Error([f: v.c])
};
ha2 = ^ ~V => Y :: ?whenIsTrue {
    {v.a > 0}: [d: v.b, e: v.a + 3],
    ~: Error([f: v.c])
};
ka1 = ^ ~V => T :: ?whenIsTrue {
    v.b: [a: v.a, b: v.b, c: v.c->concat('!')],
    ~: Error([f: v.c])
};
ka2 = ^ ~V => T :: ?whenIsTrue {
    {v.a > 0}: [a: v.a, b: v.b, c: v.c->concat('!')],
    ~: Error([f: v.c])
};

monadFixer = ^monad: U => R :: {
    ^r: T => T :: ?whenTypeOf(r) is {
        type{V}: ?noError(monad(r)),
        type{Result<Nothing, X>}: r
    }
};

ha3 = ^V => Y :: {
    r = [ka1, ka2]->map(monadFixer)->chainInvoke(#);
    ?whenTypeOf(r) is {
        type{V}: [d: #.b, e: #.c->length],
        ~: Error([f: #.c])
    }
};

==> Mz :: [
    handlers: [ha3, ha1, ha2],
    default: ^ ~V => W :: [d: v.b, e: v.a]
];

P = :[];
P->m(^ ~V => W) %% Mz :: {
    h = %.handlers;
    d = %.default;
    rec = ^[p: V, h: Array<^V => Y>, d: ^V => W] => W :: {
        ?whenTypeOf(#h) is {
            type{Array<^V => Y, 1..>}: {
                hh = #h->withoutFirst;
                el = hh.element;
                arr = hh.array;
                res = el(#p);
                ?whenTypeOf(res) is {
                    type{W}: res,
                    ~: rec[#p, arr, #d]
                }
            },
            ~: #d(#p)
        }
    };
    rec[v, h, d]
};

myFn = ^Array<String> => Any :: {
    p = P[];
    v1 = [a: 1, b: true, c: 'hello'];
    v2 = [a: -42, b: false, c: 'world'];
    v3 = [a: 15, b: false, c: 'world'];

    [
        p->m(v1),
        p->m(v2),
        p->m(v3)
    ]
};

main = ^args: Array<String> => String :: {
    x = myFn(args);
    x->printed
};