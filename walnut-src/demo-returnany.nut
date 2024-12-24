module demo-returnany:

/* if the return type is not specified, it is assumed to be Any */
myFn = ^Array<String> :: {
    1;
    2;
    3;
};

/* if the return type is not specified, it is assumed to be Any */
MyType = ^String;
MyNestedType = Array<^String>;

T = $[a: Integer] @ String :: ?whenValueOf(#a) is { 7 : => @'seven is not allowed' };

T[x: Integer, y: Integer] :: [a: #x + #y];

/* if the return type is not specified, it is assumed to be Any */
T->test(^Integer) :: $a;


main = ^Array<String> => String :: {
    x = [myFn(#), myFn->type->returnType, T[1, 4], T[5, 2]];
    x->printed
};