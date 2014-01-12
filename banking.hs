{-# LANGUAGE TemplateHaskell #-} 
module Banking where

import Test.QuickCheck
import Test.QuickCheck.Monadic
import Test.QuickCheck.All

import System.IO
import Control.Concurrent
import Control.Concurrent.STM
import Control.Concurrent.STM.TVar


type Account = TVar Int

debit :: Account -> Int -> STM ()
debit account amount = do
    balance <- readTVar account
    writeTVar account (balance - amount)

{-credit account amount = do-}
    {-debit account (- amount)-}

{-showAccount account = do-}
    {-balance <- readTVarIO account-}
    {-hPutStr stdout $ "$" ++ (show balance ++ "\n")-}

{-main = do-}
    {-checking <- atomically $ newTVar (200 :: Int)-}
    {-showAccount checking-}
    {-atomically $ credit checking 10-}
    {-showAccount checking-}
    {-atomically $ debit checking 5-}
    {-showAccount checking-}

balance :: Account -> IO Int
balance account = readTVarIO account


{-newAccount :: Int -> STM (Account)-}
newAccount x = atomically $ newTVar (x::Int)

prop_newAccountHasInitialBalance x = monadicIO $ do
  checking <- run $ newAccount x
  balance <- run $ balance checking
  assert $ x == balance

prop_debitChangesTheBalance x debitAmount = monadicIO $ do
  checking <- run $ newAccount x
  run $ atomically $ debit checking debitAmount
  balance <- run $ balance checking
  assert $ x - debitAmount == balance


