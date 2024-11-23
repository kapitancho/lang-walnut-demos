module cast26:

/*
Tree = [
    push: ^Integer => Tree,
    asArray: ^Null => IntegerArray,
    asReversedArray: ^Null => IntegerArray
];

NodeElement = [left: Node, value: Integer, right: Node];
Node = NodeElement|Null;

nodeValue = ^Integer => NodeElement :: {
    [left: null, value: #, right: null]
};

XTree = $[root: Node];

XTree ==> Tree :: {
    push = ^[node: Node, value: Integer] => Node :: {
        n = #.node;
        ?whenTypeOf(n) is {
            type{NodeElement}: {
                ?whenIsTrue {
                    n.value > #.value: n->with[left: push[n.left, #.value]],
                    ~                : n->with[right: push[n.right, #.value]]
                }
            },
            ~: nodeValue(#.value)
        }
    };
    asArray = ^Node => Array<Integer> :: {
        ?whenTypeOf(#) is {
            type{NodeElement}: {asArray(#.left)->insertLast(#.value)}->appendWith(asArray(#.right)),
            ~: []
        }
    };
    asReversedArray = ^Node => Array<Integer> :: {
        ?whenTypeOf(#) is {
            type{NodeElement}: {asReversedArray(#.right)->insertLast(#.value)}->appendWith(asReversedArray(#.left)),
            ~: []
        }
    };
    [
        push: ^Integer => Tree :: {
            {XTree[push[$.root, #]]}->as(type{Tree})
        },
        asArray: ^Null => Array<Integer> :: asArray($.root),
        asReversedArray: ^Null => Array<Integer> :: asReversedArray($.root)
    ]
};
*/
T <: [x: Real, y: Real];

T ==> Any :: {
    [
        d: ^Null => Real :: {
            {{$.x} * {$.x}} + {{$.y} * {$.y}}
        }
    ]
};

T ==> String :: {
    {''}->concatList['{', {$.x}->asString, ',', {$.y}->asString, '}']
};

A = [x: Real, y: Real];

A->d(^Null => Real) :: {
    {{$.x} * {$.x}} + {{$.y} * {$.y}}
};

A ==> String :: {
    {''}->concatList['{', {$.x}->asString, ',', {$.y}->asString, '}']
};

myFn = ^Array<String> => Any :: {
    t = T[3.14, -1];
    a = {[x: 3.14, y: -1]}->as(type{A});

    /*x0 = {XTree[null]}->as(Tree);
    x1 = x0.push(10);
    x2 = x1.push(6);
    x3 = x2.push(9);
    x4 = x3.push(20);
    x5 = x4.push(2);
    x6 = x5.push(9);*/
    [t, t->d, t->asString, a, a->d, a->asString/*, x6.asArray(), x6.asReversedArray()*/]
};
main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};