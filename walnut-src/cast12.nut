module cast12:

Point <: [x: Real, y: Real];
ProductId <: Integer<1..>;

fn1 = ^JsonValue => String :: {
    #->jsonStringify
};

fn2 = ^String => Result<JsonValue, InvalidJsonString    > :: {
    #->jsonDecode
};

myFn = ^Array<String> => Any :: [
    {42}->jsonStringify,
    {3.14}->jsonStringify,
    {'text'}->jsonStringify,
    {true}->jsonStringify,
    {false}->jsonStringify,
    {null}->jsonStringify,
    {[42, 'text', Point([3.14, 42])]}->jsonStringify,
    {[a: 42, b: 3.14, productId: ProductId(35)]}->jsonStringify,
    fn1([42]),
    fn2('[1, false, null]'),
    fn2('Invalid json here'),
    fn2({[a: 42, b: 3.14, productId: ProductId(35)]}->jsonStringify)
];

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};