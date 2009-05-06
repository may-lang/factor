! Copyright (c) 2007-2009 Slava Pestov, Doug Coleman, Aaron Schaefer.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors assocs fry kernel locals math math.order math.ranges mirrors
    namespaces sequences sorting ;
IN: math.combinatorics

<PRIVATE

: possible? ( n m -- ? )
    0 rot between? ; inline

: twiddle ( n k -- n k )
    2dup - dupd > [ dupd - ] when ; inline

PRIVATE>

: factorial ( n -- n! )
    1 [ 1 + * ] reduce ;

: nPk ( n k -- nPk )
    2dup possible? [ dupd - [a,b) product ] [ 2drop 0 ] if ;

: nCk ( n k -- nCk )
    twiddle [ nPk ] keep factorial / ;


! Factoradic-based permutation methodology

<PRIVATE

: factoradic ( n -- factoradic )
    0 [ over 0 > ] [ 1 + [ /mod ] keep swap ] produce reverse 2nip ;

: (>permutation) ( seq n -- seq )
    [ '[ _ dupd >= [ 1 + ] when ] map ] keep prefix ;

: >permutation ( factoradic -- permutation )
    reverse 1 cut [ (>permutation) ] each ;

: permutation-indices ( n seq -- permutation )
    length [ factoradic ] dip 0 pad-head >permutation ;

PRIVATE>

: permutation ( n seq -- seq )
    [ permutation-indices ] keep nths ;

: all-permutations ( seq -- seq )
    [ length factorial ] keep '[ _ permutation ] map ;

: each-permutation ( seq quot -- )
    [ [ length factorial ] keep ] dip
    '[ _ permutation @ ] each ; inline

: reduce-permutations ( seq initial quot -- result )
    swapd each-permutation ; inline

: inverse-permutation ( seq -- permutation )
    <enum> >alist sort-values keys ;


! Combinadic-based combination methodology

TUPLE: combination
    { n integer }
    { k integer } ;

C: <combination> combination

<PRIVATE

: dual-index ( combination m -- x )
    [ [ n>> ] [ k>> ] bi nCk 1 - ] dip - ;

: largest-value ( a b x -- v )
    #! TODO: use a binary search instead of find-last
    [ [0,b) ] 2dip '[ _ nCk _ <= ] find-last nip ;

:: next-values ( a b x -- a' b' x' v )
    a b x largest-value dup :> v  ! a'
    b 1 -                         ! b'
    x v b nCk -                   ! x'
    v ;                           ! v == a'

: initial-values ( combination m -- a b x )
    [ [ n>> ] [ k>> ] [ ] tri ] dip dual-index ;

: combinadic ( combination m -- combinadic )
    initial-values [ over 0 > ] [ next-values ] produce
    [ 3drop ] dip ;

PRIVATE>

: combination ( m combination -- seq )
    swap [ drop n>> 1 - ] [ combinadic ] 2bi [ - ] with map ;
