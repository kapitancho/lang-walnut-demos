module cast15:

InvalidProductId = :[];
ProductId <: Integer<1..>;

Integer ==> ProductId @ InvalidProductId :: {
    ?whenTypeOf($) is {
        type{Integer<1..>} : ProductId($),
        ~: Error(InvalidProductId[])
    }
};

myFn = ^Array<String> => Result<ProductId, InvalidProductId> :: {
    {12}->as(type{ProductId})
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};