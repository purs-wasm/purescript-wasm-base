module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Test.Assert (assert')
import Wasm.Int64 (Int64)
import Wasm.Int64 as I64

-- | 0x80000000 as a 32-bit pattern is the sign bit (minBound).
topBit :: Int
topBit = -2147483648

eqI64 :: Int64 -> Int64 -> Boolean
eqI64 = I64.eq

main :: Effect Unit
main = do
  log "Wasm.Int64 JS-fallback golden tests"

  -- fromInt / lowBits (low 32 bits) round-trips
  assert' "lowBits (fromInt 0)" (I64.lowBits (I64.fromInt 0) == 0)
  assert' "lowBits (fromInt 123456)" (I64.lowBits (I64.fromInt 123456) == 123456)
  assert' "lowBits (fromInt -1)" (I64.lowBits (I64.fromInt (-1)) == (-1))
  assert' "lowBits (fromInt minBound)" (I64.lowBits (I64.fromInt topBit) == topBit)

  -- fromInt sign-extends; fromHiLo zero-extends each half (the Keccak-constant fix)
  assert' "fromInt -1 sign-extends into the high word" (I64.hiBits (I64.fromInt (-1)) == (-1))
  assert' "fromHiLo 0 -1 does NOT pollute the high word" (I64.hiBits (I64.fromHiLo 0 (-1)) == 0)
  assert' "fromHiLo 0 -1 keeps the low word" (I64.lowBits (I64.fromHiLo 0 (-1)) == (-1))
  assert' "fromHiLo -1 -1 == fromInt -1" (eqI64 (I64.fromHiLo (-1) (-1)) (I64.fromInt (-1)))
  assert' "hiBits/lowBits invert fromHiLo"
    ( I64.hiBits (I64.fromHiLo 0x12345678 0x7abcdef0) == 0x12345678
        && I64.lowBits (I64.fromHiLo 0x12345678 0x7abcdef0) == 0x7abcdef0
    )

  -- rotations: n = 0 is identity
  assert' "rotl x 0 == x" (eqI64 (I64.rotl (I64.fromInt 12345) 0) (I64.fromInt 12345))
  assert' "rotr x 0 == x" (eqI64 (I64.rotr (I64.fromInt 12345) 0) (I64.fromInt 12345))

  -- canonical case: rotl 1 by 63 sets only the top bit (0x8000000000000000)
  assert' "rotl 1 63 == top bit" (eqI64 (I64.rotl (I64.fromInt 1) 63) (I64.fromHiLo topBit 0))
  assert' "rotr (top bit) 63 == 1" (eqI64 (I64.rotr (I64.fromHiLo topBit 0) 63) (I64.fromInt 1))
  assert' "rotl (top bit) 1 == 1" (eqI64 (I64.rotl (I64.fromHiLo topBit 0) 1) (I64.fromInt 1))

  -- shr (arithmetic) vs zshr (logical) on all-ones (fromInt -1 = 0xFFFFFFFFFFFFFFFF)
  assert' "shr -1 4 == -1 (sign-propagating)" (eqI64 (I64.shr (I64.fromInt (-1)) 4) (I64.fromInt (-1)))
  assert' "zshr -1 4 clears the top nibble" (I64.hiBits (I64.zshr (I64.fromInt (-1)) 4) == 0x0fffffff)
  assert' "zshr -1 60 == 0xF" (eqI64 (I64.zshr (I64.fromInt (-1)) 60) (I64.fromInt 0xf))

  -- shift across the 32-bit boundary
  assert' "shl 1 32 == hi:1 lo:0" (eqI64 (I64.shl (I64.fromInt 1) 32) (I64.fromHiLo 1 0))

  log "all Wasm.Int64 golden tests passed"
