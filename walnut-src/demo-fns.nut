module demo-fns:

A = String;
B = Integer;

MyFn = ^A => B;

MyR = ^[~A, ~B] => B;

myFn = ^a: A => B :: a->length;
myFnSym = ^a: A => B :: a->length;

A->oldStyle(^A => B) :: {$->length} + {#->length};
A->newStyle(^a: A => B) :: {$->length} + {a->length};
A->newStyleAny(^a: A) :: {$->length} + {a->length};
A->newStyleSym(^~A => B) :: {$->length} + {a->length};
A->newStyleSymAny(^~A) :: {$->length} + {a->length};

TOld = $[a: B];
TOld(A) :: [a: #->length];
TNew = $[a: Integer];
TNew(a: A) :: [a: a->length];
TNewSym = $[a: Integer];
TNewSym(~A) :: [a: a->length];

fn = ^Any => Any :: {
    c = ^a: A => B :: a->length;
    d = ^~A => B :: a->length;
    [
        c('hello'),
        d('hello'),
        'hello'->oldStyle('world'),
        'hello'->newStyle('world'),
        'hello'->newStyleAny('world'),
        'hello'->newStyleSym('world'),
        'hello'->newStyleSymAny('world'),
        myFn('welcome!'),
        myFnSym('welcome!'),
        TOld('hello'),
        TNew('hello'),
        TNewSym('hello')
    ]
};

main = ^Array<String> => String :: fn()->printed;