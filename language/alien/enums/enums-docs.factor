! Copyright (C) 2010 Erik Charlebois.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.syntax help.markup help.syntax words ;
IN: alien.enums

HELP: define-enum
{ $values
    { "word" word } { "base-type" c-type } { "members" "sequence of word and value pairs" }
}
{ $description "Defines an enum. This is the run-time equivalent of " { $link postpone\ ENUM: } "." } ;

HELP: enum>number
{ $values
    { "enum" "an enum word" }
    { "number" "the corresponding number value" }
}
{ $description "Converts an enum to a number." } ;

HELP: number>enum
{ $values
    { "number" "an enum number" } { "enum-c-type" "an enum type" }
    { "enum" "the corresponding enum word" }
}
{ $description "Convert a number to an enum." } ;

{ postpone\ ENUM: define-enum enum>number number>enum } related-words

about: "alien.enums"
