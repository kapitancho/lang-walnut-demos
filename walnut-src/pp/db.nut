module pp/db %% $db/core, pp/model:

DatabaseQueryResultRow ==> Product @ Any :: Product[
    id: $=>item('id')=>hydrateAs(type{ProductId}),
    name: $=>item('name')=>hydrateAs(type{ProductName}),
    price: $=>item('price')=>asReal=>hydrateAs(type{ProductPrice})
];

==> ProductList :: ^ => *Array<Product> %% [~DatabaseConnector] :: {
    query = 'SELECT * FROM products';
    {%databaseConnector
        -> query[query: query, boundParameters: []]}
        *> ('Failed to get entries from the database')
        -> map(^row: DatabaseQueryResultRow => Result<Product, Any> :: row=>as(type{Product}))
        *> ('Failed to hydrate entries')
};
==> ProductById :: ^ ~ProductId => *Result<Product, UnknownProductId> %% [~DatabaseConnector] :: {
    query = 'SELECT * FROM products WHERE id := productId';
    entries = {%databaseConnector
        -> query[query: query, boundParameters: [productId: productId->value]]
        } *> ('Failed to get entry from the database')
        ->map(^row: DatabaseQueryResultRow => Result<Product, Any> :: row=>as(type{Product}))
        *> ('Failed to hydrate entry');
    ?whenTypeOf(entries) is {
        type{Array<1..>}: entries.0,
        ~: @UnknownProductId(productId)
    }
};