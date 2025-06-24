module pp/test-product-mocks %% pp/model:

==> ProductById :: ^ ~ProductId => *Result<Product, UnknownProductId> :: ?whenValueOf(productId) is {
    ProductId(1): Product[ProductId(1), ProductName('Apple'), ProductPrice(1.23)],
    ProductId(2): Product[ProductId(2), ProductName('Banana'), ProductPrice(4.56)],
    ProductId(3): Product[ProductId(3), ProductName('Cherry'), ProductPrice(7.89)],
    ~: @UnknownProductId(productId)
};

==> ProductList :: ^ => *Array<Product> :: [
    Product[ProductId(1), ProductName('Apple'), ProductPrice(1.23)],
    Product[ProductId(2), ProductName('Banana'), ProductPrice(4.56)],
    Product[ProductId(3), ProductName('Cherry'), ProductPrice(7.89)]
];
