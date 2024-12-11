import crypto from "crypto";

export function generateHashedServerSeed(serverSeed) {
  return crypto.createHash("sha256").update(serverSeed).digest("hex");
}

export function generateServerSeed() {
  return crypto.randomBytes(32).toString("hex");
}

export function generateRandomValue(clientSeed, serverSeed, nonce) {
  const input = `${clientSeed}:${serverSeed}:${nonce}`;
  const hash = crypto.createHash("sha256").update(input).digest("hex");
  const randomInt = parseInt(hash.slice(0, 8), 16);
  return randomInt / 0xffffffff;
}
