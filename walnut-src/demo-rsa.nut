module demo-rsa:

PublicKey := $[n: Integer<1..>, c: Integer];
PrivateKey := $[n: Integer<1..>, d: Integer];

PrimesTuple := $[p: Integer<2..>, q: Integer<2..>];
==> PrimesTuple :: PrimesTuple[1031, 1061];
PrimesTuple->getN(=> Integer<1..>) :: $p * $q;
PrimesTuple->n(=> Integer<1..>) :: {$p - 1} * {$q - 1};

CoPrime := #Integer;
==> CoPrime :: CoPrime(65537);

==> PublicKey %% [~PrimesTuple, ~CoPrime] :: PublicKey[%primesTuple->getN, %coPrime->value];

/*gcd(A,M)=1      ax+by=gcd(a,b)      Ax+My=1*/

gcdExtended = ^[a: Integer, b: Integer<1..>] => [x: Integer, y: Integer, gcd: Integer] :: {
    ?whenTypeOf(#a) is {
        `Integer[0]: [x: 0, y: 1, gcd: #b],
        `Integer<1..>: {
            result = gcdExtended[#b % #a, #a];
            [x: result.y - {{{#b / #a}->asInteger} * result.x}, y: result.x, gcd: result.gcd]
        },
        ~: [x: 0, y: 1, gcd: #b]
    }
};

modularPow = ^[base: Integer, exponent: Integer, modulo: Integer<1..>] => Integer :: {
    ?whenIsTrue {
        #exponent == 0: 1,
        ~: {
            result = 1;
            base = #base % #modulo;
            half = #exponent / 2;
            m2 = #exponent % 2;
            ?whenValueOf(m2) is {
                0: {
                    pow = modularPow[base, half->asInteger, #modulo];
                    {pow * pow} % #modulo
                },
                ~: {base * modularPow[base, #exponent - 1, #modulo]} % #modulo
            }
        }
    }
};

multiplicativeInverse = ^[value: Integer, modulo: Integer<1..>] => Result<Integer, NotANumber> :: {
    var{~x, ~gcd} = gcdExtended[#value, #modulo];
    ?whenTypeOf(gcd) is {
        `Integer[1]: {x + #modulo} % #modulo,
        `Integer<1..>: @NotANumber,
        ~: 0 /* should not be reachable */
    }
};

PrivateKey->encrypt(^Integer => Integer) :: modularPow[#, $d, $n];
PublicKey->encrypt(^Integer => Integer) :: modularPow[#, $c, $n];

==> PrivateKey @ NotANumber %% [~PrimesTuple, ~CoPrime] :: PrivateKey[%.primesTuple->getN,
    ?noError(multiplicativeInverse[value: %.coPrime->value, modulo: %.primesTuple->n])
];

Test := ();
Test->run(^Integer => Any) %% [~PublicKey, ~PrivateKey] :: {
    pub = %.publicKey;
    prv = %.privateKey;
    [
        publicKey: pub,
        privateKey: prv,
        originalNumber: #,
        pubEncoded: pub->encrypt(#),
        pubEncodedPrvDecoded: prv->encrypt(pub->encrypt(#)),
        prvEncoded: prv->encrypt(#),
        prvEncodedPubDecoded: pub->encrypt(prv->encrypt(#))
    ]
};


main = ^Array<String> => String %% [~Test] :: %test->run(Random->integer[min: 0, max: 65535])->printed;