// JS provider for `Wasm.F64Array`'s first-order primitives, used by the `purs` /
// purs-backend-es builds only. The wasm backend resolves these to intrinsics and ignores
// this file. A JS `Float64Array` matches the wasm `(array (mut f64))`: fixed length,
// zero-filled on allocation, f64-typed lanes.
export const length = (a) => a.length;
export const unsafeIndex = (a) => (i) => a[i];
export const unsafeNew = (n) => new Float64Array(n);
export const unsafeSet = (a) => (i) => (v) => {
  a[i] = v;
  return a;
};
