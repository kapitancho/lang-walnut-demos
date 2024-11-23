module lang-08-maps:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/08_maps/main.go */

main = ^Any => String :: {
    emails = [:];
    emails = emails->withKeyValue[key: 'John', value: 'john@gmail.com'];
    emails = emails->withKeyValue[key: 'Brad', value: 'brad@gmail.com'];
    emails = emails->withKeyValue[key: 'Mark', value: 'mark@gmail.com'];

    emailsX = emails->without('brad@gmail.com');

    emails2 = [Bob: 'bob@gmail.com', Mark: 'mark@gmail.com'];

    [
        emails,
        emails->item('Brad'),
        emails->length,

        emailsX,

        emails2
    ]->printed
};