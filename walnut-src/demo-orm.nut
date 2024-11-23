module demo-orm %% db-orm:

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

getAll = ^Null => *Array<Product> %% [~DatabaseConnector] :: {
    query = getSelectAllQuery(type{ProductModel}) /*'SELECT * FROM products'*/
        *> ('Failed to get query for orm model');
    {%databaseConnector
        -> query[query: query, boundParameters: []]}
        *> ('Failed to get products from the database')
        -> map(^DatabaseQueryResultRow => Result<Product, HydrationError> :: #->asJsonValue->hydrateAs(type{Product}))
        *> ('Failed to hydrate products')
};

ProductNotFound = $[id: ProductId];

getOne = ^ProductId => *Result<Product, ProductNotFound> %% [~DatabaseConnector] :: {
    query = getSelectOneQuery(type{ProductModel}) /*'SELECT * FROM products WHERE id = ?'*/
        *> ('Failed to get query for orm model');
    products = {%databaseConnector
          -> query[query: query, boundParameters: [id: #]]
        } *> ('Failed to get product from the database')
          ->map(^DatabaseQueryResultRow => Result<Product, HydrationError> :: #->asJsonValue->hydrateAs(type{Product}))
          *> ('Failed to hydrate products');
    ?whenTypeOf(products) is {
        type{Array<Product, 1..>}: products.0,
        ~: @ProductNotFound[#]
    }
};

insertOne = ^Product => *Null %% [~DatabaseConnector] :: {
    ?whenTypeOf(#) is {
        type{Map<DatabaseValue>}: {
            query = type{ProductModel}->asInsertQuery
                *> ('Failed to get query for orm model');
            result = {%databaseConnector->execute[query: query->asDatabaseSqlQuery, boundParameters: #]}
                *> ('Failed to insert product into the database');
            ?whenTypeOf(result) is {
                type{Integer<1..1>} : null,
                ~: @ExternalError[
                    errorType: 'insert error',
                    originalError: result,
                    errorMessage: 'Failed to insert product into the database'
                ]
            }
        },
        ~: @ExternalError[
            errorType: 'data not suitable',
            originalError: null,
            errorMessage: 'Source data is not suitable'
        ]
    }
};

deleteOne = ^ProductId => *Result<Null, ProductNotFound> %% [~DatabaseConnector] :: {
    query = type{ProductModel}->asDeleteQuery
        *> ('Failed to get query for orm model');
    result = {%databaseConnector->execute[query: query->asDatabaseSqlQuery, boundParameters: [id: #]]}
        -> errorAsExternal('Failed to delete product from the database');
    ?whenTypeOf(result) is {
        type{Integer<1..1>} : null,
        ~: @ProductNotFound[#]
    }
};

updateOne = ^Product => *Result<Null, ProductNotFound> %% [~DatabaseConnector] :: {
    productId = #.id;
    ?whenTypeOf(#) is {
        type{Map<DatabaseValue>}: {
            query = type{ProductModel}->asUpdateQuery
                *> ('Failed to get query for orm model');
            result = {%databaseConnector->execute[query: query->asDatabaseSqlQuery, boundParameters: #]}
                *> ('Failed to update product in the database');
            ?whenTypeOf(result) is {
                type{Integer<1..1>} : null,
                ~: @ProductNotFound[productId]
            }
        },
        ~: @ExternalError[
            errorType: 'data not suitable',
            originalError: null,
            errorMessage: 'Source data is not suitable'
        ]
    }
};

main = ^Array<String> => String :: {
    oneNotFound = getOne(5);
    myProduct = [id: 5, name: 'p5', price: 50.27, description: null];
    insertOneProduct = insertOne(myProduct);
    oneProduct = getOne(5);
    myProductUpdated = [id: 5, name: 'p5u', price: 50.56, description: 'Desc 5'];
    updateOneProduct = updateOne(myProductUpdated);
    missingProduct = [id: 999, name: 'p999', price: 999, description: null];
    updateNotFound = updateOne(missingProduct);
    products = getAll();
    deleteOneProduct = deleteOne(5);
    deleteNotFound = deleteOne(5);
    [
        oneNotFound: oneNotFound,
        insertOneProduct: insertOneProduct,
        oneProduct: oneProduct,
        updateOneProduct: updateOneProduct,
        updateNotFound: updateNotFound,
        allProducts: products,
        deleteOneProduct: deleteOneProduct,
        deleteNotFound: deleteNotFound,
        end: 'end'
    ]->printed
};