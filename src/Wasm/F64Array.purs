-- | WasmBase `Wasm.F64Array` (ADR 0026): the first-order primitives for a packed,
-- | unboxed `(array (mut f64))`. The `Number` analog of `Wasm.I32Array`: every element is a
-- | flat `f64` lane rather than a heap-allocated `$Num` box (cf. `Wasm.Array`, whose elements
-- | are boxed `eqref`s), so numeric code pays no per-element allocation. The combinators of the
-- | higher-level (library) layer build on these so they specialize on wasm (ADR 0027).
-- |
-- | Per ADR 0026, `Wasm.*` is first-order only (no HOFs, no `Prelude`); the type is opaque and
-- | the operations are deliberately `unsafe` (unchecked indexing, manual allocation, in-place
-- | mutation). The `foreign import`s resolve to wasm intrinsics (`Wasm.F64Array.*`); the
-- | accompanying `Wasm/F64Array.js` provides them for stock `purs` / `purs-backend-es` (a JS
-- | `Float64Array`, whose fixed-length, zero-filled, element-typed semantics match the wasm
-- | array), so a `wasm-base`-using project also compiles and runs on the JS backends.
module Wasm.F64Array
  ( F64Array
  , length
  , unsafeIndex
  , unsafeNew
  , unsafeSet
  ) where

-- | A packed array of unboxed `f64`. Opaque: built and read only through the primitives
-- | below (on wasm a `(ref (array (mut f64)))`).
foreign import data F64Array :: Type

-- | The element count. On wasm: the `F64ArrayLength` intrinsic (`array.len`).
foreign import length :: F64Array -> Int

-- | The element at index `i`, unchecked (no bounds test; out of range traps). On wasm:
-- | the `F64ArrayIndex` intrinsic (`array.get`, an `f64` lane, no box).
foreign import unsafeIndex :: F64Array -> Int -> Number

-- | Allocate a length-`n` array, every lane zero-initialised (`0.0`); a read before a write
-- | returns `0.0` rather than trapping. On wasm: the `F64ArrayNew` intrinsic (`array.new`
-- | with a `0.0` initialiser).
foreign import unsafeNew :: Int -> F64Array

-- | Write `v` at index `i`, mutating the array in place, and return that same array, so a
-- | builder loop threads it (keeping the write live and ordered by the data dependency,
-- | without an effect). Unchecked (out of range traps). On wasm: the `F64ArraySet` intrinsic
-- | (`array.set`, then yields the array).
foreign import unsafeSet :: F64Array -> Int -> Number -> F64Array
