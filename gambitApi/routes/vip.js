import { internalServerError, generateErrorResponse } from "../utils/errors.js";
import { database } from "../index.js";
import { ObjectId } from "bson";
import {
  getDefaultUserFields,
  filterUser,
  addMissingFieldsToUser,
} from "../utils/userSchema.js";

function isReloadReady(user) {
  const currentDate = new Date();
  const reloadClaimedDate = new Date(user.vip.reloadClaimedDate);
  const reloadClaimPeriodInSeconds = user.vip.reloadClaimPeriod * 3600; // Convert hours to seconds

  const elapsedTimeInSeconds = (currentDate - reloadClaimedDate) / 1000; // Difference in seconds

  return elapsedTimeInSeconds >= reloadClaimPeriodInSeconds;
}

export const claimReload = (req, res) => {
  const { userId } = req.body;

  database
    .findOne({ _id: new ObjectId(userId) })
    .then((user) => {
      if (isReloadReady(user)) {
        database
          .findOneAndUpdate(
            { _id: new ObjectId(userId) },
            {
              $set: {
                gambitCoin: user.gambitCoin + user.vip.reloadAmount * 100,
                gambitCash: user.gambitCash + user.vip.reloadAmount,
                "vip.reloadClaimedDate": new Date(
                  new Date().getTime() + 24 * 60 * 60 * 1000
                ).toISOString(),
              },
            },
            { returnDocument: "after" }
          )
          .then((user) => {
            return res.send(filterUser(user));
          })
          .catch((err) => {
            return internalServerError(res, err);
          });
      } else {
        return generateErrorResponse(res, "SERVER_ERROR", "Reload not ready");
      }
    })
    .catch((err) => {
      return internalServerError(res, err);
    });
};
