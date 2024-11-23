module cast207:

ProductId = Integer<1..>;
Title = String<1..>;
Price = Real<0..>;
Product <: [~ProductId, ~Title, ~Price];
Product->asString(^Null => String) ::
    ''->concatList[$.productId->asString, ' ', $.title, ' ', $.price->asString];
InvalidProduct = $[~ProductId];

/*test of an error message for a global variable: x = ^Integer => String :: 3;*/
/*test of an error return type for a subtype: MySubtype <: String @ Integer :: => Error('A text');*/
/*test of an error in a method: Product->asStringX(^Null => String) :: ''->concatList[$.productId->asString, ' ', $.title, ' ', $.price];*/
/*test of an error in a constructor: InvalidProduct(^Integer<1..> => ProductId) :: 'hi';*/
/*test of an error in a cast: Integer ==> InvalidProduct :: 1;*/
/*test of an error in a dependency builder: ==> InvalidProduct :: 1; ;*/
/*test of an error in a dependency: Product->asStringY(^Null => String) %% InvalidProduct :: 'hi';*/

myFn = ^Array<String> => Any :: {
    p = Product[1, 'Title', 3.14];
    /*test of an error in a local function: f = ^Product => String :: 5;*/
    p->asString
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};