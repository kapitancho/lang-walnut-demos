module cast210:

d = ^Array<String, 3..8> => Array<String, 1..6> :: {
    f1 = #->withoutFirst;
    f2 = f1.array->withoutFirst;
    f3 = f2.array->withoutFirst;
    f3.array->insertLast(f1.element->concatList[f2.element, f3.element, f1.array->item(1)])
};

myFn = ^Array<String> => Any :: {

    [
        d: d['a', 'b', 'c', 'd'],

        end: 'end'
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};