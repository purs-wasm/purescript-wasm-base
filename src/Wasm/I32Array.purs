-- | WasmBase `Wasm.I32Array` (ADR 0026): the first-order primitives for a packed,
-- | unboxed `(array (mut i32))`. Unlike `Wasm.Array` (a `$Vals`, `(array (mut eqref))`
-- | whose every `Int` element is a heap-allocated `$Int` box), an `I32Array` stores its
-- | elements flat as `i32` lanes, so numeric code pays no per-element allocation and no
-- | pointer chase. It is the unboxed-array analog of `Wasm.String`'s byte array, exposed
-- | as a general `Int` container the higher-level (library-layer) combinators build on
-- | (ADR 0027), so those specialize on wasm.
-- |
-- | Per ADR 0026, `Wasm.*` is first-order only (no HOFs, no `Prelude`); the type is opaque
-- | and the operations are deliberately `unsafe` (unchecked indexing, manual allocation,
-- | in-place mutation). The `foreign import`s resolve to wasm intrinsics (`Wasm.I32Array.*`);
-- | the accompanying `Wasm/I32Array.js` provides them for stock `purs` / `purs-backend-es`
-- | (a JS `Int32Array`, whose fixed-length, zero-filled, element-typed semantics match the
-- | wasm array), so a `wasm-base`-using project also compiles and runs on the JS backends.
module Wasm.I32Array
  ( I32Array
  , length
  , unsafeIndex
  , unsafeNew
  , unsafeSet
  ) where

-- | A packed array of unboxed `i32`. Opaque: built and read only through the primitives
-- | below (on wasm a `(ref (array (mut i32)))`).
foreign import data I32Array :: Type

-- | The element count. On wasm: the `I32ArrayLength` intrinsic (`array.len`).
foreign import length :: I32Array -> Int

-- | The element at index `i`, unchecked (no bounds test; out of range traps). On wasm:
-- | the `I32ArrayIndex` intrinsic (`array.get`, an `i32` lane, no box).
foreign import unsafeIndex :: I32Array -> Int -> Int

-- | Allocate a length-`n` array, every lane zero-initialised. Unlike `Wasm.Array.unsafeNew`
-- | a read before a write returns `0` rather than trapping. On wasm: the `I32ArrayNew`
-- | intrinsic (`array.new` with a `0` initialiser).
foreign import unsafeNew :: Int -> I32Array

-- | Write `v` at index `i`, mutating the array in place, and return that same array, so a
-- | builder loop threads it (keeping the write live and ordered by the data dependency,
-- | without an effect). Unchecked (out of range traps). On wasm: the `I32ArraySet` intrinsic
-- | (`array.set`, then yields the array).
foreign import unsafeSet :: I32Array -> Int -> Int -> I32Array
