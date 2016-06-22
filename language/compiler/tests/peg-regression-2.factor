USING: peg.ebnf strings tools.test ;
IN: compiler.tests.peg-regression-2

GENERIC: <times> ( times -- term' ) ;
M: string <times> ;

: parse-regexp ( string -- obj ) EBNF{{

Times = .* => [[ "foo" ]]

Regexp = Times:t => [[ t <times> ]]

}} ;

[ "foo" ] [ "a" parse-regexp ] unit-test
