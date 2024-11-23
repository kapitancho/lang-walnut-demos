module cast20:

Point <: [x: Real, y: Real];

KeyNotFound = $[key: String];
ValueAdded = :[];
ValueReplaced = :[];
ValueRemoved = :[];

KeyValueStorage = [
    hasWithKey: ^[key: String] => Boolean,
    getByKey: ^[key: String] => Result<Map, KeyNotFound>,
    storeByKey: ^[key: String, value: Map] => ValueAdded|ValueReplaced,
    removeByKey: ^[key: String] => Result<ValueRemoved, KeyNotFound>
];

InMemoryKeyValueStorage <: [storage: Mutable<Map>];

InvalidProductId = $[value: Any];
ProductId = Integer<1..>;

InvalidProductName = $[value: Any];
ProductName = String<1..>;
Product <: [~ProductId, ~ProductName];

ProductNotFound = $[~ProductId];
ProductAdded = :[];
ProductReplaced = :[];
ProductRemoved = :[];

ProductRepository = [
    byId: ^[~ProductId] => Result<Product, ProductNotFound>,
    store: ^[~Product] => ProductAdded|ProductReplaced,
    remove: ^[~ProductId] => Result<ProductRemoved, ProductNotFound>,
    all: ^Null => Array<Product>
];

KeyValueStorageProductRepository <: [~KeyValueStorage];

Product ==> Map :: {
    [productId: $.productId, productName: $.productName]
};

Any ==> ProductId @ InvalidProductId :: {
    ?whenTypeOf($) is {
        type{Integer<1..>}: $,
        ~: Error(InvalidProductId[$])
    }
};

Any ==> ProductName @ InvalidProductName :: {
    ?whenTypeOf($) is {
        type{String<1..>}: $,
        ~: Error(InvalidProductName[$])
    }
};

Map ==> Product @ MapItemNotFound :: {
    Product[
        ?noError($->item('productId'))->as(type{ProductId}),
        ?noError($->item('productName'))->as(type{ProductName})
    ]
};


KeyValueStorageProductRepository ==> ProductRepository :: [
    byId: ^[~ProductId] => Result<Product, ProductNotFound> :: {
        data = $.keyValueStorage.getByKey[#.productId->asString];
        data = ?whenTypeOf(data) is {
            type{Map}: data->as(type{Product}),
            ~: data
        };
        data = ?whenTypeOf(data) is {
            type{Product}: data,
            ~: Error(ProductNotFound[#.productId])
        }
    },
    store: ^[~Product] => ProductAdded|ProductReplaced :: {
        key = #.product.productId->asString;
        exists = $.keyValueStorage.hasWithKey[key];
        $.keyValueStorage.storeByKey[key, #.product->as(type{Map})];
        ?whenIsTrue { exists: ProductReplaced[], ~: ProductAdded[] }
    },
    remove: ^[~ProductId] => Result<ProductRemoved, ProductNotFound> :: ProductRemoved[],
    all: ^Null => Array<Product> :: []
];


InMemoryKeyValueStorage ==> KeyValueStorage :: [
    hasWithKey: ^[key: String] => Boolean :: {
        {$.storage->value}->keyExists(#.key)
    },
    getByKey: ^[key: String] => Result<Map, KeyNotFound> :: {
        item = $.storage->value->item(#.key);
        ?whenTypeOf(item) is {
            type{Map}: item,
            type{Result<Nothing, MapItemNotFound>}: => Error(KeyNotFound[#.key]),
            ~: Error(KeyNotFound['unknown-key'])
        }
    },
    storeByKey: ^[key: String, value: Map] => ValueAdded|ValueReplaced :: {
        keyExists = {$.storage->value}->keyExists(#.key);
        $.storage->SET({$.storage->value}->withKeyValue[key: #.key, value: #.value]);
        ?whenIsTrue { keyExists: ValueReplaced[], ~: ValueAdded[] }
    },
    removeByKey: ^[key: String] => Result<ValueRemoved, KeyNotFound> :: {
        m = $.storage->value->valuesWithoutKey(#.key);
        ?whenTypeOf(m) is {
            type{Result<Nothing, MapItemNotFound>}: => Error(KeyNotFound[#.key]),
            type{Map}: { $.storage->SET(m); ValueRemoved[] }
        }
    }
]->as(type{KeyValueStorage});

myFn = ^Array<String> => Any :: {
    p = Point[4, 7];
    storage = {InMemoryKeyValueStorage[Mutable[type{Map}, [:]]]}->as(type{KeyValueStorage});
    step1 = storage.getByKey[key: 'x'];
    step2 = storage.storeByKey[key: 'x', value: [k: 1]];
    step3 = storage.getByKey[key: 'x'];
    step4 = storage.storeByKey[key: 'x', value: [k: 2]];
    step5 = storage.getByKey[key: 'x'];
    step6 = storage.removeByKey[key: 'x'];
    step7 = storage.getByKey[key: 'x'];
    step8 = storage.removeByKey[key: 'x'];
    storage.storeByKey[key: '5', value: [productId: 5, productName: 'Product Test']];
    repo = {KeyValueStorageProductRepository([storage])}->as(type{ProductRepository});
    product5 = repo.byId[productId: 5];
    product6a = repo.byId[productId: 6];
    step11 = repo.store[product: Product[6, 'Cool Product']];
    product6b = repo.byId[productId: 6];
    [
        p,
        step1, step2, step3, step4, step5, step6, step7, step8,
        {['A', 'B', 'C']}->combineAsString(', '),
        product5,
        product6a,
        step11,
        product6b
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};