module demo-propdisc:

Rectangle = #[type: String['rectangle'], width: Real, height: Real];
Circle = #[type: String['circle'], radius: Real];

Figure = Rectangle | Circle;

p = ^json: JsonValue => Result<Figure, HydrationError> :: json->hydrateAs(`Figure);

fn = ^Any => Any :: [
    p[type: 'rectangle', width: 10, height: 20],
    p[type: 'circle', radius: 5],
    `Shape<JsonValue>
];

main = ^Array<String> => String :: fn()->printed;