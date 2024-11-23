module demo-record:

getIntegerRange = ^Null => Integer<2..4> :: 3;
getIntegerSubset = ^Null => Integer[1, 3, 4] :: 3;
getStringSubset = ^Null => String['a', 'c', 'd'] :: 'c';

testClosedRecord = ^[a: Integer, b: String] => Integer :: #.a + #.b->length;
testOpenRecord = ^[a: Integer, b: String, ... Real] => Integer :: #.a + #.b->length;
testOpenRecord2 = ^[a: Integer, b: String, ... Real] => Result<Real, Any> :: #.a + #=>item('b')=>asInteger;
testOpenRecord3 = ^[a: Integer, b: String, ... Real] => Result<Real, Any> :: #.a + #=>item('c')=>asInteger;
testOpenRecord4 = ^[a: Integer, b: String, c: Integer, d: Integer, e: Boolean, ... Real] => Integer :: {#->item(getStringSubset())} + #.a;

Rec1 = [a: Integer, b: Any, c: String];
Rec2 = [a: Integer, b: OptionalKey, c: OptionalKey<String>];
Rec3 = [a: Integer, ... String|Boolean];

hydrate1 = ^Map<JsonValue> => Result<Rec1, HydrationError> :: #->asJsonValue->hydrateAs(type{Rec1});
hydrate2 = ^Map<JsonValue> => Result<Rec2, HydrationError> :: #->asJsonValue->hydrateAs(type{Rec2});
hydrate3 = ^Map<JsonValue> => Result<Rec3, HydrationError> :: #->asJsonValue->hydrateAs(type{Rec3});

recordAsMap1 = ^[a: Integer, b: String] => Map<Integer|String, 2..2> :: #;
recordAsMap2 = ^[a: Integer, b: String, ... Boolean] => Map<Integer|String|Boolean, 2..> :: #;
recordAsMap3 = ^[a: Integer, b: OptionalKey<String>] => Map<Integer|String, 1..2> :: #;

main = ^Array<String> => String :: {
    w = [a: 3, b: true, c: 'Hello', d: 'World'];
    y = [a: 3, b: true, c: 'Hello'];
    z = [a: 3];
    x = [
        closed: testClosedRecord[a: 3, b: 'Hello'],
        open1: testOpenRecord[a: 3, b: 'Hello', c: 3.14],
        open2: testOpenRecord2[a: 3, b: 'Hello', c: 3.14],
        open3: testOpenRecord3[a: 3, b: 'Hello', c: 3.14],
        w1: w->isOfType(type{Rec1}),
        w2: w->isOfType(type{Rec2}),
        w3: w->isOfType(type{Rec3}),
        y1: y->isOfType(type{Rec1}),
        y2: y->isOfType(type{Rec2}),
        y3: y->isOfType(type{Rec3}),
        z1: z->isOfType(type{Rec1}),
        z2: z->isOfType(type{Rec2}),
        z3: z->isOfType(type{Rec3}),
        r12: type{Rec1}->isSubtypeOf(type{Rec2}),
        r21: type{Rec2}->isSubtypeOf(type{Rec1}),
        hyd1w: hydrate1(w),
        hyd1y: hydrate1(y),
        hyd1z: hydrate1(z),
        hyd2w: hydrate2(w),
        hyd2y: hydrate2(y),
        hyd2z: hydrate2(z),
        hyd3w: hydrate3(w),
        hyd3y: hydrate3(y),
        hyd3z: hydrate3(z)
    ];
    x->printed
};