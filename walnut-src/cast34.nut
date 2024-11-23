module cast34:

InvalidIsbn = $[isbn: String];
calculateIsbnChecksum = ^[isbn: String<10..10>] => Result<Integer, NotANumber> :: {
    ?noError({{#.isbn->reverse}->chunk(1)}->mapIndexValue(
        ^[index: Integer<0..>, value: String<1..1>] => Result<Integer, NotANumber> :: {
            ?noError(#.value->asInteger) * {#.index + 1}
        }
    ))->sum
};

Isbn <: String @ InvalidIsbn|NotANumber :: {
    checksum = ?noError(?whenTypeOf(#) is {
        type{String<10..10>}: calculateIsbnChecksum[#],
        ~: => @InvalidIsbn[#]
    });
    ?whenIsTrue { checksum % 11: @InvalidIsbn[#], ~: null }
};
UnknownBook = $[~Isbn];
BookTitle <: String<1..200>;
Book <: [~Isbn, ~BookTitle];

BookByIsbn = ^Isbn => Result<Book, UnknownBook>;

BookAdded <: [~Book];
BookReplaced <: [~Book];

BringBookToLibrary = ^Book => BookAdded|BookReplaced;

BookRemoved <: [~Book];
RemoveBookFromLibrary = ^Book => Result<BookRemoved, UnknownBook>;

AllLibraryBooks = ^Null => Array<Book>;

Library = $[books: Mutable<Map<Book>>];
Library->books(^Null => Mutable<Map<Book>>) :: $.books;

DependencyContainer ==> BookByIsbn %% Library :: ^Isbn => Result<Book, UnknownBook> :: {
    book = {%->books->value}->item(#->baseValue);
    ?whenTypeOf(book) is {
        type{Result<Nothing, MapItemNotFound>}: @UnknownBook[#],
        type{Book}: book
    }
};

DependencyContainer ==> BringBookToLibrary %% Library :: ^Book => BookAdded|BookReplaced :: {
    book = {%->books->value}->item(#.isbn->baseValue);
    {%->books}->SET(
        {%->books->value}->withKeyValue[key: #.isbn->baseValue, value: #]
    );
    ?whenTypeOf(book) is {
        type{Result<Nothing, MapItemNotFound>}: BookAdded[#],
        type{Book}: BookReplaced[#]
    }
};

DependencyContainer ==> RemoveBookFromLibrary %% Library :: ^Book => Result<BookRemoved, UnknownBook> :: {
    book = {%->books->value}->item(#.isbn->baseValue);
    result = ?whenTypeOf(book) is {
        type{Result<Nothing, MapItemNotFound>}: => @UnknownBook[#.isbn],
        ~: BookRemoved[#]
    };
    newState = %->books->value->valuesWithoutKey(#.isbn->baseValue);
    ?whenTypeOf(newState) is {
        type{Map<Book>}: {%->books}->SET(newState),
        ~: => @UnknownBook[#.isbn]
    };
    result
};

DependencyContainer ==> AllLibraryBooks %% Library :: ^Null => Array<Book> :: {
    {%->books->value}->values
};

/*getContainerConfig = ^Null => ContainerConfiguration :: {
    [
        [Library, [books: Mutable[Map<Book>, [:]]]]
    ]
};*/
DependencyContainer ==> Library :: Library[books: Mutable[type{Map<Book>}, [:]]];

RenameBook = ^BookTitle => Book;

BookManager = :[];/* <: [~BookByIsbn, ~BringBookToLibrary, ~AllLibraryBooks, ~RemoveBookFromLibrary];*/
BookManager->bookByIsbn(^Isbn => Result<Book, UnknownBook>) %% BookByIsbn :: %(#);
BookManager->bringBookToLibrary(^Book => BookAdded|BookReplaced) %% BringBookToLibrary :: %(#);
BookManager->allLibraryBooks(^Null => Array<Book>) %% AllLibraryBooks :: %();
BookManager->removeBookFromLibrary(^Book => Result<BookRemoved, UnknownBook>) %% RemoveBookFromLibrary :: %(#);

myFn = ^Array<String> => Any :: {
    ctr = DependencyContainer[];/*Container[getContainerConfig()];*/
    bookManager = ?noError(ctr->valueOf(type{BookManager}));
    isbn = ?noError(Isbn('1259060977'));
    book1 = bookManager->bookByIsbn(isbn);
    newBook = Book[isbn, BookTitle('My new book')];
    result1 = bookManager->bringBookToLibrary(newBook);
    result2 = bookManager->bringBookToLibrary(newBook);
    result3 = bookManager->allLibraryBooks;
    book2 = bookManager->bookByIsbn(isbn);
    result4 = bookManager->removeBookFromLibrary(newBook);
    result5 = bookManager->removeBookFromLibrary(newBook);
    book3 = bookManager->bookByIsbn(isbn);
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