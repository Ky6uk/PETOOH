#!/usr/bin/env runhaskell

{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Petooh where

import Text.Parsec

import Control.Applicative( (<*) )
import Control.Monad( msum, when )

import Data.Word( Word8 )
import Data.Char( chr, ord )

import Data.IORef
import Data.Array.IO

import System.Exit


data AST = DataInc | DataDec
         | PtrInc | PtrDec
         | InputChar | OutputChar
         | Loop [AST]
         | Program [AST]
         deriving (Show, Eq)


program :: Parser AST
program = optional whitespace >> (many command >>= return . Program) <* eof

command = any1 [datainc, datadec, ptrinc, ptrdec, input, output, loop]

whitespace = many1 $ oneOf " \t\v\n-"

lexime s = string s >> optional whitespace

datainc = lexime "Ko" >> return DataInc
datadec = lexime "kO" >> return DataDec
ptrinc = lexime "Kudah" >> return PtrInc
ptrdec = lexime "kudah" >> return PtrDec
output = lexime "Kukarek" >> return OutputChar
input = lexime "kukarek" >> return InputChar

loop = between (lexime "Kud") (lexime "kud") $ do
                            body <- many command
                            return $ Loop body

any1 parsers = msum $ map try parsers
type Parser a = Parsec String () a



interpret :: AST -> IO ()
interpret ast = do
    (memory :: IOUArray Int Word8) <- newArray (0, 65535) 0
    (ptrRef :: IORef Int) <- newIORef 0
    let
        exec DataInc = modifyCurrentCell (+1)
        exec DataDec = modifyCurrentCell (\x -> x-1)
        exec PtrInc = modifyPointer (+1)
        exec PtrDec = modifyPointer (\x -> x-1)
        exec OutputChar = readPointer >>= readMemory >>= putChar . toAscii
        exec InputChar = getChar >>= modifyCurrentCell . const . fromAscii
        exec (Program p) = mapM exec p >> return ()
        exec (Loop body) =
            let recurse = do
                condition <- readCurrentCell
                when (condition /= 0)
                    (mapM exec body >> recurse)
            in recurse

        readPointer = readIORef ptrRef
        modifyPointer = modifyIORef ptrRef

        readMemory = readArray memory
        modifyMemory = modifyArray memory

        readCurrentCell = readPointer >>= readMemory
        modifyCurrentCell f = do
            ptr <- readPointer
            modifyMemory ptr f
        
        in exec ast

modifyArray arr i f = readArray arr i >>= writeArray arr i . f

toAscii :: Word8 -> Char
toAscii = chr . fromIntegral

fromAscii :: Char -> Word8
fromAscii = fromIntegral . ord

main = do
    input <- getContents
    case runParser program () "<stdin>" input of
        Left error -> print error >> exitFailure
        Right ast -> interpret ast
