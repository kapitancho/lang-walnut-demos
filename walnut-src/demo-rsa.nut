module demo-rsa:

PublicKey = $[n: Integer, c: Integer];
PrivateKey = $[n: Integer, d: Integer];

PrimesTuple = $[p: Integer, q: Integer];
==> PrimesTuple :: PrimesTuple[1031, 1061];
PrimesTuple->getN(^Null => Integer) :: $.p * $.q;
PrimesTuple->n(^Null => Integer) :: {$.p - 1} * {$.q - 1};

CoPrime <: Integer;
==> CoPrime :: CoPrime(65537);

==> PublicKey %% [~PrimesTuple, ~CoPrime] :: PublicKey[%.primesTuple->getN, %.coPrime];

/*gcd(A,M)=1      ax+by=gcd(a,b)      Ax+My=1*/

gcdExtended = ^[a: Integer, b: Integer] => [x: Integer, y: Integer, gcd: Integer] :: {
    a = #.a;
    ?whenTypeOf(a) is {
        type{Integer[0]}: [x: 0, y: 1, gcd: #.b],
        type{Integer<1..>}: {
            result = gcdExtended[#.b % #.a, #.a];
            [x: result.y - {{{#.b / a}->asInteger} * result.x}, y: result.x, gcd: result.gcd]
        },
        ~: [x: 0, y: 1, gcd: #.b]
    }
};

modularPow = ^[base: Integer, exponent: Integer, modulo: Integer] => Integer :: {
    ?whenIsTrue {
        #.exponent == 0: 1,
        ~: {
            result = 1;
            modulo = #.modulo;
            base = #.base % modulo;
            exponent = #.exponent;
            half = exponent / 2;
            m2 = exponent % 2;
            ?whenValueOf(m2) is {
                0: {
                    pow = modularPow[base, half->asInteger, modulo];
                    {pow * pow} % modulo
                },
                ~: {base * modularPow[base, exponent - 1, modulo]} % modulo
            }
        }
    }
};

multiplicativeInverse = ^[value: Integer, modulo: Integer] => Result<Integer, NotANumber> :: {
    result = gcdExtended[#.value, #.modulo];
    gcd = result.gcd;
    x = result.x;
    ?whenTypeOf(gcd) is {
        type{Integer[1]}: {x + #.modulo} % #.modulo,
        type{Integer<1..>}: Error(NotANumber[]),
        ~: 0 /* should not be reachable */
    }
};

PrivateKey->encrypt(^Integer => Integer) :: modularPow[#, $.d, $.n];
PublicKey->encrypt(^Integer => Integer) :: modularPow[#, $.c, $.n];

==> PrivateKey @ NotANumber %% [~PrimesTuple, ~CoPrime] :: PrivateKey[%.primesTuple->getN,
    ?noError(multiplicativeInverse[value: %.coPrime, modulo: %.primesTuple->n])
];

Test = :[];
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
        prvEncodedPubEncoded: pub->encrypt(prv->encrypt(#))
    ]
};


main = ^Array<String> => String :: Test[]->run(Random[]->integer[min: 0, max: 65535])->printed;