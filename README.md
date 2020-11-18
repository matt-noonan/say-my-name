# say-my-name

This is a small, slightly cursed package that lets you require explicit type
applications for certain type variables. Blame @taylorfausak for asking if it could
be done, but not if it *should* be done!

To force explicit type annotations on a type variable `a`, add a new type
variable `a_` and a constraint `MustName a "a" a_`:

``` haskell
-- NOTE: requires AllowAmbiguousTypes to define!
sayMyNameId :: forall a_ a. (MustName a "a" a_) => a -> a
sayMyNameId = id
```

This constraint means "the user must supply a value for `a` via an
explicit type annotation that specifies `a_`". The string `"a"` is
used to make nice error messages:

``` haskell
λ> sayMyNameId "test"
sayMyNameId "test"

<interactive>:57:1: error:
    • The type parameter `a` must be supplied by an explicit type application, even if it could be inferred.
    • When checking the inferred type
        it :: forall t.
              (Break (TypeError ...) t, Data.String.IsString (SayMyName_ t)) =>
              SayMyName_ t
λ> sayMyNameId "test" :: String
sayMyNameId "test" :: String

<interactive>:58:1: error:
    • The type parameter `a` must be supplied by an explicit type application, even if it could be inferred.
    • In the expression: sayMyNameId "test" :: String
      In an equation for ‘it’: it = sayMyNameId "test" :: String
λ> sayMyNameId ("test" :: String)
sayMyNameId ("test" :: String)

<interactive>:59:1: error:
    • The type parameter `a` must be supplied by an explicit type application, even if it could be inferred.
    • In the expression: sayMyNameId ("test" :: String)
      In an equation for ‘it’: it = sayMyNameId ("test" :: String)
λ> sayMyNameId @String "test"
sayMyNameId @String "test"
"test"
```

You can also augment the error message with a usage example:
``` haskell
λ> :{
 | sayMyNameId :: forall a_ a. (MustNameEx a "a" a_ "sayMyNameId @String \"hello, world!\"") => a -> a
 | sayMyNameId = id
 | :}
λ> sayMyNameId "test"

<interactive>:36:1: error:
    • The type parameter `a` must be supplied by an explicit type application, even if it could be inferred. For example: sayMyNameId @String "hello, world!"
    • In the expression: sayMyNameId "test"
      In an equation for ‘it’: it = sayMyNameId "test"
```
