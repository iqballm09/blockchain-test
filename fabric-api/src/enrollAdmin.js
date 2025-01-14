/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

"use strict";

import { Wallets } from "fabric-network";
import FabricCAServices from "fabric-ca-client";
import path from "path";
import {
  buildCAClient,
  enrollAdmin,
  expiredAdminToken,
} from "./util/CAUtil.js";
import {
  buildCCPOrg1,
  buildCCPOrg2,
  buildWallet,
  generateExpiredTime,
  updateFileToken,
} from "./util/AppUtil.js";
import { fileURLToPath } from "url";
import { dirname } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const mspOrg1 = process.env.ORG1_MSPNAME;
const mspOrg2 = process.env.ORG2_MSPNAME;
const caOrg1Domain = process.env.CA_ORG1_DOMAIN;
const caOrg2Domain = process.env.CA_ORG2_DOMAIN;

export async function enrollAdminOrg1(adminUserId, adminUserPasswd) {
  console.log("\n--> Enrolling the Org1 CA admin");
  const ccpOrg1 = buildCCPOrg1();
  const caOrg1Client = buildCAClient(FabricCAServices, ccpOrg1, caOrg1Domain);
  const walletPathOrg1 = path.join(__dirname, "..", "..", "wallet/org1");
  const walletOrg1 = await buildWallet(Wallets, walletPathOrg1);
  const tokenAdmin = await enrollAdmin(
    caOrg1Client,
    walletOrg1,
    adminUserId,
    adminUserPasswd,
    mspOrg1
  );
  // create expired time
  const expiredTime = generateExpiredTime(expiredAdminToken);

  // save token and user id
  updateFileToken({
    id: adminUserId,
    secret: adminUserPasswd,
    mspId: mspOrg1,
    token: tokenAdmin,
    expiredIn: expiredTime,
  });
  return tokenAdmin;
}

export async function enrollAdminOrg2(adminUserId, adminUserPasswd) {
  console.log("\n--> Enrolling the Org2 CA admin");
  const ccpOrg2 = buildCCPOrg2();
  const caOrg2Client = buildCAClient(FabricCAServices, ccpOrg2, caOrg2Domain);

  const walletPathOrg2 = path.join(__dirname, "..", "..", "wallet/org2");
  const walletOrg2 = await buildWallet(Wallets, walletPathOrg2);

  const tokenAdmin = await enrollAdmin(
    caOrg2Client,
    walletOrg2,
    adminUserId,
    adminUserPasswd,
    mspOrg2
  );

  // create expired time
  const expiredTime = generateExpiredTime(expiredAdminToken);

  // save token and user id
  updateFileToken({
    id: adminUserId,
    secret: adminUserPasswd,
    mspId: mspOrg2,
    token: tokenAdmin,
    expiredIn: expiredTime,
  });
  return tokenAdmin;
}
