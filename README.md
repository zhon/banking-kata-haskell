banking-kata-haskell
====================

Up and Running
--------------

Our First Dilemma: Type
----------------------------

What type should we choose?

```Haskell
type Account = TVar Int
```
or

```Haskell
type Account = STM ( TVar Int )
```

Lets write a ``quickCheck`` test to see what falls out.

```Haskell
prop_newAccountHasInitialBalance x = monadicIO $ do
  checking <- run $ newAccount x
  balance <- run $ balance checking
  assert $ x == balance
```

newAccount :: Int -> IO (TVar Int)
newAccount x = atomically $ newTVar (x::Int)

balance :: TVar Int -> IO Int
balance account = readTVarIO account

