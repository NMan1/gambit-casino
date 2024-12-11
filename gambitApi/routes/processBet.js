import { database } from "../index.js";
import { ObjectId } from "bson";
import bcrypt from "bcrypt";
import { internalServerError, generateErrorResponse } from "../utils/errors.js";
import { handlePlinko } from "../gameLogic/plinko.js";
import { Currency } from "../utils/userSchema.js";

function updateGameResults(
  res,
  database,
  userId,
  currencyType,
  activeCur,
  gameId,
  betId,
  betAmount,
  betResult
) {
  let bet = {
    currency: currencyType,
    gameId: gameId,
    betId: betId,
    newBalance: activeCur - betAmount + betResult,
    betAmount: betAmount,
    betResult: betResult,
    multi: betResult / betAmount,
  };

  return database
    .findOneAndUpdate(
      { _id: new ObjectId(userId) },
      {
        $set: { [currencyType]: activeCur - betAmount + betResult },
        $push: {
          bets: bet,
        },
      },
      { returnDocument: "after" }
    )
    .then((updatedUser) => {
      if (updatedUser) {
        return res.status(200).json({
          ...bet,
        });
      }
    })
    .catch((err) => {
      print(err);
      return generateErrorResponse(res, "BET_ERROR", "Failed to process bet");
    });
}

export const processBet = (req, res) => {
  const { userId, currency, gameId, betAmmount } = req.body;

  if (betAmmount <= 0) {
    return internalServerError(res);
  }

  database
    .findOne({ _id: new ObjectId(userId) })
    .then((user) => {
      let activeCur =
        Currency.GAMBICOIN == currency ? user.gambitCoin : user.gambitCash;
      if (activeCur < betAmmount) {
        return generateErrorResponse(
          res,
          "INVALID_BALANCE",
          "Balance to low for bet"
        );
      }

      database
        .findOneAndUpdate(
          { _id: new ObjectId(user._id) },
          { $set: { nonce: user.nonce + 1 } },
          { new: true }
        )
        .then((user) => {
          if (user) {
            if (gameId === "plinko") {
              const { betResult, betId } = handlePlinko(betAmmount, user);
              return updateGameResults(
                res,
                database,
                user._id,
                currency,
                activeCur,
                gameId,
                betId,
                betAmmount,
                betResult
              );
            }
          } else {
            return internalServerError(res, err);
          }
        })
        .catch((err) => {
          return internalServerError(res, err);
        });
    })
    .catch((err) => {
      return internalServerError(res, err);
    });
};
