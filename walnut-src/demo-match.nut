module demo-match:

matchTrue = ^Any => String['true', 'false'] :: ?whenIsTrue {
    #: 'true',
    ~: 'false'
};

matchType = ^Any => String :: ?whenTypeOf(#) is {
    type{String}: 'string',
    ~: 'not a string'
};

matchValue = ^Any => String :: ?whenValueOf(#) is {
    'hello': 'hello',
    ~: 'not hello'
};

matchIf = ^Any => String|Null :: ?when(#) {
    'true'
};

matchIfWithElse = ^Any => String :: ?when(#) {
    'true'
} ~ {
    'false'
};


main = ^Any => String :: [
    matchTrue: matchTrue(3.14),
    matchType: matchType('hello'),
    matchValue: matchValue('hello'),
    matchIfThen: matchIf('true'),
    matchIfElse: matchIf(''),
    matchIfWithElseThen: matchIfWithElse('true'),
    matchIfWithElseElse: matchIfWithElse('')
]->printed;