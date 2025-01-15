/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

"use strict";

import fs from "fs";
import path from "path";
import { v4 as uuidv4 } from "uuid";
import { fileURLToPath } from "url";
import { dirname } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const tokenFilePath = path.resolve(
  __dirname,
  "..",
  "..",
  "..",
  "wallet",
  "token.json"
);

export const buildCCPOrg1 = () => {
  // load the common connection configuration file
  const ccpPath = path.resolve(
    __dirname,
    "..",
    "..",
    "..",
    process.env.CCPPATH_ORG1
  );
  const fileExists = fs.existsSync(ccpPath);
  if (!fileExists) {
    throw new Error(`no such file or directory: ${ccpPath}`);
  }
  const contents = fs.readFileSync(ccpPath, "utf8");

  // build a JSON object from the file contents
  const ccp = JSON.parse(contents);

  console.log(`Loaded the network configuration located at ${ccpPath}`);
  return ccp;
};

export const buildCCPOrg2 = () => {
  // load the common connection configuration file
  const ccpPath = path.resolve(
    __dirname,
    "..",
    "..",
    "..",
    process.env.CCPPATH_ORG2
  );

  const fileExists = fs.existsSync(ccpPath);
  if (!fileExists) {
    throw new Error(`no such file or directory: ${ccpPath}`);
  }
  const contents = fs.readFileSync(ccpPath, "utf8");

  // build a JSON object from the file contents
  const ccp = JSON.parse(contents);

  console.log(`Loaded the network configuration located at ${ccpPath}`);
  return ccp;
};

export const buildWallet = async (Wallets, walletPath) => {
  // Create a new  wallet : Note that wallet is for managing identities.
  let wallet;
  if (walletPath) {
    wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Built a file system wallet at ${walletPath}`);
  } else {
    wallet = await Wallets.newInMemoryWallet();
    console.log("Built an in memory wallet");
  }

  return wallet;
};

export const prettyJSONString = (inputString) => {
  if (inputString) {
    return JSON.stringify(JSON.parse(inputString), null, 2);
  } else {
    return inputString;
  }
};

export const generateToken = (userId) => {
  const token = `${uuidv4()}-${userId}`;
  return token;
};

export const generateExpiredTime = (expiresIn) => {
  const timeInSeconds = Math.floor(Date.now() / 1000);
  const time = expiresIn.match(/\d+/)[0];
  const unitTime = expiresIn.charAt(expiresIn.length - 1);
  const expiredTime =
    timeInSeconds + (unitTime == "m" ? time * 60 : time * 3600);
  return expiredTime;
};

export const updateFileToken = (tokenData) => {
  let isTokenExist = false;

  fs.readFile(tokenFilePath, { flag: "a+" }, (err, data) => {
    if (err) {
      console.log(err);
      return;
    }

    let jsonData = data.length > 0 ? JSON.parse(data) : [];
    jsonData.forEach((element) => {
      if (element["id"] == tokenData["id"]) {
        element["token"] = tokenData["token"];
        element["expiredIn"] = tokenData["expiredIn"];
        isTokenExist = true;
      }
    });

    if (!isTokenExist) {
      jsonData.push(tokenData);
    }

    let updatedData = JSON.stringify(jsonData);

    fs.writeFile(tokenFilePath, updatedData, (err) => {
      if (err) {
        console.log(err);
        return;
      }
    });
  });
  return;
};

export const getUserTokenData = (id) => {
  let searchData = {};
  // Read file synchronously
  const data = fs.readFileSync(tokenFilePath, "utf-8");
  const jsonData = JSON.parse(data);

  jsonData.forEach((row) => {
    if (row["id"] == id) {
      searchData = row;
    }
  });

  return searchData;
};
