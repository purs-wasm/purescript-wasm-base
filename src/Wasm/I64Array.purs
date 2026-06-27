-- | WasmBase `Wasm.I64Array` (ADR 0026 sibling of `Wasm.Array`): a first-order,
-- | **packed native 64-bit** mutable array. Unlike `Array Int64` (the universal
-- | `$Vals`, an `(array (mut eqref))` whose every element is a boxed `$Int64`
-- | struct), this is `$I64Arr = (array (mut i64))`: the lanes are raw `i64`, so a
-- | read is one `array.get` of an `i64` (no `ref.cast`/`struct.get`, no unbox) and a
-- | write is one `array.set` (no `struct.new`, no allocation). The type is opaque so
-- | it can never decay back into the boxed `$Vals` representation.
-- |
-- | The `foreign import`s resolve to intrinsics on wasm (`Intrinsics.qualifiedIntrinsic`
-- | — `Wasm.I64Array.*`); the accompanying `Wasm/I64Array.js` provides a
-- | `BigInt64Array`-backed version for stock `purs` / `purs-backend-es`.
module Wasm.I64Array
  ( I64Array
  , length
  , unsafeIndex
  , unsafeNew
  , unsafeSet
  ) where

import Wasm.Int64 (Int64)

-- | A packed `(array (mut i64))`. Opaque: no `Array a` interface, so the boxed
-- | array primitives and HOFs do not apply (and cannot reintroduce boxing).
foreign import data I64Array :: Type

-- | The lane count. On wasm: `I64ArrayLength` (`array.len`).
foreign import length :: I64Array -> Int

-- | The raw i64 lane at index `i`, **unchecked** (out of range traps). On wasm:
-- | `I64ArrayIndex` (`array.get` of an `i64`, no box).
foreign import unsafeIndex :: I64Array -> Int -> Int64

-- | Allocate a length-`n` array with all lanes **zeroed** (`array.new_default`;
-- | the i64 default is 0, so unlike `Wasm.Array.unsafeNew` the lanes are readable
-- | immediately). On wasm: `I64ArrayNew`.
foreign import unsafeNew :: Int -> I64Array

-- | Write raw i64 `v` at index `i`, **mutating in place**, and return that same
-- | array so a builder loop threads it (keeping the write live and ordered without
-- | an effect). Unchecked. On wasm: `I64ArraySet` (`array.set`, then yields the array).
foreign import unsafeSet :: I64Array -> Int -> Int64 -> I64Array
