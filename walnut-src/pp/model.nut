module pp/model:

ProductId := # Integer<1..>;
ProductName := # String<1..>;
ProductPrice := # Real<0..>;
Product := #[id: ProductId, name: ProductName, price: ProductPrice];

UnknownProductId := # ProductId;
ProductList = ^Null => *Array<Product>;
ProductById = ^ProductId => *Result<Product, UnknownProductId>;
