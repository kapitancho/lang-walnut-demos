module lang-05-arrays-slices:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/05_arrays_slices/main.go */

main = ^Any => String :: {
    fruitArr = ['Apple', 'Orange'];
    fruitSlice = ['Apple', 'Orange', 'Grape'];
    [
        fruitArr, fruitArr.1,
        fruitSlice, fruitSlice->length, fruitSlice->sliceRange[start: 1, end: 2]
    ]->printed
};