module cast211:

PositiveInteger = Integer<1..>;

fizzBuzzV1 = ^i: PositiveInteger => String :: {
    ?whenIsTrue {
        {i % 15} == 0 : 'fizzbuzz',
        {i % 3} == 0 : 'fizz',
        {i % 5} == 0 : 'buzz',
        ~ : i->asString
    }
};

BuzzerState = [input: PositiveInteger, output: PositiveInteger|String];
BuzzerConverter = ^BuzzerState => BuzzerState;
getBuzzer = ^[number: PositiveInteger, word: String] => BuzzerConverter :: {
    number = #.number;
    word = #.word;
    ^BuzzerState => BuzzerState :: {
        output = #.output;
        ?whenIsTrue {
            {#.input % number} == 0 : ?whenTypeOf(output) is {
                `PositiveInteger : [input: #.input, output: word],
                `String : [input: #.input, output: output->concat(word)]
            },
            ~ : #
        }
    }
};

fizzBuzzV2 = ^PositiveInteger => String :: {
    buzzers = [getBuzzer[3, 'fizz'], getBuzzer[5, 'buzz'], getBuzzer[7, 'zap']];
    v = mutable{BuzzerState, [input: #, output: #]};
    buzzers->map(^BuzzerConverter => Any :: v->SET(#(v->value)));
    v->value.output->asString
};

fizzBuzzV3 = ^PositiveInteger => String :: {
    buzzers = [getBuzzer[3, 'fizz'], getBuzzer[5, 'buzz'], getBuzzer[7, 'zap']];
    v = [input: #, output: #];
    v = buzzers->chainInvoke(v);
    v.output->asString
};

fizzBuzzRange = ^PositiveInteger => Array<String> :: {
    /*{1->upTo(#)}->map(fizzBuzzV1)*/
    /*{1->upTo(#)}->map(fizzBuzzV2)*/
    {1->upTo(#)}->map(fizzBuzzV3)
};

myFn = ^Array<String> => Any :: {
    ?whenTypeOf(#) is {
        `[String] : {
            v = #.0->asInteger;
            ?whenTypeOf(v) is {
                `PositiveInteger: fizzBuzzRange(v),
                ~: 'Invalid input'
            }
        },
        ~ : 'Invalid input'
    }
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};