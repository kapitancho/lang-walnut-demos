module demo-book2:

InvalidIsbn = #[isbn: String];

calculateIsbnChecksum = ^isbn: String<10..10> => Result<Integer, NotANumber> :: {
    ?noError({{isbn->reverse}->chunk(1)}->mapIndexValue(
        ^[index: Integer<0..>, value: String<1..1>] => Result<Integer, NotANumber> :: {
            #value=>asInteger * {#index + 1}
        }
    ))->sum
};

Isbn = #String @ InvalidIsbn|NotANumber :: {
    checksum = ?whenTypeOf(#) is {
        type{String<10..10>}: calculateIsbnChecksum => invoke(#),
        ~: => @InvalidIsbn[#]
    };
    ?whenIsTrue { checksum % 11: => @InvalidIsbn[#], ~: null }
};
UnknownBook = #[~Isbn];
BookTitle = #String<1..200>;
Book = #[~Isbn, ~BookTitle];

BookByIsbn = ^Isbn => Result<Book, UnknownBook>;

BookAdded = #[~Book];
BookReplaced = #[~Book];

BringBookToLibrary = ^Book => BookAdded|BookReplaced;

BookRemoved = #[~Book];
RemoveBookFromLibrary = ^Book => Result<BookRemoved, UnknownBook>;

AllLibraryBooks = ^Null => Array<Book>;

Library = $[books: Mutable<Map<Book>>];
Library->books(=> Mutable<Map<Book>>) :: $books;

==> BookByIsbn %% [~Library] :: ^Isbn => Result<Book, UnknownBook> :: {
    book = {%library->books->value}->item(#->value);
    ?whenIsError(book) { @UnknownBook[#] }
};

==> BringBookToLibrary %% [~Library] :: ^Book => BookAdded|BookReplaced :: {
    book = {%library->books->value}->item(#.isbn->value);
    {%library->books}->SET(
        {%library->books->value}->withKeyValue[key: #.isbn->value, value: #]
    );
    ?whenTypeOf(book) is {
        type{Result<Nothing, MapItemNotFound>}: BookAdded[#],
        type{Book}: BookReplaced[#]
    }
};

==> RemoveBookFromLibrary %% [~Library] :: ^Book => Result<BookRemoved, UnknownBook> :: {
    book = {%library->books->value}->item(#.isbn->value);
    result = ?whenIsError(book) { => @UnknownBook[#.isbn] } ~ { BookRemoved[#] };
    newState = %library->books->value->valuesWithoutKey(#.isbn->value);
    ?whenTypeOf(newState) is {
        type{Map<Book>}: {%library->books}->SET(newState),
        ~: => @UnknownBook[#.isbn]
    };
    result
};

==> AllLibraryBooks %% [~Library] :: ^Null => Array<Book> :: {
    {%library->books->value}->values
};
==> Library :: Library[books: mutable{Map<Book>, [:]}];

RenameBook = ^BookTitle => Book;

BookManager = :[];
BookManager->bookByIsbn(^ ~Isbn => Result<Book, UnknownBook>) %% [~BookByIsbn] :: %bookByIsbn(isbn);
BookManager->bringBookToLibrary(^ ~Book => BookAdded|BookReplaced) %% [~BringBookToLibrary] :: %bringBookToLibrary(book);
BookManager->allLibraryBooks(=> Array<Book>) %% [~AllLibraryBooks] :: %allLibraryBooks();
BookManager->removeBookFromLibrary(^ ~Book => Result<BookRemoved, UnknownBook>) %% [~RemoveBookFromLibrary] :: %removeBookFromLibrary(book);

myFn = ^Array<String> => Any %% [~BookManager] :: {
    isbn = ?noError(Isbn('1259060977'));
    book1 = %bookManager->bookByIsbn(isbn);
    newBook = Book[isbn, BookTitle('My new book')];
    result1 = %bookManager->bringBookToLibrary(newBook);
    result2 = %bookManager->bringBookToLibrary(newBook);
    result3 = %bookManager->allLibraryBooks;
    book2 = %bookManager->bookByIsbn(isbn);
    result4 = %bookManager->removeBookFromLibrary(newBook);
    result5 = %bookManager->removeBookFromLibrary(newBook);
    book3 = %bookManager->bookByIsbn(isbn);
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