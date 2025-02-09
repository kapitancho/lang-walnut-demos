module demo-prio1:

Aaa <: Integer;

/*main = ^Any => String :: {aaa->bbb->ccc}->printed;*/
/*main = ^Any => String :: {aaa.bbb.ccc}->printed;*/
/*main = ^Any => String :: {aaa(bbb)(ccc)(ddd)}->printed;*/
/*main = ^Any => String :: {aaa->bbb.ccc}->printed;*/
/*main = ^Any => String :: {aaa.bbb->ccc}->printed;*/
/*main = ^Any => String :: {aaa->bbb(ccc)->ddd(eee)}->printed;*/
/*main = ^Any => String :: {aaa(bbb).ccc}->printed;*/
/*main = ^Any => String :: {aaa + bbb.ccc}->printed;*/
/*main = ^Any => String :: {aaa.bbb + ccc}->printed;*/
/*main = ^Any => String :: {aaa + bbb->ccc}->printed;*/
/*main = ^Any => String :: {aaa + bbb(ccc)}->printed;*/
/*main = ^Any => String :: {Aaa(bbb) + ccc}->printed;*/

/*main = ^Any => String :: {aaa.bbb + ccc.ddd}->printed;*/

/****main = ^Any => String :: {aaa->bbb + ccc}->printed;*/
/****main = ^Any => String :: {aaa(bbb) + ccc}->printed;*/

		A = :[];
		E = :[A, B, C];

		getValues = ^Null => Map :: [
			a: A[],
			ea: E.A,
			eb: E.B,
			ec: E.C
		];
		getTypes = ^Null => Map<Type> :: [
			a: type{A},
			e: type{E},
			es1: type{E[A]}, es2: type{E[B]}, es3: type{E[C]},
			es4: type{E[A, B]}, es5: type{E[A, C]}, es6: type{E[B, C]},
			es7: type{E[A, B, C]}
		];


main = ^Array<String> => String :: {
    vx = getValues();
    tx = getTypes();
    vx.map(^val: Any => Any :: {
	    tx.map(^t: Type => Any :: {
	        [
	            val->printed,
	            t->printed,
                val->isSubtypeOf(t)->printed
            ]->combineAsString(' / ')
        })
    })
};

