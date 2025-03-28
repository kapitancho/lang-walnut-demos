module demo-nut:

MyDep = #[c: String, d: Boolean];
MyType = $[a: Integer, b: Real];

MyType->myMethod(^[e: Array, f: Map] => Array) %% MyDep :: [$a, $b, %c, %d, #e, #f];

==> MyDep :: MyDep[c: 'hello', d: true];
==> MyType :: MyType[a: 42, b: 3.14];

Tx = ^[b: Integer] => Integer;
fn = ^[a: Integer] => Tx :: ^[b: Integer] => Integer :: #a + #b;

f = ^Integer => Any :: #;
F = :[];
F->invoke(^Integer => Any) :: [$, #];

main = ^Any => String %% MyType :: [
    fn: f(1),
    inv: F()(2),
    methodCall: %->myMethod[e: [], f: [:]],
    innerScope: {fn[2]}[3]
]->printed;