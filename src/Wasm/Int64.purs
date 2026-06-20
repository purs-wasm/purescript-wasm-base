-- | WasmBase `Wasm.Int64`: native 64-bit integer primitives. On wasm these resolve
-- | to `i64.*` intrinsics (`Intrinsics.qualifiedIntrinsic` — `Wasm.Int64.*`); on the
-- | JS backends to `Wasm/Int64.js` (BigInt). `Int64` is an opaque first-order type.
module Wasm.Int64
  ( Int64
  , fromInt, toInt
  , and, or, xor, complement
  , shl, shr, zshr
  , rotl, rotr
  , eq, lt
  ) where

foreign import data Int64 :: Type

foreign import fromInt :: Int -> Int64      -- i64.extend_i32_s
foreign import toInt :: Int64 -> Int        -- i32.wrap_i64 (low 32 bits)

foreign import and :: Int64 -> Int64 -> Int64
foreign import or :: Int64 -> Int64 -> Int64
foreign import xor :: Int64 -> Int64 -> Int64
foreign import complement :: Int64 -> Int64

foreign import shl :: Int64 -> Int64 -> Int64
foreign import shr :: Int64 -> Int64 -> Int64    -- arithmetic, i64.shr_s
foreign import zshr :: Int64 -> Int64 -> Int64   -- logical, i64.shr_u
foreign import rotl :: Int64 -> Int64 -> Int64   -- i64.rotl (one instruction)
foreign import rotr :: Int64 -> Int64 -> Int64

foreign import eq :: Int64 -> Int64 -> Boolean
foreign import lt :: Int64 -> Int64 -> Boolean