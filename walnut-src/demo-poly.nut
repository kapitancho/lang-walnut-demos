module demo-poly:

NoRealRoots := ();
InvalidOrderTwoPolynomial := ();

NonZeroReal = Real<(..0), (0..)>;

OrderTwoPolynomial := $[a: NonZeroReal, b: Real, c: Real];

OrderTwoPolynomial[a: Real, b: Real, c: Real] @ InvalidOrderTwoPolynomial ::
    ?whenTypeOf(#a) is {
        `NonZeroReal: [a: #a, b: #b, c: #c],
        ~: => @InvalidOrderTwoPolynomial
    };

OrderTwoPolynomial->calculateForX(^x: Real => Real) ::
    $a * x * x + $b * x + $c;
OrderTwoPolynomial->findZeroes(=> Result<[x1: Real, x2: OptionalKey<Real>], NoRealRoots>) :: {
    d = $b * $b - $a * 4 * $c;
    ?whenTypeOf(d) is {
        `Real[0]: [x1: - $b / {$a * 2.0}],
        `Real<0..>: [
            x1: {-$b + d->sqrt} / {$a * 2.0},
            x2: {-$b - d->sqrt} / {$a * 2.0}
        ],
        ~: @NoRealRoots
    }
};

testFn = ^ => String :: {
    p = OrderTwoPolynomial[a: 2, b: -5, c: -3];
    ?whenTypeOf(p) is {
        `OrderTwoPolynomial: {
            r = p->calculateForX(1);
            s = p->findZeroes;
            'My result is '
      ->concat(r->asString)
      ->concat(', zeroes: ')
      ->concat(s->printed)
        },
        ~: 'error'
    }
};


main = ^Array<String> => String :: {
    testFn()
};