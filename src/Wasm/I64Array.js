// JS provider for `Wasm.I64Array` — used by the `purs` / purs-backend-es builds
// only. The wasm backend resolves these to intrinsics and ignores this file.
// Backed by BigInt64Array, which matches a BigInt `Wasm.Int64` and zero-initialises
// like `array.new_default`.
export const length = (a) => a.length;
export const unsafeIndex = (a) => (i) => a[i];
export const unsafeNew = (n) => new BigInt64Array(n);
export const unsafeSet = (a) => (i) => (v) => {
  a[i] = v;
  return a;
};
