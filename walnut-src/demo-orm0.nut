module demo-orm %% db:

==> DatabaseConnection :: DatabaseConnection['sqlite:db.sqlite'];

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

DatabaseTableName = String<1..>;
DatabaseFieldName = String<1..>;
OrmModel <: [table: DatabaseTableName, keyField: DatabaseFieldName, sequenceField: ?DatabaseFieldName];
UnknownOrmModel = $[type: Type];
ProductModel = Type<Product>;
ProductModel ==> OrmModel :: OrmModel[table: 'products', keyField: 'id', sequenceField: 'price'];

gTypes = ^Any => Map<Type> :: {
    ?whenTypeOf(#) is {
        type{Type<Subtype>}: gTypes(#->baseType),
        type{Type<Record>}: #->itemTypes,
        type{Type<Alias>}: gTypes(#->aliasedType),
        type{Type<Type>}: gTypes(#->refType),
        ~: [:]
    }
};

typeToOrmModel = ^Type => Result<OrmModel, UnknownOrmModel> :: {
    ormModel = #->as(type{OrmModel});
    ?whenTypeOf(ormModel) is {
        type{OrmModel}: ormModel,
        ~: @UnknownOrmModel[#]
    }
};

getSelectAllQuery = ^Type => Result<DatabaseSqlQuery, UnknownOrmModel> :: {
    ormModel = ?noError(typeToOrmModel(#));
    t = gTypes(#)->keys;
    fields = ?whenTypeOf(t) is {
        type{Array<String, 1..>}: t,
        ~: ['*']
    };
    sf = ormModel.sequenceField;
    orderBy = ?whenTypeOf(sf) is {
        type{String<1..>}: [' ORDER BY ', sf]->combineAsString(''),
        ~: ''
    };
    'SELECT '->concatList[
        fields->combineAsString(', '),
        ' FROM ',
        ormModel.table,
        orderBy
    ]
};


getAll = ^Null => Result<Array<Product>, ExternalError> %% [~DatabaseConnector] :: {
    query = getSelectAllQuery(type{ProductModel}) /*'SELECT * FROM products'*/;
    ?whenTypeOf(query) is {
        type{DatabaseSqlQuery}: {
            data = %databaseConnector->query[query: query, boundParameters: []];
            ?whenTypeOf(data) is {
                type{DatabaseQueryResult}: {
                    products = data->map(
                        ^DatabaseQueryResultRow => Result<Product, HydrationError> :: #->asJsonValue->hydrateAs(type{Product})
                    );
                    ?whenTypeOf(products) is {
                        type{Array<Product>}: products,
                        ~:  @ExternalError[
                            errorType: 'hydration error',
                            originalError: products,
                            errorMessage: 'Failed to hydrate products'
                        ]
                    }
                },
                type{Error<DatabaseQueryFailure>}: @ExternalError[
                    errorType: 'database error',
                    originalError: data,
                    errorMessage: 'Failed to get products from the database'
                ]
            }
        },
        type{Error<UnknownOrmModel>}: @ExternalError[
            errorType: 'unknown orm model',
            originalError: query,
            errorMessage: 'Failed to get query for orm model'
        ]
    }
};

getSelectOneQuery = ^Type => Result<DatabaseSqlQuery, UnknownOrmModel> :: {
    ormModel = ?noError(typeToOrmModel(#));
    t = gTypes(#)->keys;
    fields = ?whenTypeOf(t) is {
        type{Array<String, 1..>}: t,
        ~: ['*']
    };
    sf = ormModel.sequenceField;
    'SELECT '->concatList[
        fields->combineAsString(', '),
        ' FROM ',
        ormModel.table,
        ' WHERE ',
        ormModel.keyField,
        ' = ?'
    ]
};

ProductNotFound = $[id: ProductId];

getOne = ^ProductId => Result<Product, ProductNotFound|ExternalError> %% [~DatabaseConnector] :: {
    query = getSelectOneQuery(type{ProductModel}) /*'SELECT * FROM products WHERE id = ?'*/;
    ?whenTypeOf(query) is {
        type{DatabaseSqlQuery}: {
            data = %databaseConnector->query[query: query, boundParameters: [#]];
            ?whenTypeOf(data) is {
                type{DatabaseQueryResult}: {
                    products = data->map(
                        ^DatabaseQueryResultRow => Result<Product, HydrationError> :: #->asJsonValue->hydrateAs(type{Product})
                    );
                    ?whenTypeOf(products) is {
                        type{Array<Product, 1..>}: products.0,
                        type{Array<Product, 0..0>}: @ProductNotFound[#],
                        ~:  @ExternalError[
                            errorType: 'hydration error',
                            originalError: products,
                            errorMessage: 'Failed to hydrate products'
                        ]
                    }
                },
                type{Error<DatabaseQueryFailure>}: @ExternalError[
                    errorType: 'database error',
                    originalError: data,
                    errorMessage: 'Failed to get products from the database'
                ]
            }
        },
        type{Error<UnknownOrmModel>}: @ExternalError[
            errorType: 'unknown orm model',
            originalError: query,
            errorMessage: 'Failed to get query for orm model'
        ]
    }
};

getInsertQuery = ^Type => Result<DatabaseSqlQuery, UnknownOrmModel> :: {
    ormModel = ?noError(typeToOrmModel(#));
    t = gTypes(#)->keys;
    fields = ?whenTypeOf(t) is {
        type{Array<String, 1..>}: t,
        ~: ['*']
    };
    sf = ormModel.sequenceField;
    'INSERT INTO '->concatList[
        ormModel.table,
        ' (',
        fields->combineAsString(', '),
        ') VALUES (',
        fields->map(^String => String :: ':'->concat(#))->combineAsString(', '),
        ')'
    ]
};

insertOne = ^Product => Result<Null, ExternalError> %% [~DatabaseConnector] :: {
    ?whenTypeOf(#) is {
        type{Map<DatabaseValue>}: {
            query = getInsertQuery(type{ProductModel}) /*'INSERT INTO products (id, name, price) VALUES (:id, :name, :price)'*/;
            ?whenTypeOf(query) is {
                type{DatabaseSqlQuery}: {
                    result = %databaseConnector->execute[query: query, boundParameters: #];
                    ?whenTypeOf(result) is {
                        type{Integer<1..1>} : null,
                        type{Integer}: @ExternalError[
                            errorType: 'insert error',
                            originalError: result,
                            errorMessage: 'Failed to insert product into the database'
                        ],
                        type{Error<DatabaseQueryFailure>}: @ExternalError[
                            errorType: 'database error',
                            originalError: result,
                            errorMessage: 'Failed to insert product into the database'
                        ]
                    }
                },
                type{Error<UnknownOrmModel>}: @ExternalError[
                    errorType: 'unknown orm model',
                    originalError: query,
                    errorMessage: 'Failed to get query for orm model'
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

getDeleteQuery = ^Type => Result<DatabaseSqlQuery, UnknownOrmModel> :: {
    ormModel = ?noError(typeToOrmModel(#));
    'DELETE FROM '->concatList[
        ormModel.table,
        ' WHERE ',
        ormModel.keyField,
        ' = ?'
    ]
};

deleteOne = ^ProductId => Result<Null, ProductNotFound|ExternalError> %% [~DatabaseConnector] :: {
    query = getDeleteQuery(type{ProductModel}) /*'DELETE FROM products WHERE id = ?'*/;
    ?whenTypeOf(query) is {
        type{DatabaseSqlQuery}: {
            result = %databaseConnector->execute[query: query, boundParameters: [#]];
            ?whenTypeOf(result) is {
                type{Integer<1..1>} : null,
                type{Integer}: @ProductNotFound[#],
                type{Error<DatabaseQueryFailure>}: @ExternalError[
                    errorType: 'database error',
                    originalError: result,
                    errorMessage: 'Failed to delete product from the database'
                ]
            }
        },
        type{Error<UnknownOrmModel>}: @ExternalError[
            errorType: 'unknown orm model',
            originalError: query,
            errorMessage: 'Failed to get query for orm model'
        ]
    }
};

getUpdateQuery = ^Type => Result<DatabaseSqlQuery, UnknownOrmModel> :: {
    ormModel = ?noError(typeToOrmModel(#));
    t = gTypes(#)->keys;
    fields = ?whenTypeOf(t) is {
        type{Array<String, 1..>}: t,
        ~: ['*']
    }->filter(^String => Boolean :: # != ormModel.keyField);
    sf = ormModel.sequenceField;
    'UPDATE '->concatList[
        ormModel.table,
        ' SET ',
        fields->map(^String => String :: ''->concatList[#, ' = :', #])->combineAsString(', '),
        ' WHERE ',
        ormModel.keyField,
        ' = :',
        ormModel.keyField
    ]
};

updateOne = ^Product => Result<Null, ProductNotFound|ExternalError> %% [~DatabaseConnector] :: {
    productId = #.id;
    ?whenTypeOf(#) is {
        type{Map<DatabaseValue>}: {
            query = getUpdateQuery(type{ProductModel}) /*'UPDATE products SET name = :name, price = :price WHERE id = :id'*/;
            ?whenTypeOf(query) is {
                type{DatabaseSqlQuery}: {
                    result = %databaseConnector->execute[query: query, boundParameters: #];
                    ?whenTypeOf(result) is {
                        type{Integer<1..1>} : null,
                        type{Integer}: @ProductNotFound[productId],
                        type{Error<DatabaseQueryFailure>}: @ExternalError[
                            errorType: 'database error',
                            originalError: result,
                            errorMessage: 'Failed to update product in the database'
                        ]
                    }
                },
                type{Error<UnknownOrmModel>}: @ExternalError[
                    errorType: 'unknown orm model',
                    originalError: query,
                    errorMessage: 'Failed to get query for orm model'
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