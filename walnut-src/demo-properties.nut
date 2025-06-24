module demo-properties:

/* Note: many examples showcasing the property access for the
   Array, Map, Tuple and Record types are available in demo-tuple and demo-record
*/

/* This is a type where a property accessor will be defined */
Person := $[name: String<1..>, age: Integer<0..>];
Person->item(^String => Result<String|Integer, String>) :: ?whenValueOf(#) is {
    'name': $name,
    'age': $age,
    ~: @{'Property not found: '->concat(#)}
};

/* In case of a union type, the return type will be the union of the return types of relevant ->item methods */
getPropertyOfUnionType = ^Person|Map<String> => Result<String|Integer, String|MapItemNotFound> :: #.name;

main = ^Array<String> => String :: {
    person = Person['Alice', 27];
    [
        name: person.name,
        age: person.age,
        job: person.job,

        union1: getPropertyOfUnionType(person),
        union2: getPropertyOfUnionType([name: 'John']),
        end: 'end'
    ]->printed
};