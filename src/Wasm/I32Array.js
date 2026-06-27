// JS provider for `Wasm.I32Array`'s first-order primitives, used by the `purs` /
// purs-backend-es builds only. The wasm backend resolves these to intrinsics and ignores
// this file. A JS `Int32Array` matches the wasm `(array (mut i32))`: fixed length,
// zero-filled on allocation, i32-typed lanes.
export const length = (a) => a.length;
export const unsafeIndex = (a) => (i) => a[i];
export const unsafeNew = (n) => new Int32Array(n);
export const unsafeSet = (a) => (i) => (v) => {
  a[i] = v;
  return a;
};
