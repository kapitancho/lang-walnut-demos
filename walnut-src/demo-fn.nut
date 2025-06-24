module demo-fn:

Param = String;
Ret = Integer;

Method := ();

ConsBase := $[prop: Any];
ConsNameParam := $[prop: Any];
ConsTypeParam := $[prop: Any];
ConsNameAnyParam := $[prop: Any];
ConsNullParam := $[prop: Any];
ConsTuple := $[prop: Any];
ConsTupleNameParam := $[prop: Any];
ConsEmptyTuple := $[prop: Any];
ConsRecord := $[prop: Any];
ConsRecordNameParam := $[prop: Any];
ConsEmptyRecord := $[prop: Any];

Dep = Boolean;
==> Dep :: true;

/* Default way of defining a function */
funcBase = ^Param => Ret :: #->length;
Method->base(^Param => Ret) :: #->length;
ConsBase(Param) :: [prop: #->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcBaseAny = ^Param :: #->length;
Method->baseAny(^Param) :: #->length;

/* Naming the parameter */
funcNameParam = ^p: Param => Ret :: p->length;
Method->nameParam(^p: Param => Ret) :: p->length;
ConsNameParam(p: Param) :: [prop: p->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcNameParamAny = ^p: Param :: p->length;
Method->nameParamAny(^p: Param) :: p->length;

/* Naming the parameter like its type (~Param = param: Param) */
funcTypeParam = ^~Param => Ret :: param->length;
Method->typeParam(^~Param => Ret) :: param->length;
ConsTypeParam(~Param) :: [prop: param->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcTypeParamAny = ^~Param :: param->length;
Method->typeParamAny(^~Param) :: param->length;

/* Naming the parameter of type any (`p: Any` shortened to `p`) */
funcNameAnyParam = ^p => Ret :: p->printed->length;
Method->nameAnyParam(^p => Ret) :: p->printed->length;
ConsNameAnyParam(p) :: [prop: p->printed->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcNameAnyParamAny = ^p :: p->printed->length;
Method->nameAnyParamAny(^p) :: p->printed->length;

/* Parameter of type null (removed `Null`) */
funcNullParam = ^=> Ret :: #->printed->length;
Method->nullParam(=> Ret) :: #->printed->length;
ConsNullParam() :: [prop: #->printed->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcNullParamAny = ^ :: #->printed->length;
Method->nullParamAny() :: #->printed->length;

/* Defining a function with a tuple parameter type */
funcTuple = ^[Param] => Ret :: #->length;
Method->tuple(^[Param] => Ret) :: #->length;
ConsTuple[Param] :: [prop: #->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcTupleAny = ^[Param] :: #->length;
Method->tupleAny(^[Param]) :: #->length;

/* Naming the tuple parameter */
funcTupleNameParam = ^p: [Param] => Ret :: p->length;
Method->tupleNameParam(^p: [Param] => Ret) :: p->length;
ConsTupleNameParam(p: [Param]) :: [prop: p->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcTupleNameParamAny = ^p: [Param] :: p->length;
Method->tupleNameParamAny(^p: [Param]) :: p->length;

/* Defining a function with an empty tuple parameter type */
funcEmptyTuple = ^[] => Ret :: #->length;
Method->emptyTuple(^[] => Ret) :: #->length;
ConsEmptyTuple[] :: [prop: #->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcEmptyTupleAny = ^[] :: #->length;
Method->emptyTupleAny(^[]) :: #->length;

/* Defining a function with a record parameter type */
funcRecord = ^[x: Param] => Ret :: #->length;
Method->record(^[x: Param] => Ret) :: #->length;
ConsRecord[x: Param] :: [prop: #->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcRecordAny = ^[x: Param] :: #->length;
Method->recordAny(^[x: Param]) :: #->length;

/* Naming the record parameter */
funcRecordNameParam = ^p: [x: Param] => Ret :: p->length;
Method->recordNameParam(^p: [x: Param] => Ret) :: p->length;
ConsRecordNameParam(p: [x: Param]) :: [prop: p->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcRecordNameParamAny = ^p: [x: Param] :: p->length;
Method->recordNameParamAny(^p: [x: Param]) :: p->length;

/* Defining a function with an empty record parameter type */
funcEmptyRecord = ^[:] => Ret :: #->length;
Method->emptyRecord(^[:] => Ret) :: #->length;
ConsEmptyRecord[:] :: [prop: #->length];
/* Short syntax (skip `=> Any`) when the return type is Any */
funcEmptyRecordAny = ^[:] :: #->length;
Method->emptyRecordAny(^[:]) :: #->length;


main = ^Array<String> => String :: {
    method = Method;
    [
        base: [
            fn: funcBase('hello'),
            method: method->base('hello'),
            cons: ConsBase('hello'),

            fnAny: funcBaseAny('world'),
            methodAny: method->baseAny('world')
        ],
        nameParam: [
            fn: funcNameParam('hello'),
            method: method->nameParam('hello'),
            cons: ConsNameParam('hello'),

            fnAny: funcNameParamAny('hello'),
            methodAny: method->nameParamAny('hello')
        ],
        typeParam: [
            fn: funcTypeParam('hello'),
            method: method->typeParam('hello'),
            cons: ConsTypeParam('hello'),

            fnAny: funcTypeParamAny('hello'),
            methodAny: method->typeParamAny('hello')
        ],
        nameAnyParam: [
            fn: funcNameAnyParam('hello'),
            method: method->nameAnyParam('hello'),
            cons: ConsNameAnyParam('hello'),

            fnAny: funcNameAnyParamAny('hello'),
            methodAny: method->nameAnyParamAny('hello')
        ],
        nullParam: [
            fn: funcNullParam(),
            method: method->nullParam,
            cons: ConsNullParam(),

            fnAny: funcNullParamAny(),
            methodAny: method->nullParamAny
        ],
        tupleParam: [
            fn: funcTuple['hello'],
            method: method->tuple['hello'],
            cons: ConsTuple['hello'],

            fnAny: funcTupleAny['hello'],
            methodAny: method->tupleAny['hello']
        ],
        tupleNameParam: [
            fn: funcTupleNameParam['hello'],
            method: method->tupleNameParam['hello'],
            cons: ConsTupleNameParam['hello'],

            fnAny: funcTupleNameParamAny['hello'],
            methodAny: method->tupleNameParamAny['hello']
        ],
        emptyTupleParam: [
            fn: funcEmptyTuple[],
            method: method->emptyTuple([]),
            cons: ConsEmptyTuple([]),

            fnAny: funcEmptyTupleAny[],
            methodAny: method->emptyTupleAny([])
        ],
        recordParam: [
            fn: funcRecord['hello'],
            method: method->record['hello'],
            cons: ConsRecord['hello'],

            fnAny: funcRecordAny['hello'],
            methodAny: method->recordAny['hello']
        ],
        recordNameParam: [
            fn: funcRecordNameParam['hello'],
            method: method->recordNameParam['hello'],
            cons: ConsRecordNameParam['hello'],

            fnAny: funcRecordNameParamAny['hello'],
            methodAny: method->recordNameParamAny['hello']
        ],
        emptyRecordParam: [
            fn: funcEmptyRecord[:],
            method: method->emptyRecord([:]),
            cons: ConsEmptyRecord([:]),

            fnAny: funcEmptyRecordAny[:],
            methodAny: method->emptyRecordAny([:])
        ]
    ]->printed;
};