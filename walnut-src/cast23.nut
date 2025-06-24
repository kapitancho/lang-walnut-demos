module cast23 %% $db/core:

Point := #[x: Real, y: Real];
PositiveInteger = Integer<1..>;
Suit := (Spades, Hearts, Diamonds, Clubs);
pi = 3.1415927;

suit = ^String => Result<Suit, UnknownEnumerationValue> :: {
    type{Suit}->valueWithName(#)
};

InvalidProductId := $[productId: Integer];
ProductId = Integer<1..>;

InvalidProductName := $[productName: JsonValue];
ProductName := #String<1..>;
Product := $[~ProductId, ~ProductName];
Point ==> String :: ''->concatList['{', {$x}->asString, ',', {$y}->asString, '}'];

Product ==> Map :: {
    [productId: $productId, productName: $productName]
};

getData = ^DatabaseConnector => Result<Array<Product>, MapItemNotFound|HydrationError|DatabaseQueryFailure|InvalidProductName> :: {
    data = ?noError(#->query[query: 'SELECT id, name FROM cast4 limit 3', boundParameters: []]);
    data->map(mapToProduct)
};

mapToProduct = ^row: DatabaseQueryResultRow => Result<Product, MapItemNotFound|HydrationError|InvalidProductName> :: {
    Product[
        row=>item('id')->asJsonValue=>hydrateAs(`ProductId),
        row=>item('name')=>as(`ProductName)
    ]
};

getDataX = ^DatabaseConnector => Result<Array<Product>, HydrationError|MapItemNotFound|InvalidProductName|DatabaseQueryFailure> :: {
        data = #=>query[query: 'SELECT id, name FROM cast4 limit 3', boundParameters: []];
        data->map(mapToProductX)
};

mapToProductX = ^row: DatabaseQueryResultRow => Result<Product, HydrationError|MapItemNotFound|InvalidProductName> :: {
    row->as(`Product)
};

getDataY = ^[~DatabaseConnector, targetType: Type] => Result<Array, MapItemNotFound|CastNotAvailable|InvalidProductName|DatabaseQueryFailure> :: {
    data = #.databaseConnector=>query[query: 'SELECT id, name FROM cast4 limit 3', boundParameters: []];
    data->map(mapToProductY[#.targetType])
};

MapX = ^Map => Result<Any, MapItemNotFound|CastNotAvailable|InvalidProductName|DatabaseQueryFailure>;

mapToProductY = ^[targetType: Type] => MapX :: {
    targetType = #.targetType;
    ^Map => Result<Any, MapItemNotFound|CastNotAvailable|InvalidProductName|DatabaseQueryFailure> :: {
        #->as(targetType)
    }
};

ProductArray = Array<Product>;

getDataZ = ^[~DatabaseConnector] => Result<Array, MapItemNotFound|CastNotAvailable|InvalidProductName|DatabaseQueryFailure> :: {
    c = getDataY[#.databaseConnector, `Product]
};

getRow = ^DatabaseConnector => Result<Product, MapItemNotFound|HydrationError|InvalidProductName|DatabaseQueryFailure|IndexOutOfRange> :: {
    data = #=>query[query: 'SELECT id, name FROM cast4 limit 3', boundParameters: []];
    row = data=>item(0);
    mapToProduct(row)
};

getRowE = ^DatabaseConnector => Result<Product, MapItemNotFound|HydrationError|InvalidProductName|DatabaseQueryFailure|IndexOutOfRange> :: {
    data = #=>query[query: 'SELECT id, name FOM cast4 limit 3', boundParameters: []];
    row = data=>item(0);
    mapToProduct(row)
};

==> DatabaseConnection :: DatabaseConnection![dsn: 'sqlite:db.sqlite'];

myFn = ^Array<Any> => Any :: {
    /*Point[pi, 42]->as(type{String});*/
    connection = DatabaseConnection![dsn: 'sqlite:db.sqlite'];
    connector = DatabaseConnector[connection];
    [
        suit('Spades'),
        suit('King'),
        getData(connector),
        getDataX(connector),
        getDataY[connector, type{Product}],
        getDataZ[connector],
        getRow(connector),
        getRowE(connector)
    ]
};
DatabaseValue ==> ProductName @ InvalidProductName :: {
    x = $->as(`String);
    ?whenTypeOf(x) is { `ProductName: x, ~: @InvalidProductName[$] }
};
DatabaseQueryResultRow ==> Product @ HydrationError|MapItemNotFound|InvalidProductName :: {
    Product[
        $=>item('id')=>hydrateAs(`ProductId),
        $=>item('name')=>as(`ProductName)
    ]
};
main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};