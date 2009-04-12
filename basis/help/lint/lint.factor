! Copyright (C) 2006, 2009 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: assocs continuations fry help help.lint.checks
help.topics io kernel namespaces parser sequences
source-files.errors tools.vocabs vocabs words classes
locals ;
FROM: help.lint.checks => all-vocabs ;
IN: help.lint

SYMBOL: lint-failures

lint-failures [ H{ } clone ] initialize

TUPLE: help-lint-error < source-file-error ;

SYMBOL: +help-lint-failure+

+help-lint-failure+
"vocab:ui/tools/error-list/icons/help-lint-error.tiff"
[ lint-failures get values ] define-error-type

M: help-lint-error source-file-error-type drop +help-lint-failure+ ;

<PRIVATE

: <help-lint-error> ( error topic -- help-lint-error )
    \ help-lint-error <definition-error> ;

PRIVATE>

: help-lint-error ( error topic -- )
    over [
        [ <help-lint-error> ] keep
        lint-failures get set-at
    ] [ nip lint-failures get delete-at ] if ;

<PRIVATE

:: check-something ( topic quot -- )
    [ quot call( -- ) f ] [ ] recover
    topic help-lint-error ; inline

: check-word ( word -- )
    [ with-file-vocabs ] vocabs-quot set
    dup word-help [
        [ >link ] keep '[
            _ dup word-help
            [ check-values ]
            [ check-class-description ]
            [ nip [ check-nulls ] [ check-see-also ] [ check-markup ] tri ] 2tri
        ] check-something
    ] [ drop ] if ;

: check-words ( words -- ) [ check-word ] each ;

: check-article ( article -- )
    [ with-interactive-vocabs ] vocabs-quot set
    >link dup '[
        _
        [ check-article-title ]
        [ article-content check-markup ] bi
    ] check-something ;

: check-about ( vocab -- )
    dup '[ _ vocab-help [ article drop ] when* ] check-something ;

: check-vocab ( vocab -- )
    "Checking " write dup write "..." print
    vocab
    [ check-about ]
    [ words [ check-word ] each ]
    [ vocab-articles get at [ check-article ] each ]
    tri ;

PRIVATE>

: help-lint ( prefix -- )
    [
        all-vocabs-seq [ vocab-name ] map all-vocabs set
        group-articles vocab-articles set
        child-vocabs
        [ check-vocab ] each
    ] with-scope ;

: help-lint-all ( -- ) "" help-lint ;

: unlinked-words ( words -- seq )
    all-word-help [ article-parent not ] filter ;

: linked-undocumented-words ( -- seq )
    all-words
    [ word-help not ] filter
    [ article-parent ] filter
    [ predicate? not ] filter ;

MAIN: help-lint
