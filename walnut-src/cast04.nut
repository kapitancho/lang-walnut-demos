module cast04:

T = [Integer, String, ...Real];
R = [a: Integer, b: String, ... Real];

callT = ^ ~T :: {
    var{i} = t;
    var{q1, q2, q3, q4, q5} = t;
    [i, q1, q2, q3, q4, q5];
};
callR = ^ ~R :: {
    var{~a, b: b, ~c, e: f} = r;
    [a: a, b: b, c: c, f: f]
};

callW = ^w: Array<Integer, 1..> => [Integer, Array<Integer>] :: {
    var{ element: e, array: a } = w->withoutLast;
    [e, a];
};

callN = ^p: [i: Integer, j: Real] => [Real, Integer] :: {
    var{ ~i, ~j } = p;
    var{ j, i } = [i, j];
    [i, j];
};

C := ();
C->item(^i: Integer => Integer) :: i * i;

callC = ^ :: {
    var{ one, two, three, four } = C;
    [one, two, three, four];
};

S := ();
S->item(^s: String => String) :: s->reverse;

callS = ^ :: {
    var{ ~how, old: are, ~you } = S;
    [how, are, you];
};

run = ^ :: [
    callT[1, 'hello', 3.14, 5],
    callR[a: 1, b: 'world', c: 3.14, d: 5],
    callW[1, 2, 3, 4, 5],
    callN[2, 3.14],
    callC(),
    callS()
];
main = ^ Any => String :: run()->printed;