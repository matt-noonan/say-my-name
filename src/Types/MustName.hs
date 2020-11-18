{-# language ConstraintKinds #-}
{-# language PolyKinds #-}
{-# language DataKinds #-}
{-# language TypeOperators #-}
{-# language TypeFamilies #-}
{-# language UndecidableInstances #-}

module Types.MustName (MustName, MustNameEx) where

import GHC.Exts (Constraint)
import GHC.TypeLits

data Foo
data Bar
type family SayMyName_ a where
  SayMyName_ Foo = Bar
  SayMyName_ a = a

type family Break (c :: Constraint) t :: Constraint where
  Break _ Foo = ((), ())
  Break _ _ = ()

type family MustName_ name where
  MustName_ name = TypeError ('Text "The type parameter `"
                              ':<>: 'Text name
                              ':<>: 'Text "` must be supplied by an explicit type application, even if it could be inferred.")
type family MustNameEx_ name ex where
  MustNameEx_ name ex = TypeError ('Text "The type parameter `"
                                   ':<>: 'Text name
                                   ':<>: 'Text "` must be supplied by an explicit type application, even if it could be inferred. "
                                   ':<>: 'Text "For example: " ':<>: 'Text ex)

-- | @MustName a name a_@ enforces that the type variable @a@ must be specified by an
-- explicit type application for the variable @a_@. The @name@ argument should be a string that
-- will show up as the name of @a@ in error messages.
type family MustName a name t :: Constraint where
  MustName _ "" _  = TypeError ('Text "Please provide a non-empty name for the type variable in MustName.")
  MustName a name t = (a ~ SayMyName_ t, Break (MustName_ name) t)

-- | @MustNameEx a name a_ ex@ enforces that the type variable @a@ must be specified by an
-- explicit type application for the variable @a_@. The @name@ argument should be a string that
-- will show up as the name of @a@ in error messages. The @ex@ argument is an additional
-- usage example that will show up in the error message.
type family MustNameEx a name t ex :: Constraint where
  MustNameEx _ "" _ _ = TypeError ('Text "Please provide a non-empty name for the type variable in MustName.")
  MustNameEx _ _ _ "" = TypeError ('Text "Please provide a non-empty usage example in MustName.")
  MustNameEx a name t ex = (a ~ SayMyName_ t, Break (MustNameEx_ name ex) t)
