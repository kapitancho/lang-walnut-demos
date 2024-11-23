module demo-mutable:

pop = ^Mutable<Array<Integer>> => Result<Integer, ItemNotFound> :: #->POP;
shift = ^Mutable<Array<Integer>> => Result<Integer, ItemNotFound> :: #->SHIFT;

myFn = ^Array<String> => Any :: {
    a = mutable{Integer, 25};
    b = Mutable[type{Array<Integer>}, [1, 3, 5]];
    c = mutable{Array<Integer>, [1, 3, a->value]};
    [
        valueBeforeSet: a->value,
        SET: a->SET(10),
        valueAfterSet: a->value,
        valueBeforePop: b->value,
        POP: pop(b),
        valueAfterPop: b->value,
        emptyPop: { b->SET([]); pop(b) },
        valueBeforeShift: c->value,
        SHIFT: shift(c),
        valueAfterShift: c->value,
        emptyShift: { c->SET([]); shift(c) },
        end: 'end'
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};