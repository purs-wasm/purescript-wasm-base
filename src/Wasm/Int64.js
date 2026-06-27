const m = (x) => BigInt.asIntN(64, x);
const u = (x) => BigInt.asUintN(64, x);
export const fromInt = (a) => BigInt(a | 0);
export const fromHiLo = (hi) => (lo) =>
  m((BigInt.asUintN(32, BigInt(hi)) << 32n) | BigInt.asUintN(32, BigInt(lo)));
export const lowBits = (a) => Number(BigInt.asIntN(32, a));
export const hiBits = (a) => Number(BigInt.asIntN(32, u(a) >> 32n));
export const and = (a) => (b) => m(a & b);
export const or = (a) => (b) => m(a | b);
export const xor = (a) => (b) => m(a ^ b);
export const complement = (a) => m(~a);
export const shl = (a) => (b) => m(a << BigInt(b & 63));
export const shr = (a) => (b) => m(a >> BigInt(b & 63));
export const zshr = (a) => (b) => m(u(a) >> BigInt(b & 63));
export const rotl = (a) => (b) => { const n = BigInt(b & 63); return m((a << n) | (u(a) >> (64n - n))); };
export const rotr = (a) => (b) => { const n = BigInt(b & 63); return m((u(a) >> n) | (a << (64n - n))); };
export const eq = (a) => (b) => a === b;
export const lt = (a) => (b) => a < b;
