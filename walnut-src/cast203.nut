module cast203:

IntegerArray = Array<Integer>;
Tree = [
    push: ^Integer => `Tree,
    asArray: ^Null => IntegerArray,
    asReversedArray: ^Null => IntegerArray
];

NodeElement = [left: `Node, value: Integer, right: `Node];
Node = NodeElement|Null;

J = Integer|Array<String|`J>;

Y = String|Array<`Z>;
Z = Boolean|Array<`Z>;

getJ1 = ^Null => J :: 5;
getJ2 = ^Null => J :: ['hi', 5];
getJ3 = ^Null => J :: ['hi', 5, [2]];

getY1 = ^Null => Y :: 'Hello';
getY2 = ^Null => Y :: [true, false];

getZ1 = ^Null => Z :: true;

getZ2 = ^Null => Z :: [true, true, [false, true], []];

myFn = ^Array<String> => Any :: [
    getJ1(),
    getJ2(),
    getJ3(),
    getY1(),
    getY2(),
    getZ1(),
    getZ2()
];

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};