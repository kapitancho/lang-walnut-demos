module demo-resultx:

Product = String;
ProductId = Integer;
UnknownProductId := $[~ProductId];

Square = ^Real => Real<0..>;
ArrayItem = ^[a: Array, idx: Integer<0..>] => Result<Any, IndexOutOfRange>;
ErrorOnly = ^Integer => Error<Integer>;
AllProducts = ^Null => Array<Product>;
ProductById = ^[~ProductId] => Result<Product, UnknownProductId>;

AllProductsV2 = ^Null => Result<Array<Product>>;
ProductByIdV2 = ^[~ProductId] => Result<Product, UnknownProductId|Any>;

AllProductsV3 = ^Null => Array<Product>;
ProductByIdV3 = ^[~ProductId] => Result<Product, UnknownProductId>;

==> Square :: ^Real => Real<0..> :: #->square;
==> ArrayItem :: ^[a: Array, idx: Integer<0..>] => Result<Any, IndexOutOfRange> :: #a->item(#idx);
==> ErrorOnly :: ^Integer => Error<Integer> :: @#;
==> AllProducts :: ^Null => Array<Product> :: 1->upTo(10)->map(^ProductId => Product :: 'Product #'->concat(#->asString));
==> ProductById :: ^[~ProductId] => Result<Product, UnknownProductId> :: ?whenTypeOf(#productId) is {
    type{Integer<1..10>}: 'Product #'->concat(#productId->asString),
    ~: @UnknownProductId[#productId]
};

==> AllProductsV2 :: ^Null => Result<Array<Product>> :: @'Some random error';
==> ProductByIdV2 :: ^[~ProductId] => Result<Product, UnknownProductId|Any> :: @'Some random error';

test = ^Any => Any %% [~Square, ~ArrayItem, ~ErrorOnly, ~AllProducts, ~AllProductsV2, ~ProductById, ~ProductByIdV2] :: [
    iy: %arrayItem[a: [1, 2, 5], idx: 1],
    in: %arrayItem[a: [], idx: 1],
    err: %errorOnly(42),
    sq: %square(5),
    all: %allProducts(),
    allV2: %allProductsV2(),
    pr7: %productById[7],
    pr25: %productById[25],
    pr25V2: %productByIdV2[25]
];

main = ^Array<String> => String :: {
    x = test[];
    x->printed
};