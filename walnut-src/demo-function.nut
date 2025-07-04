module demo-function:

MyFunc = ^String => Integer;
MyFuncSubtype := # ^String => Integer;

MyFuncRetFunc = ^Integer => MyFunc;

ProductId := # Integer<1..>;
ProductId->invoke(^Real => Boolean) :: # == 3.14;

callMe = ^[str: String, myFunc: MyFunc] => Integer :: {
    #.myFunc(#.str)
};

myFunc = ^String => Integer :: #->length;
myFuncRetFunc = ^v: Integer => MyFunc :: {
    ^s: String => Integer :: {s->length} + v
};

reflect = ^Type<Function> => [parameterType: Type, returnType: Type] :: {
    [parameterType: #->parameterType, returnType: #->returnType]
};

test = ^Any => Any :: {
    myFuncSubtype = MyFuncSubtype(myFunc);
    productId = ProductId(15);
    [
        subtypeCall: myFuncSubtype->value->invoke('hi!'),
        passFnToFn: callMe['hello', myFunc],
        passSubtypeFnToFn: callMe['welcome', myFuncSubtype->value],
        invokableType: productId(3.14),
        fnCallFn: myFuncRetFunc(8)('hello'),
        reflectFn: reflect(myFunc->type),
        reflectFnDeep: reflect(myFuncRetFunc->type->returnType)
    ]
};

main = ^Array<String> => String :: {
    x = test[
        [a: 1, b: 'Two', c: 3.14, d: false]
    ];
    x->printed
};