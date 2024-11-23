module demo-openapi-types:

Contact = [
    name: ?String,
    url: ?String,
    email: ?String
];

License = [
    name: String,
    identifier: ?String,
    url: ?String
]; /* only one of identifier and url */

Info = [
    title: String,
    summary: ?String,
    description: ?String,
    termsOfService: ?String,
    contact: ?Contact,
    license: ?License,
    version: String
];

Reference = [
    '$ref': String,
    summary: ?String,
    description: ?String
];

Parameter = [
    name: String,
    in: String,
    description: ?String,
    required: ?Boolean,
    deprecated: ?Boolean,
    allowEmptyValue: ?Boolean,
    ...
];

OAuthFlow = [
    authorizationUrl: String,
    tokenUrl: String,
    refreshUrl: ?String,
    scopes: Map<String>
];

OAuthFlows = [
    implicit: ?OAuthFlow,
    password: ?OAuthFlow,
    clientCredentials: ?OAuthFlow,
    authorizationCode: ?OAuthFlow
]; /*...?*/

SecurityRequirement = Map<Array<String>>;

ExternalDocumentation = [
    url: String,
    description: ?String
];

Example = [
    summary: ?String,
    description: ?String,
    value: ?Any,
    externalValue: ?String
];

Header = [
    description: ?String,
    required: ?Boolean,
    deprecated: ?Boolean,
    allowEmptyValue: ?Boolean,
    ...
];

ServerVariable = [
    enum: ?Array<String, 1..>,
    default: String,
    description: ?String
];

Server = [
    url: String,
    description: ?String,
    variables: ?Map<ServerVariable>
];

SecurityRequirement = Map<Array<String>>;

Tag = [
    name: String,
    description: ?String,
    externalDocs: ?ExternalDocumentation
];

Link = [
    operationRef: ?String,
    operationId: ?String,
    parameters: ?Map<Any>,
    requestBody: ?Any,
    description: ?String,
    server: ?Server
];

Discriminator = [
    propertyName: String,
    mapping: ?Map<String>
];

SecurityScheme = [
    type: String,
    description: ?String,
    name: ?String,
    in: ?String,
    scheme: ?String,
    bearerFormat: ?String,
    flows: ?OAuthFlows,
    openIdConnectUrl: ?String
]; /*?...*/

XML = [
    name: ?String,
    namespace: ?String,
    prefix: ?String,
    attribute: ?Boolean,
    wrapped: ?Boolean
];

Schema = [
    title: ?String/*,
    multipleOf: ?Number,
    maximum: ?Number,
    exclusiveMaximum: ?Boolean,
    minimum: ?Number,
    exclusiveMinimum: ?Boolean,
    maxLength: ?Integer,
    minLength: ?Integer,
    pattern: ?String,
    maxItems: ?Integer,
    minItems: ?Integer,
    uniqueItems: ?Boolean,
    maxProperties: ?Integer,
    minProperties: ?Integer,
    required: ?Array<String>,
    enum: ?Array<Any>,
    type: ?String,
    allOf: ?Array<Schema>,
    oneOf: ?Array<Schema>,
    anyOf: ?Array<Schema>,
    not: ?Schema,
    items: ?Schema,
    properties: ?Map<Schema>,
    additionalProperties: ?Schema,
    description: ?String,
    format: ?String,
    default: ?Any,
    nullable: ?Boolean,
    discriminator: ?Discriminator,
    readOnly: ?Boolean,
    writeOnly: ?Boolean,
    xml: ?XML,
    externalDocs: ?ExternalDocumentation,
    example: ?Any,
    deprecated: ?Boolean*/
    , ...
];

Encoding = [
    contentType: ?String,
    headers: ?Map<Header|Reference>,
    style: ?String,
    explode: ?Boolean,
    allowReserved: ?Boolean
];

MediaType = [
    schema: ?Schema,
    example: ?Any,
    examples: ?Map<Example|Reference>,
    encoding: ?Map<Encoding>
];

RequestBody = [
    description: ?String,
    content: Map<MediaType>,
    required: ?Boolean
];

Response = [
    description: String,
    headers: ?Map<Header|Reference>,
    content: ?Map<MediaType>,
    links: ?Map<Link|Reference>
];

Responses = Map<Response|Reference>;

Callback = Map<`PathItem|Reference>;

Operation = [
    tags: ?Array<String>,
    summary: ?String,
    description: ?String,
    externalDocs: ?ExternalDocumentation,
    operationId: ?String,
    parameters: ?Array<Parameter|Reference>,
    requestBody: ?RequestBody|Reference,
    responses: ?Responses,
    callbacks: ?Map<Callback|Reference>,
    deprecated: ?Boolean,
    security: ?Array<SecurityRequirement>,
    servers: ?Array<Server>
];

PathItem = [
    '$ref': ?String,
    summary: ?String,
    description: ?String,
    get: ?Operation,
    put: ?Operation,
    post: ?Operation,
    delete: ?Operation,
    options: ?Operation,
    head: ?Operation,
    patch: ?Operation,
    trace: ?Operation,
    servers: ?Array<Server>,
    parameters: ?Array<Parameter|Reference>
];

Paths = Map<PathItem>;

Components = [
    schemas: ?Map<Schema>,
    responses: ?Map<Response|Reference>,
    parameters: ?Map<Parameter|Reference>,
    examples: ?Map<Example|Reference>,
    requestBodies: ?Map<RequestBody|Reference>,
    headers: ?Map<Header|Reference>,
    securitySchemes: ?Map<SecurityScheme|Reference>,
    links: ?Map<Link|Reference>,
    callbacks: ?Map<Callback|Reference>,
    pathItems: ?Map<PathItem|Reference>
];

OpenAPI = [
    openapi: String,
    info: Info,
    jsonSchemaDialect: ?String,
    servers: ?Array<Server>,
    paths: ?Paths,
    webhooks: ?Map<PathItem|Reference>,
    components: ?Components,
    security: ?Array<SecurityRequirement>,
    tags: ?Array<Tag>,
    externalDocs: ?ExternalDocumentation,
    ...
];