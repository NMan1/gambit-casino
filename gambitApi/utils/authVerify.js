import * as jose from "jose";
import request from "request";

// Apple's public keys
const url = "https://appleid.apple.com/auth/keys";

export const verifyAuth = async (authToken, callback) => {
  try {
    // Fetch the JWKS remotely
    const JWKS = jose.createRemoteJWKSet(new URL(url));

    // Verify the token with the JWKS
    const { payload } = await jose.jwtVerify(authToken, JWKS);

    callback(null, payload);
  } catch (err) {
    // Handle verification errors
    callback(err);
  }
};
