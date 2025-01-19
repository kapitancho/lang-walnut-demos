module demo-subtype:

P <: Integer;
Q <: P;

Z = $[a: Integer];
Y = Z;
Y->y(^String => Integer) :: #->length;

P->p(^String => Integer) :: $ + #->length;
Q->q(^String => Integer) :: $ + #->length;

P->d(^String => Integer|Boolean) :: $ + #->length;
Q->d(^String|Real => Integer) :: $;

getP = ^P => Integer :: #->asInteger;
getQ = ^P => P :: Q(#);

W1 = :[]; W2 = :[]; W3 = :[]; W4 = :[];
A <: Integer @ W1 :: ?when(# == 14) { => @W1[] };
A(Integer) @ W3 :: ?when(# == 5) { => @W3[] } ~ {# * 2};
B <: A @ W2 :: ?when({#->baseValue} == 8) { => @W2[] };
B(A) @ W4 :: ?when({#->baseValue} == 6) { => @W4[] } ~ { # };

MySubtype <: Integer;

fn = ^Any => Any :: {
    p = P(7);
    q1 = Q(p);
    q2 = getQ(p);
    [
        {Z[a: 2]}->y('hello world'),
        getP(p),
        getP(q1),
        getP(q2),
        p->d('Hello'),
        q1->d('Hello'),
        q2->d('Hello'),
        A(2),
        A(5),
        A(7),
        B(?noError(A(3))),
        B(?noError(A(4))),
        B(?noError(A(8)))
    ];
};

main = ^Any => String :: {
    fn()->printed
};