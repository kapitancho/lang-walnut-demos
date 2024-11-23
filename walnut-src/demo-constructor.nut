module demo-constructor:

B = :[];
A <: [x: Integer, y: Integer] @ B :: {
    z = #.y - #.x;
    ?whenTypeOf(z) is { type{Integer<1..>}: null, ~: => @B[] }
};

C = $[x: Integer, y: Integer];
E = :[];
D = $[x: Integer, y: Integer];
D[t: Integer, u: Integer] @ E :: {
    z = #.u - #.t;
    ?whenTypeOf(z) is { type{Integer<1..>}: null, ~: => @E[] };
    [x: #.t, y: #.u]
};
G = :[];
H = $[x: Integer, y: Integer] @ G :: {
    z = #.y - #.x;
    ?whenTypeOf(z) is { type{Integer<1..>}: null, ~: => @G[] }
};
J = :[];
K = :[];
L = $[x: Integer, y: Integer] @ K :: {
    z = #.y - #.x;
    ?whenTypeOf(z) is { type{Integer<1..>}: null, ~: => @K[] }
};
L[t: Integer, u: Integer] @ J :: {
    ?whenTypeOf(#.u) is { type{Integer<1..>}: null, ~: => @J[] };
    [x: #.t, y: #.u]
};

g = ^Result<A, B> => Result<A, B> :: ?noError(#)->with[x: 4];
gs = ^A => Result<A, B> :: ?noError(#)->with[x: 4];

Q = :[];
R = :[];
P <: [x: Integer, y: Integer] @ Q :: {
    z = #.y - #.x;
    ?whenTypeOf(z) is { type{Integer<10..>}: null, ~: => @Q[] }
};
P[t: String, u: Integer] @ R :: {
    z = #.u - #.t->length;
    ?whenTypeOf(z) is { type{Integer<1..>}: null, ~: => @R[] };
    [x: #.t->length, y: #.u]
};

pq = ^Null => Result<P, Q|R> :: P[t: 'hello', u: 7];

main = ^Array<String> => String :: [
    rec: [x: 1, y: 3],
    recWith: [x: 1, y: 3]->with[x: 4],
    good: gVal = A[1, 3],
    hydrateGood: [x: 1, y: 3]->asJsonValue->hydrateAs(type{A}),
    goodWith: g(A[1, 7]),
    badWith: g(A[1, 3]),
    withAnalyse: ?whenTypeOf(gVal) is { type{A} : gs(gVal), ~: null},
    bad: A[5, 2],
    hydrateBad: [x: 5, y: 2]->asJsonValue->hydrateAs(type{A}),
    sealedWithoutConstructor: C[6, 1],
    hydrateSealedWithoutConstructor: [x: 6, y: 1]->asJsonValue->hydrateAs(type{C}),
    sealedWithConstructorGood: D[3, 8],
    hydrateSealedWithoutConstructorGood: [x: 3, y: 8]->asJsonValue->hydrateAs(type{D}),
    sealedWithConstructorBad: D[7, 4],
    hydrateSealedWithoutConstructorBad: [x: 7, y: 4]->asJsonValue->hydrateAs(type{D}),
    sealedXWithConstructorGood: H[3, 8],
    hydrateXSealedWithoutConstructorGood: [x: 3, y: 8]->asJsonValue->hydrateAs(type{H}),
    sealedXWithConstructorBad: H[7, 4],
    ___hydrateXSealedWithoutConstructorBad: [x: 7, y: 4]->asJsonValue->hydrateAs(type{H}),
    sealedTWithConstructorGood: L[3, 8],
    hydrateTSealedWithoutConstructorGood: [x: 3, y: 8]->asJsonValue->hydrateAs(type{L}),
    sealedTWithConstructorBad: L[7, 4],
    ___hydrateTSealedWithoutConstructorBad: [x: 7, y: 4]->asJsonValue->hydrateAs(type{L}),
    sealedJAWithConstructorBad: L[-4, -7],
    ___hydrateJASealedWithoutConstructorBad: [x: -4, y: -7]->asJsonValue->hydrateAs(type{L}),
    sealedJBWithConstructorBad: L[-7, -4],
    ___hydrateJBSealedWithoutConstructorBad: [x: -7, y: -4]->asJsonValue->hydrateAs(type{L}),
    pOk: P[t: 'hello', u: 17],
    pError1: P[t: 'hello', u: 3],
    pError2: P[t: 'hello', u: 10],
    end: 0
]->printed;