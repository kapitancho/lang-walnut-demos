module cast211:

PositiveInteger = Integer<1..>;

fizzBuzzV1 = ^PositiveInteger => String :: {
    ?whenIsTrue {
        {# % 15} == 0 : 'fizzbuzz',
        {# % 3} == 0 : 'fizz',
        {# % 5} == 0 : 'buzz',
        ~ : #->asString
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
                type{PositiveInteger} : [input: #.input, output: word],
                type{String} : [input: #.input, output: output->concat(word)]
            },
            ~ : #
        }
    }
};

fizzBuzzV2 = ^PositiveInteger => String :: {
    buzzers = [getBuzzer[3, 'fizz'], getBuzzer[5, 'buzz'], getBuzzer[7, 'zap']];
    v = Mutable[type{BuzzerState}, [input: #, output: #]];
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
        type{[String]} : {
            v = #.0->asInteger;
            ?whenTypeOf(v) is {
                type{PositiveInteger}: fizzBuzzRange(v),
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