// fileName : server.js

import express from "express";
import { MongoClient, ServerApiVersion } from "mongodb";
import { appleAuth, phoneAuth, setClientSeed } from "./routes/account.js";
import { processBet } from "./routes/processBet.js";
import { claimReload } from "./routes/vip.js";

const app = express();
const PORT = 3000;

const uri =
  "mongodb+srv://doadmin:4B3W97o5681GuPfU@gambitnodedb-fae9dbe5.mongo.ondigitalocean.com/admin?tls=true&authSource=admin";

const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
});

async function run() {
  await client.connect();
  await client.db("gambit").command({ ping: 1 });
  console.log("\nSuccessfully connected to Database");

  return client.db("gambit").collection("users");
}

export const database = await run().catch();

app.use(express.json());

app.post("/appleAuth", appleAuth);
app.post("/phoneAuth", phoneAuth);
app.post("/setClientSeed", setClientSeed);
app.post("/processBet", processBet);
app.post("/claimReload", claimReload);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
