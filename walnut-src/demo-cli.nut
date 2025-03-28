module demo-cli:

calc = ^Array<String> => Result<Integer, Any> ::
    ?noError(?noError(#->item(0))->asInteger) +
    ?noError(?noError(#->item(1))->asInteger);

main = ^Array<String> => String :: {
    s = calc(#);
    ?whenTypeOf(s) is {
        type{Integer}: s->asString,
        ~: 'Invalid parameters'
    }
};