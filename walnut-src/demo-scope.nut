module demo-scope:

a = 1;
b = ^String => Integer :: #->length;

c = ^String => Integer :: b(#);

T = :[];

T->d(^String => Integer) :: b(#);

K <: [x: Integer];

myFn = ^Array<String> => Any :: {
    [
        c('hello'),
        T[]->d('hello'),
        [x: 15]->asJsonValue->hydrateAs(type{K})
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};