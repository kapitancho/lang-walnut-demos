module shopping-cart/model:

ProductId := String<1..>; ProductId ==> String :: $$;
ProductTitle := String<1..>;
ProductPrice := Real<0..>;
ShoppingCartQuantity := Integer<1..>;
ShoppingCartProduct = [id: ProductId, title: String, price: ProductPrice];
ShoppingCartItem = [product: Shape<ShoppingCartProduct>, quantity: Mutable<ShoppingCartQuantity>];
ShoppingCart := $[items: Mutable<Map<ShoppingCartItem>>];
ShoppingCart() :: [items: mutable{Map<ShoppingCartItem>, [:]}];

ProductNotInCart := #[productId: ProductId];
ShoppingCartItemData = [product: Shape<ShoppingCartProduct>, quantity: ShoppingCartQuantity];
ShoppingCart->item(^productId: ProductId => Result<ShoppingCartItemData, ProductNotInCart>) :: {
    existingItem = $items->value->item(productId->asString);
    ?whenTypeOf(existingItem) is {
        type{ShoppingCartItem}: [product: existingItem.product, quantity: existingItem.quantity->value],
        ~: @ProductNotInCart[productId]
    }
}:

ShoppingCart->itemsCount(=> Integer<0..>) :: $items->value->length;
ShoppingCart->addItem(^[product: Shape<ShoppingCartProduct>, quantity: ShoppingCartQuantity] => ShoppingCartQuantity) :: {
    productId = #product->shape(`ShoppingCartProduct).id;
    existingItem = $items->value->item(productId->asString);
    ?whenTypeOf(existingItem) is {
        type{ShoppingCartItem}: {
            existingItem.quantity
                ->SET(ShoppingCartQuantity!{existingItem.quantity->value->value + #quantity->value})
                ->value
        },
        ~: {
            $items->SET($items->value->withKeyValue[
                key: productId->asString,
                value: [product: #product, quantity: mutable{ShoppingCartQuantity, #quantity}]
            ]);
            #quantity
        }
    }
};

BrandName := String<1..>;

ShirtSize := (S, M, L, XL, XXL);
ShirtColor := (Red, Green, Blue, Black, White);
Shirt := $[id: ProductId, model: ProductTitle, price: ProductPrice, size: ShirtSize, color: ShirtColor];
Shirt ==> ShoppingCartProduct :: [
    id: $id,
    title: $model->asString + ' ' + {$color->asString} + ' ' + {$size->asString},
    price: $price
];

MonitorResolution := (HD, FullHD, UHD);
MonitorSize := Real<1..>;
Monitor := $[id: ProductId, brand: BrandName, model: ProductTitle, price: ProductPrice, resolution: MonitorResolution, sizeInInches: MonitorSize];
Monitor ==> ShoppingCartProduct :: [
    id: $id,
    title: {$brand->asString} + ' ' + {$model->asString} + ' ' + {$resolution->asString} + ' ' + $sizeInInches->value->asString + '"',
    price: $price
];

WineProductionYear := Integer<1900..>;
WineProducer := String<1..>;
Wine := $[id: ProductId, producer: WineProducer, name: ProductTitle, price: ProductPrice, year: WineProductionYear];
Wine ==> ShoppingCartProduct :: [
    id: $id,
    title: {$producer->asString} + ' ' + $name->asString + ' ' + {$year->value->asString},
    price: $price
];