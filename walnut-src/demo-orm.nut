module demo-orm %% db-xorm-repository:

ProductId = Integer<1..>;
ProductName = String<1..150>;
ProductDescription = String<1..>|Null;
Price = Real<0..>;
Product = [
    id: ProductId,
    name: ProductName,
    price: Price,
    description: ProductDescription
];

ProductModel = Type<Product>;
ProductModel ==> OrmModel :: OrmModel[table: 'products', keyField: 'id', sequenceField: 'price'];

ProductRepository = $[~OxRepository];
ProductRepository(Null) @ ExternalError  :: [
    oxRepository: {OxRepository[type: type{Product}, model: type{ProductModel}]} *> ('Failed to get orm repository')
];
==> ProductRepository @ ExternalError :: ProductRepository(null);

ProductRepository->all(=> *Array<Product>) ::
    $oxRepository => all    -> as(type{Array<Product>}) *> ('Failed to build products');
ProductRepository->one(^ProductId => *Result<Product, EntryNotFound>) ::
    $oxRepository => one(#) -> as(type{Product}) *> ('Failed to build product');
ProductRepository->insertOne(^Product => *Null) :: $oxRepository |> insertOne(#);
ProductRepository->updateOne(^Product => *Result<Null, EntryNotFound>) :: $oxRepository->updateOne(#);
ProductRepository->deleteOne(^ProductId => *Result<Null, EntryNotFound>) :: $oxRepository->deleteOne(#);

fn = ^Any => Any %% [repo: ProductRepository] :: {
    oneNotFound = %repo->one(5);
    myProduct = [id: 5, name: 'p5', price: 50.27, description: null];
    insertOneProduct = %repo->insertOne(myProduct);
    insertOneProductAgain = %repo->insertOne(myProduct);
    oneProduct = %repo->one(5);
    myProductUpdated = [id: 5, name: 'p5u', price: 50.56, description: 'Desc 5'];
    updateOneProduct = %repo->updateOne(myProductUpdated);
    missingProduct = [id: 999, name: 'p999', price: 999, description: null];
    updateNotFound = %repo->updateOne(missingProduct);
    products = %repo->all;
    deleteOneProduct = %repo->deleteOne(5);
    deleteNotFound = %repo->deleteOne(5);
    [
        oneNotFound: oneNotFound,
        insertOneProduct: insertOneProduct,
        insertOneProductAgain: insertOneProductAgain,
        oneProduct: oneProduct,
        updateOneProduct: updateOneProduct,
        updateNotFound: updateNotFound,
        allProducts: products,
        deleteOneProduct: deleteOneProduct,
        deleteNotFound: deleteNotFound,
        end: 'end'
    ]
};

main = ^Array<String> => String :: fn()->printed;