module cast209:

MyState = $[a: Integer];
MyState->value(^Null => Integer) :: $.a + 4;

MyIntState = $[a: Integer];
MyIntState->value(^Null => Integer) :: $.a + 13;

MySubtype <: Integer;
MySubtype->value(^Null => Integer) :: {$->baseValue} + 5;

myFn = ^Array<String> => Any :: {
    s = MyState[3];
    i = MyIntState[8];
    t = MySubtype(4);
    [s, s->value, i, i->value, t, t->value, t->baseValue]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};