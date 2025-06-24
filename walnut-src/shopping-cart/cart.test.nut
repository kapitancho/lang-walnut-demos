module shopping-cart/cart %% $test/runner, shopping-cart/model:

==> TestCases :: {
    getShoppingCart = ^ => ShoppingCart :: ShoppingCart();
    getShirt = ^ => Shirt :: Shirt[
        id: ProductId!'shirt-1',
        model: ProductTitle!'Gucci Pro',
        price: ProductPrice!100.0,
        size: ShirtSize.M,
        color: ShirtColor.Black
    ];
    getMonitor = ^ => Monitor :: Monitor[
        id: ProductId!'monitor-1',
        brand: BrandName!'Dell',
        model: ProductTitle!'UltraSharp',
        price: ProductPrice!200.0,
        resolution: MonitorResolution.FullHD,
        sizeInInches: MonitorSize!24.0
    ];
    getWine = ^ => Wine :: Wine[
        id: ProductId!'wine-1',
        producer: WineProducer!'Chateau Margaux',
        name: ProductTitle!'Grand Cru',
        price: ProductPrice!300.0,
        year: WineProductionYear!2010
    ];
    /*=> [
        ^ => TestResult :: TestResult['Temporarily ignored', 0, ^ :: 0]
    ];*/
    [
        ^ => TestResult :: {
            TestResult['A new shopping cart is empty', 0, ^ :: getShoppingCart()->itemsCount]
        },
        ^ => TestResult :: {
            shoppingCart = getShoppingCart();
            shirt = getShirt();
            shoppingCart->addItem[shirt, ShoppingCartQuantity!1];
            TestResult['Add a shirt to a shopping cart', 1, ^ :: shoppingCart->itemsCount]
        },
        ^ => TestResult :: {
            shoppingCart = getShoppingCart();
            shirt = getShirt();
            shoppingCart->addItem[shirt, ShoppingCartQuantity!1];
            TestResult['The added product is the same shirt', shirt,
                ^ :: shoppingCart=>item(ProductId!'shirt-1').product]
        },
        ^ => TestResult :: {
            shoppingCart = getShoppingCart();
            shirt = getShirt();
            shoppingCart->addItem[shirt, ShoppingCartQuantity!1];
            shoppingCart->addItem[shirt, ShoppingCartQuantity!1];
            TestResult['Add the same shirt twice to a shopping cart', 1, ^ :: shoppingCart->itemsCount]
        },
        ^ => TestResult :: {
            shoppingCart = getShoppingCart();
            shirt = getShirt();
            shoppingCart->addItem[shirt, ShoppingCartQuantity!1];
            shoppingCart->addItem[shirt, ShoppingCartQuantity!4];
            TestResult['The number of shirts in a shopping cart is 5', 5,
                ^ :: shoppingCart=>item(ProductId!'shirt-1').quantity->value
            ]
        },
        ^ => TestResult :: {
            shoppingCart = getShoppingCart();
            shoppingCart->addItem[getShirt(), ShoppingCartQuantity!1];
            shoppingCart->addItem[getMonitor(), ShoppingCartQuantity!4];
            shoppingCart->addItem[getWine(), ShoppingCartQuantity!2];
            TestResult['Add distinct products to a shopping cart', 3, ^ :: shoppingCart->itemsCount]
        }
    ]
};