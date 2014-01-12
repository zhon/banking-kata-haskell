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

Test The Balance of a New Account is the Same as When we Created It
-------------------------------------------------------------------

```Haskell
prop_newAccountHasInitialBalance x = monadicIO $ do
  checking <- run $ newAccount x
  balance <- run $ balance checking
  assert $ x == balance
```

We need to implement newAccount and balance

```Haskell
newAccount :: Int -> IO (TVar Int)
newAccount x = atomically $ newTVar (x::Int)

balance :: TVar Int -> IO Int
balance account = readTVarIO account
```

Test Debit Changes the Balance
------------------------------

```Haskell
prop_debitChangesTheBalance x debitAmount = monadicIO $ do
  checking <- run $ newAccount x
  run $ atomically $ debit checking debitAmount
  balance <- run $ balance checking
  assert $ x - debitAmount == balance
```

```Haskell
debit :: Account -> Int -> STM ()
debit account amount = do
    balance <- readTVar account
    writeTVar account (balance - amount)
```

