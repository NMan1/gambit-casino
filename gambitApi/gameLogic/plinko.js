import { generateRandomValue } from "../utils/seedGen.js";
import { v4 as uuidv4 } from "uuid";

let multipliers = [1000, 130, 26, 9, 4, 0.2, 0.2, 0.2, 4, 9, 26, 130, 1000];
let probabilities = [
  0.0004, // Multiplier 1000
  0.0008, // Multiplier 130
  0.00402, // Multiplier 26
  0.01506, // Multiplier 9
  0.04519, // Multiplier 4
  0.30632, // Multiplier 0.2
  0.30632, // Multiplier 0.2
  0.30632, // Multiplier 0.2
  0.00803, // Multiplier 4
  0.00402, // Multiplier 9
  0.00251, // Multiplier 26
  0.0008, // Multiplier 130
  0.0002, // Multiplier 1000
];

function generateMultiplier(probabilities, clientSeed, serverSeed, nonce) {
  const randomValue = generateRandomValue(clientSeed, serverSeed, nonce);
  let cumulativeProbability = 0.0;

  for (let index = 0; index < probabilities.length; index++) {
    cumulativeProbability += probabilities[index];
    if (randomValue <= cumulativeProbability) {
      return multipliers[index];
    }
  }

  return multipliers[probabilities.length - 1];
}

export const handlePlinko = (betAmmount, user) => {
  let multiplier = generateMultiplier(
    probabilities,
    user.clientSeed,
    user.serverSeed,
    user.nonce
  );

  let betResult = betAmmount * multiplier;
  let betId = uuidv4();

  return { betResult, betId };
};
