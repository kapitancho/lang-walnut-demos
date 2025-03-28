module demo-range:

main = ^Any => String :: [
    IntegerRange[1, PlusInfinity()],
    IntegerRange[1, 10],
    IntegerRange[100, 10],
    IntegerRange[MinusInfinity(), 10],
    IntegerRange[MinusInfinity(), PlusInfinity()],

    RealRange[3.14, PlusInfinity()],
    RealRange[3.14, 10],
    RealRange[107.9, 10],
    RealRange[MinusInfinity(), 10],
    RealRange[MinusInfinity(), PlusInfinity()],

    LengthRange[1, PlusInfinity()],
    LengthRange[1, 10],
    LengthRange[100, 10]
]->printed;