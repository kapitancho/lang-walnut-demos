module demo-sub:

InvalidUuid = :[];
Uuid <: String @ InvalidUuid :: ?when({#->length} != 36) { => @InvalidUuid[] };
ProductId <: Uuid;
UserId <: Uuid;

Product = $[
    id: ProductId,
    name: String
];
getProductById = ^ProductId => Product :: Product[
    id: #,
    name: 'Product Name'
];

getHash = ^String => String :: #->reverse;

fn = ^Any => Any :: {
    productId = ProductId(?noError(Uuid('123e4567-e89b-12d3-a456-426614174000')));
    userId = UserId(?noError(Uuid('123e4567-e89b-12d3-a456-426614174001')));
    [
        hash: getHash(productId),
        product: getProductById(productId)
    ];
};

main = ^Any => String :: fn()->printed;