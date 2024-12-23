module demo-tpl-model:

Product = [id: Integer<1..>, name: String<1..>, price: Real<0..>];
ProductList = [products: Array<Product>];

ProductPage = [productList: ProductList, title: String<1..>];