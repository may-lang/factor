IN: vocabs.refresh.tests
USING: vocabs.refresh tools.test continuations namespaces ;

{ } [
    changed-vocabs get-global
    f changed-vocabs set-global
    [ t ] [ "kernel" changed-vocab-by-name? ] unit-test
    [ "kernel" changed-vocab ] [ changed-vocabs set-global ] [ ] cleanup
] unit-test
