module cast802:

/* Simple records */
simpleRecordPropertyAccess = ^[a: String, b: Integer] => Integer :: { #.b };
simpleRecordItemAccess = ^[a: String, b: Integer] => Integer :: { #=>item('b') };

myKeyPropertyAccess = ^[a: String, b: ?Integer] => Result<Integer, MapItemNotFound> :: #->item('b');
optionalKeyPropertyAccess = ^[a: String, b: ?Integer] => Array<Result<Integer, MapItemNotFound>> :: { [#.b] };
optionalKeyItemAccess = ^[a: String, b: ?Integer] => Array<Result<Integer, MapItemNotFound>> :: { [#->item('b')] };
optionalKeyItemAccessError = ^[a: String, b: ?Integer] => Result<Array<Integer>, MapItemNotFound> :: { [#=>item('b')] };

recordWithRestPropertyAccess = ^[a: String, b: Integer, ...Real] => Integer :: { #.b };
recordWithRestPropertyAccessRest = ^[a: String, b: Integer, ...Real] => Result<Real, MapItemNotFound> :: { #.c };

myFn = ^Any => Any :: {
    [
        simpleRecordPropertyAccess[a: 'Hello', b: 42],
        simpleRecordItemAccess[a: 'Hello', b: 42],
        myKeyPropertyAccess[a: 'Hello', b: 42],
        optionalKeyPropertyAccess[a: 'Hello', b: 42],
        optionalKeyPropertyAccess[a: 'Hello'],
        optionalKeyItemAccess[a: 'Hello', b: 42],
        optionalKeyItemAccess[a: 'Hello'],
        optionalKeyItemAccessError[a: 'Hello', b: 42],
        optionalKeyItemAccessError[a: 'Hello'],
        recordWithRestPropertyAccess[a: 'Hello', b: 42, c: 3.14, d: 2.71],
        recordWithRestPropertyAccessRest[a: 'Hello', b: 42, c: 3.14, d: 2.71],
        recordWithRestPropertyAccessRest[a: 'Hello', b: 42]
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};