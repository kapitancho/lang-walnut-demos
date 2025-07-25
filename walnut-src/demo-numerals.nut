module demo-numerals:

Zero := ();
Successor := #[pred: \Nat];
Nat = Zero|Successor;
NotANat := ();

plus = ^[n: Nat, m: Nat] => Nat :: { n = #.n;
    ?whenTypeOf(n) is {
        `Zero: #.m,
        `Successor: Successor[plus[n.pred, #.m]]
    }
};
minus = ^[n: Nat, m: Nat] => Result<Nat, NotANat> :: {
    n = #.n; m = #.m;
    ?whenTypeOf(m) is {
        `Zero: n,
        `Successor: ?whenTypeOf(n) is {
            `Zero: @NotANat,
            `Successor: minus[n.pred, m.pred]
        }
    }
};
times = ^[n: Nat, m: Nat] => Nat :: { n = #.n;
    ?whenTypeOf(n) is {
        `Zero: n,
        `Successor: plus[times[n.pred, #.m], #.m]
    }
};
exp = ^[n: Nat, m: Nat] => Nat :: { m = #.m;
    ?whenTypeOf(m) is {
        `Zero: Successor[Zero],
        `Successor: times[exp[#.n, m.pred], #.n]
    }
};

Nat ==> Integer :: ?whenTypeOf($) is {
    `Zero: 0,
    `Successor: 1 + $.pred->asInteger
};

Nat ==> String :: ?whenTypeOf($) is {
    `Zero: '',
    `Successor: '.'->concat($.pred->asString)
};

myFn = ^Any => Any :: {
    one = Successor[Zero];
    two = Successor[one];
    three = Successor[two];
    x = plus[times[three, exp[two, two]], one];
    [x, x->asString, x->asInteger,
        {?noError(minus[x, Successor[Successor[Zero]]])}->asInteger
    ]
};

main = ^Array<String> => String :: {
    x = myFn();
    x->printed
};