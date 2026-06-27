-- | WasmBase `Wasm.Int64`: native 64-bit integer primitives. On wasm these resolve
-- | to `i64.*` intrinsics (`Intrinsics.qualifiedIntrinsic` — `Wasm.Int64.*`); on the
-- | JS backends to `Wasm/Int64.js` (BigInt). `Int64` is an opaque first-order type.
module Wasm.Int64
  ( Int64
  , fromInt
  , fromHiLo
  , lowBits
  , hiBits
  , and
  , or
  , xor
  , complement
  , shl
  , shr
  , zshr
  , rotl
  , rotr
  , eq
  , lt
  ) where

foreign import data Int64 :: Type

foreign import fromInt :: Int -> Int64 -- i64.extend_i32_s (sign-extends)

-- | Build a 64-bit value from its high and low 32-bit words, each zero-extended:
-- | `(hi << 32) | (lo & 0xffffffff)`. The words are taken as 32-bit patterns, so a
-- | word whose top bit is set is a negative `Int` (`Int` is 32-bit, max `0x7fffffff`,
-- | so `0x80000000` is `-2147483648`). Unlike `fromInt`, the low word does not
-- | sign-extend into the high half: `fromHiLo 0 (-1)` is `0x00000000ffffffff`, not
-- | `0xffffffffffffffff`, so full-width constants whose low word has its top bit set
-- | are expressible directly.
foreign import fromHiLo :: Int -> Int -> Int64

foreign import lowBits :: Int64 -> Int -- low 32 bits: i32.wrap_i64 (lossy)
foreign import hiBits :: Int64 -> Int -- high 32 bits: i32.wrap_i64 (i64.shr_u x 32)

foreign import and :: Int64 -> Int64 -> Int64
foreign import or :: Int64 -> Int64 -> Int64
foreign import xor :: Int64 -> Int64 -> Int64
foreign import complement :: Int64 -> Int64

foreign import shl :: Int64 -> Int -> Int64
foreign import shr :: Int64 -> Int -> Int64 -- arithmetic, i64.shr_s
foreign import zshr :: Int64 -> Int -> Int64 -- logical, i64.shr_u
foreign import rotl :: Int64 -> Int -> Int64 -- i64.rotl (one instruction)
foreign import rotr :: Int64 -> Int -> Int64

foreign import eq :: Int64 -> Int64 -> Boolean
foreign import lt :: Int64 -> Int64 -> Boolean
