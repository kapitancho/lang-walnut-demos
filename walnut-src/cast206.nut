module cast206 %% db:

/* approach 1 */
ProductId = String;
Title = String;
Price = Real<0..>;
Product = [~ProductId, ~Title, ~Price];

UnknownProductId = $[~ProductId];
ProductUpdated = $[~Product];
ProductUpdated->product(^Null => Product) :: $.product;

IdGenerator = ^Null => String;
DependencyContainer ==> IdGenerator :: ^Null => String :: 'rand';/* php{'md5(rand())'};*/


ProductIdGenerator = ^Null => ProductId;
ProductById = ^ProductId => Result<Product, UnknownProductId>;

==> DatabaseConnection :: DatabaseConnection['sqlite:db.sqlite'];

DependencyContainer ==> ProductIdGenerator %% IdGenerator :: ^Null => ProductId :: {
    %()
};

ProductStorage = $[products: Mutable<Map<Product>>];
ProductStorage(Map<Product>) :: [products: Mutable[type{Map<Product>}, #]];
ProductStorage->products(^Null => Map<Product>) :: $.products->value;
ProductStorage->store(^Product => Product) :: {
    products = $.products->value;
    $.products->SET(products->withKeyValue[key: #.productId, value: #]);
    #
};

/*DependencyContainer ==> ProductStorage :: ProductStorage([:]);*/
DependencyContainer ==> ProductStorage :: ProductStorage[
    productId: [productId: 'productId', title: 'myOldTitle', price: 10.0]
];

DependencyContainer ==> ProductById %% ProductStorage :: ^ProductId => Result<Product, UnknownProductId> :: {
    p = %->products->item(#);
    ?whenTypeOf(p) is {
        type{Product}: p,
        ~: Error(UnknownProductId[#])
    }
};

/*
DependencyContainer ==> ProductById :: ^ProductId => Result<Product, UnknownProductId> :: {
    [productId: 'productId', title: 'myOldTitle', price: 10.0]
};
*/

UpdateProductTitleCommand = [~ProductId, ~Title];
UpdateProductTitleCommandHandler = ^UpdateProductTitleCommand => Result<ProductUpdated, UnknownProductId>;

EventBroadcaster = ^Any => Any;

DependencyContainer ==> EventBroadcaster %% ProductStorage :: ^Any => Any :: {
    ?whenTypeOf(#) is {
        type{ProductUpdated}: %->store(#->product),
        ~: null
    }
};

DependencyContainer ==> UpdateProductTitleCommandHandler %% [~ProductById, ~EventBroadcaster] :: {
    ^UpdateProductTitleCommand => Result<ProductUpdated, UnknownProductId> :: {
        product = ?noError(%.productById(#.productId));
        event = ProductUpdated[product->with[title: #.title]];
        %.eventBroadcaster(event);
        event
    }
};

ProductController = :[];
ProductController->updateTitle(^UpdateProductTitleCommand => Any) %% UpdateProductTitleCommandHandler :: %(#);

myFn = ^Array<String> => Any :: {
    s = DependencyContainer[]=>valueOf(type{ProductStorage});
    before = s->products->item('productId');
    x = ProductController[]->updateTitle([productId: 'productId', title: 'myNewTitle']);
    after = s->products->item('productId');
    [
        before,
        x,
        after,
        ?noError(DependencyContainer[]->valueOf(type{ProductIdGenerator}))()
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};