module cast804:

DatabaseError = $[errorCode: Integer, message: String];

ProductId <: String<36>;
ProductName = String<1..50>;
ProductPrice = Real<0..>;
ProductData = [name: ProductName, price: ProductPrice];
Product = $[id: ProductId, data: Mutable<ProductData>];
Product->data(^Null => ProductData) :: $data->value;

UnknownProduct = $[~ProductId];
ProductById = ^[~ProductId] => *Result<Product, UnknownProduct>;

ProductRawData = [id: String, name: String, price: Real];
ProductFetcher = ^[~ProductId] => Result<ProductRawData|Null, DatabaseError>;

ProductRawData ==> Product @ HydrationError :: [
    id: $ => item('id'),
    data: [name: $ => item('name'), price: $ => item('price')]
]->hydrateAs(type{Product});

==> ProductById :: ^[~ProductId] => *Result<Product, UnknownProduct> %% [~ProductFetcher] :: {
    rawData = {%productFetcher[#productId]} *> ('Database Error');
    ?whenTypeOf(rawData) is {
        type{ProductRawData}: {rawData->asProduct} *> ('Failed to hydrate product data'),
        ~: @UnknownProduct[#productId]
    }
};

==> ProductFetcher :: ^[~ProductId] => Result<ProductRawData|Null, DatabaseError> :: ?whenValueOf(#productId) is {
    ProductId('00000000-0000-0000-0000-000000000001'): [id: #productId->baseValue, name: 'Product 1', price: 9.99],
    ProductId('00000000-0000-0000-0000-000000000002'): null,
    ~: @DatabaseError[errorCode: 1, message: 'Failed to get products from the database']
};

productPriceByProductId = ^[~ProductId] => *Result<ProductPrice, UnknownProduct> %% [~ProductById] :: {
    {%productById => invoke[#productId]}->data.price
};

productTitleByProductId = ^[~ProductId] => Any %% [~ProductById] :: {
    product = {%productById |> invoke[#productId]};
    ?whenTypeOf(product) is { type{Product}: product->data.title, ~: 'Unknown Product' }
};

myFn = ^Any => Any :: {
    existingProductId = ProductId('00000000-0000-0000-0000-000000000001');
    missingProductId = ProductId('00000000-0000-0000-0000-000000000002');
    invalidProductId = ProductId('00000000-0000-0000-0000-000000000003');
    [
        [price: productPriceByProductId[existingProductId], title: productTitleByProductId[existingProductId]],
        [price: productPriceByProductId[missingProductId], title: productTitleByProductId[missingProductId]],
        [price: productPriceByProductId[invalidProductId], title: productTitleByProductId[invalidProductId]]
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};