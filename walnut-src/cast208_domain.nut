module cast208_domain:

ProductId = Integer<1..>;
Title = String<1..>;
Price = Real<0..>;
Product <: [~ProductId, ~Title, ~Price];
UnknownProduct = $[~ProductId];

ProductById = ^ProductId => Result<Product, UnknownProduct>;