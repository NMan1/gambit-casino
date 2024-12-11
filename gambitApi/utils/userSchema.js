import { Double } from "mongodb";
import { ObjectId } from "bson";

export const getDefaultUserFields = (overrides = {}) => {
  return {
    username: "",
    phoneNumber: "",
    email: "",
    appleId: "",
    password: "",
    vip: {
      vipLevel: 0,
      vipProgress: new Double(0.0),
      reloadAmount: new Double(5.0),
      reloadClaimPeriod: 24,
      reloadClaimedDate: new Date(
        new Date().getTime() - 24 * 60 * 60 * 1000
      ).toISOString(),
    },
    gambitCoin: new Double(10.0),
    gambitCash: new Double(10.0),
    createdAt: new Date().toISOString(),
    isVerified: false,
    clientSeed: "",
    serverSeed: "",
    hashedServerSeed: "",
    nonce: 0,
    bets: [],
    ...overrides,
  };
};

export const filterUser = (user) => {
  const {
    password: _password,
    serverSeed: _serverSeed,
    nonce: _nonce,
    ...strippedUser
  } = user;

  return strippedUser;
};

export const addMissingFieldsToUser = (user, database) => {
  const defaultFields = getDefaultUserFields();
  const updates = {};

  for (const [key, value] of Object.entries(defaultFields)) {
    if (user[key] === undefined) {
      updates[key] = value;
    }
  }

  if (Object.keys(updates).length > 0) {
    database.findOneAndUpdate(
      { _id: new ObjectId(user._id) },
      { $set: updates }
    );
    return { ...user, ...updates };
  }

  return user;
};

export const Currency = Object.freeze({
  GAMBICOIN: "gambitCoin",
  GAMBICASH: "gambitCash",
});
