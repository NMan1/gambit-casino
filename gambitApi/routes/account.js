// routes/search_home.js
import { verifyAuth } from "../utils/authVerify.js";
import { database } from "../index.js";
import { ObjectId } from "bson";
import bcrypt from "bcrypt";
import {
  getDefaultUserFields,
  filterUser,
  addMissingFieldsToUser,
} from "../utils/userSchema.js";
import {
  generateServerSeed,
  generateHashedServerSeed,
} from "../utils/seedGen.js";
import { internalServerError, generateErrorResponse } from "../utils/errors.js";

export const appleAuth = (req, res) => {
  const { authToken, appleId, fullName, email } = req.query;

  database
    .findOne({ appleId: appleId })
    .then((user) => {
      if (user) {
        // check if email provided is different from stored. Ex: delete app resign in with new email but same appleId
        if (email && email !== user.email) {
          user.email = email;
          database.findOneAndUpdate(
            { appleId: appleId },
            { $set: { email: email } }
          );
        }

        user = addMissingFieldsToUser(user, database);

        // user exsists, login user
        return res.send(filterUser(user));
      } else {
        verifyAuth(authToken, (err, payload) => {
          if (err) {
            return internalServerError(res, err);
          } else {
            if (appleId && fullName && email) {
              const serverSeed = generateServerSeed();
              const hashedServerSeed = generateHashedServerSeed(serverSeed);

              const newUser = getDefaultUserFields({
                username: `${fullName.split(" ")[0]}${
                  Math.floor(Math.random() * 99999) + 1
                }`,
                appleId: appleId,
                email: email,
                serverSeed: serverSeed,
                hashedServerSeed: hashedServerSeed,
              });

              database
                .insertOne({
                  ...newUser,
                })
                .then((user) => {
                  return res.send(filterUser(user));
                })
                .catch((err) => {
                  return internalServerError(res, err);
                });
            } else {
              return internalServerError(res, err);
            }
          }
        });
      }
    })
    .catch((err) => {
      return internalServerError(res, err);
    });
};

export const phoneAuth = async (req, res) => {
  const { phoneNumber, password, username } = req.body;

  database
    .findOne({ phoneNumber: phoneNumber })
    .then(async (user) => {
      // login, only password provided
      if (user && password && !username) {
        const isPasswordCorrect = await bcrypt.compare(password, user.password);
        if (!isPasswordCorrect) {
          return generateErrorResponse(
            res,
            "INVALID_PASSWORD",
            "Incorrect password"
          );
        } else {
          user = addMissingFieldsToUser(user, database);
          return res.send(filterUser(user));
        }
      }
      // login but phonenumber doesnt exsist
      else if (!user && password && !username) {
        return generateErrorResponse(
          res,
          "NO_ACCOUNT",
          "Account doesnt exsist"
        );
      }
      // sign up but phone number already exsists
      else if (user && password && username) {
        return generateErrorResponse(
          res,
          "DUPLICATE_PHONE",
          "Account with phone number already exsistst"
        );
      }
      // new user sign up
      else {
        database
          .findOne({
            username: username,
          })
          .then(async (user) => {
            if (user) {
              return generateErrorResponse(
                res,
                "SERVER_ERROR",
                "Account with username already exsists"
              );
            } else {
              // new sign up is unique, create account
              const hashedPassword = await bcrypt.hash(password, 10);
              const serverSeed = generateServerSeed();
              const hashedServerSeed = generateHashedServerSeed(serverSeed);

              const newUser = getDefaultUserFields({
                username: username,
                phoneNumber: phoneNumber,
                password: hashedPassword,
                serverSeed: serverSeed,
                hashedServerSeed: hashedServerSeed,
              });

              database
                .insertOne({
                  ...newUser,
                })
                .then((inserted) => {
                  if (inserted.acknowledged) {
                    database
                      .findOne({
                        _id: new ObjectId(inserted.insertedId),
                      })
                      .then(async (user) => {
                        if (user) {
                          return res.send(filterUser(user));
                        }
                      })
                      .catch((err) => {
                        return internalServerError(res, err);
                      });
                  }
                })
                .catch((err) => {
                  return internalServerError(res, err);
                });
            }
          })
          .catch((err) => {
            return internalServerError(res, err);
          });
      }
    })
    .catch((err) => {
      return internalServerError(res, err);
    });
};

export const setClientSeed = (req, res) => {
  const { userId, clientSeed } = req.body;

  database
    .findOneAndUpdate(
      { _id: new ObjectId(userId) },
      { $set: { clientSeed: clientSeed } },
      { new: true }
    )
    .then((user) => {
      return res.send(filterUser(user));
    })
    .catch((err) => {
      return internalServerError(res, err);
    });
};
