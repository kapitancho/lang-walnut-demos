module demo-tuple:

getIntegerRange = ^Null => Integer<2..4> :: 3;
getIntegerSubset = ^Null => Integer[1, 3, 4] :: 3;
getStringSubset = ^Null => String['a', 'c', 'd'] :: 'c';

testClosedTuple = ^[Integer, String] => Integer :: #.0 + #.1->length;
testOpenTuple = ^[Integer, String, ... Real] => Integer :: #.0 + #.1->length;
testOpenTuple2 = ^[Integer, String, ... Real] => Result<Real, Any> :: #.0 + #=>item(1)=>asInteger;
testOpenTuple3 = ^[Integer, String, ... Real] => Result<Real, Any> :: #.0 + #=>item(2)=>asInteger;
testOpenTuple4 = ^[Integer, String, Integer, Integer, Integer, Boolean, ... Real] => Integer :: {#->item(getIntegerRange())} + #.0;
testOpenTuple5 = ^[Integer, Integer, String, Integer, Integer, Boolean, ... Real] => Integer :: {#->item(getIntegerSubset())} + #.0;
testOpenTuple6 = ^[Integer, String, ... Real] => Result<Real, Any> :: #.0 + #=>item(1)=>asInteger;

Tup1 = [Integer, Any, String];
Tup2 = [Integer, ... String|Boolean];

hydrate1 = ^Array<JsonValue> => Result<Tup1, HydrationError> :: #->asJsonValue->hydrateAs(type{Tup1});
hydrate2 = ^Array<JsonValue> => Result<Tup2, HydrationError> :: #->asJsonValue->hydrateAs(type{Tup2});

tupleAsArray1 = ^[Integer, String] => Array<Integer|String, 2..2> :: #;
tupleAsArray2 = ^[Integer, String, ... Boolean] => Array<Integer|String|Boolean, 2..> :: #;

main = ^Array<String> => String :: {
    w = [3, true, 'Hello', 'World'];
    y = [3, true, 'Hello'];
    z = [3];
    x = [
        closed: testClosedTuple[3, 'Hello'],
        open1: testOpenTuple[3, 'Hello', 3.14],
        open2: testOpenTuple2[3, 'Hello', 3.14],
        open3: testOpenTuple3[3, 'Hello', 3.14],
        w1: w->isOfType(type{Tup1}),
        w2: w->isOfType(type{Tup2}),
        y1: y->isOfType(type{Tup1}),
        y2: y->isOfType(type{Tup2}),
        z1: z->isOfType(type{Tup1}),
        z2: z->isOfType(type{Tup2}),
        t12: type{Tup1}->isSubtypeOf(type{Tup2}),
        t21: type{Tup2}->isSubtypeOf(type{Tup1}),
        hyd1w: hydrate1(w),
        hyd1y: hydrate1(y),
        hyd1z: hydrate1(z),
        hyd2w: hydrate2(w),
        hyd2y: hydrate2(y),
        hyd2z: hydrate2(z)

    ];
    x->printed
};