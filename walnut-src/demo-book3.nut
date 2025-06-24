module demo-book3:

InvalidIsbn := #[isbn: String];

calculateIsbnChecksum = ^isbn: String<10..10> => Result<Integer, NotANumber> :: {
    ?noError({{isbn->reverse}->chunk(1)}->mapIndexValue(
        ^[index: Integer<0..>, value: String<1..1>] => Result<Integer, NotANumber> :: {
            #value=>asInteger * {#index + 1}
        }
    ))->sum
};

Isbn := #String @ InvalidIsbn|NotANumber :: {
    checksum = ?whenTypeOf(#) is {
        type{String<10..10>}: calculateIsbnChecksum => invoke(#),
        ~: => @InvalidIsbn[#]
    };
    ?whenIsTrue { checksum % 11: => @InvalidIsbn[#], ~: null }
};
UnknownBook := #[~Isbn];
BookTitle := #String<1..200>;
Book := #[~Isbn, ~BookTitle];

BookAdded := #[~Book];
BookReplaced := #[~Book];
BookRemoved := #[~Book];

Library := $[books: Mutable<Map<Book>>];
Library(books: Map<Book>) :: [books: mutable{Map<Book>, books}];

Library->books(=> Map<Book>) :: $books->value;

BookManager = [
    all: ^Null => Array<Book>,
    byIsbn: ^Isbn => Result<Book, UnknownBook>,
    bring: ^Book => BookAdded|BookReplaced,
    remove: ^Book => Result<BookRemoved, UnknownBook>
];

Library ==> BookManager :: {
    byIsbn = ^ ~Isbn => Result<Book, UnknownBook> :: {
        book = $books->value->item(isbn->value);
        ?whenIsError(book) { @UnknownBook[#] }
    };
    [
        all: ^ => Array<Book> :: $books->value->values,
        byIsbn: byIsbn,
        bring: ^ ~Book => BookAdded|BookReplaced :: {
            existingBook = byIsbn(book.isbn);
            $books->SET($books->value->withKeyValue[key: book.isbn->value, value: book]);
            ?whenIsError(existingBook) { BookAdded[#] } ~ { BookReplaced[#] }
        },
        remove: ^ ~Book => Result<BookRemoved, UnknownBook> :: {
            book = byIsbn => invoke(book.isbn);
            newState = $books->value->valuesWithoutKey(book.isbn->value);
            ?whenIsError(newState) { => @UnknownBook[book.isbn] } ~ {
                $books->SET(newState);
            };
            BookRemoved[#]
        }
    ]
};

==> Library :: Library([:]);

==> BookManager %% [~Library] :: %library->as(type{BookManager});

myFn = ^Array<String> => Any %% [~BookManager] :: {
    isbn = ?noError(Isbn('1259060977'));
    book1 = %bookManager.byIsbn(isbn);
    newBook = Book[isbn, BookTitle('My new book')];
    result1 = %bookManager.bring(newBook);
    result2 = %bookManager.bring(newBook);
    result3 = %bookManager.all;
    book2 = %bookManager.byIsbn(isbn);
    result4 = %bookManager.remove(newBook);
    result5 = %bookManager.remove(newBook);
    book3 = %bookManager.byIsbn(isbn);
    [
        validIsbn: isbn,
        invalidIsbn: Isbn('1259060978'),
        bookNotThereYet: book1,
        newlyCreated: newBook,
        afterAdding: result1,
        afterReplacing: result2,
        allBooks: result3,
        retrieved: book2,
        afterRemoval: result4,
        repeatedRemoval: result5,
        cannotBeRetrieved: book3
    ]
};
main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};