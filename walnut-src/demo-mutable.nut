module demo-mutable:

pop = ^Mutable<Array<Integer>> => Result<Integer, ItemNotFound> :: #->POP;
shift = ^Mutable<Array<Integer>> => Result<Integer, ItemNotFound> :: #->SHIFT;

myFn = ^Array<String> => Any :: {
    a = mutable{Integer, 25};
    b = mutable{Array<Integer>, [1, 3, 5]};
    c = mutable{Array<Integer>, [1, 3, a->value]};
    d = mutable{Mutable<Integer>, a};
    e = mutable{Integer, 40};
    s = mutable{String, 'Hello'};
    t = mutable{Array<Integer>, [1, 3, 5]};
    z = mutable{Set<Integer>, [2; 5]};
    w = [1, 0, -42]=>asMutableOfType(type{Array<Integer>});
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
        nestedSet: d->value->SET(30),
        valueAfterSet: a->value,
        nestedMutableSet: d->SET(e),
        nestedSetNext: d->value->SET(50),
        nextAfterSet: e->value,
        stringBeforeAppend: s->value,
        stringAfterAppend: s->APPEND(' World')->value,
        stringMutable: s,
        arrayBeforePush: t->value,
        arrayAfterPush: t->PUSH(7)->value,
        arrayAfterUnshift: t->UNSHIFT(9)->value,
        arrayMutable: t,
        setBeforeAdd: z->value,
        setAfterAdd: z->ADD(7)->value,
        setAfterAddDuplicate: z->ADD(7)->value,
        successfulRemove: z->REMOVE(7),
        unsuccessfulRemove: z->REMOVE(7),
        setAfterRemove: z->value,
        setAfterClear: z->CLEAR->value,
        unknownMutable: w,
        unknownMutableValue: w->value,
        end: 'end'
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};