module demo-set:

MySet = Set<Real, ..5>;

/* Variables */
a = type{Set<Integer>};

getUnique = ^Array<Integer> => Set<Integer> :: #->uniqueSet;

demoSetType = ^ => Set<Real, 5..6> :: [1; -1.11; 3.14; 4; -42; 4];

main = ^Array<String> => String :: [
    /*a, getUnique[1, 5, 5, 7], [], [;], [:], [7; 3; 3], [7, 3, 3, 8, 10], [5], [9;],*/
    arrayUniqueSet: [1, 5, 5, 7]->uniqueSet,                    /* from array */
    mapKeysSet: [a: 1, b: 3]->keysSet,                          /* keys from map */
    setValues: [1; 3; 5]->values,                               /* to array */
    hydrateSet: [1, 5, 10, 8, 10]->hydrateAs(type{Set<Integer>}),           /* hydrate */
    hydrateSetOutOfRange: [1, 5, 10, 8, 10]->hydrateAs(type{Set<Integer, 5..>}),           /* hydrate */
    setContainsYes: [1; 4; 'hello']->contains(4),
    setContainsNo: [1; 4; 'hello']->contains(5),
    setLength: [1; 1; 5; 1]->length,
    setWithoutExists: [1; 1; 5; 1]->without(1),
    setWithoutNotExists: [1; 1; 5; 1]->without(7),
    setWithRemovedExists: [1; 1; 5; 1]->withRemoved(1),
    setWithRemovedNotExists: [1; 1; 5; 1]->withRemoved(7),
    setInsertExists: [1; 1; 5; 1]->insert(5),
    setInsertNotExists: [1; 1; 5; 1]->insert(6),
    setDiff: {[1; 2; 3]} - {[2; 4]},
    setUnion: {[1; 2; 3]} + {[2; 4]},
    setIntersection: {[1; 2; 3]} & {[2; 4]},
    setSymmetricDiff: {[1; 2; 3]} ^ {[2; 4]},
    setIsSubsetNo: {[1; 2; 3]}->isSubsetOf[2; 4],
    setIsSubsetYes: {[1; 2; 3]}->isSubsetOf[1; 2; 3; 4; 5],
    setIsSupersetNo: {[1; 2; 3]}->isSupersetOf[2; 4],
    setIsSupersetYes: {[1; 2; 3]}->isSupersetOf[1; 3],
    setIsDisjointWithNo: {[1; 2; 3]}->isDisjointWith[2; 4],
    setIsDisjointWithYes: {[1; 2; 3]}->isDisjointWith[4; 5],
    setMap: [1; 8; 9]->map(^Integer => Integer :: {5 - #}->abs),
    setFilter: [1; 8; 9]->filter(^Integer => Boolean :: # > 6),
    setCall: demoSetType()
]->printed;