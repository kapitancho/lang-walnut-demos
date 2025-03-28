module demo-tpl %% $tpl, demo-tpl-product-list, demo-tpl-product-page:

getProductList = ^Null => ProductList :: [products: [
    [id: 1, name: 'Apple <Granny Smith>', price: 1.99],
    [id: 2, name: 'Banana', price: 0.99],
    [id: 3, name: 'Cherry', price: 2.99]
]];

getProductPage = ^Null => ProductPage :: {
    [productList: getProductList(), title: 'This is the product page']
};

myFn = ^Null => Result<String, Any> %% [~TemplateRenderer] :: {
    %templateRenderer => render(getProductPage())
};

main = ^Array<String> => String :: {
    x = myFn();
    ?whenTypeOf(x) is {
        type{String}: x->OUT_TXT,
        ~: x->printed
    }
};