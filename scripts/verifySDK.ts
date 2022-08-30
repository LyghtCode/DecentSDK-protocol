const { network } = require("hardhat");
import { ethers } from "hardhat";

// set up DCNTSDK
const DCNTSDK_ENDPOINT = '0x5FC8d32690cc91D4c39d9d3abcBD16989F875707';

async function main() {
  const DCNTSDK = await ethers.getContractAt("DCNTSDK", DCNTSDK_ENDPOINT);
  const DCNT721A = await DCNTSDK.DCNT721AImplementation();
  const DCNT4907A = await DCNTSDK.DCNT4907AImplementation();
  const DCNTCrescendo = await DCNTSDK.DCNTCrescendoImplementation();
  const DCNTVault = await DCNTSDK.DCNTVaultImplementation();
  const DCNTStaking = await DCNTSDK.DCNTStakingImplementation();

  console.log('\nVerify DCNTSDK:');
  console.log(`npx hardhat verify --network ${network.name}`,
    DCNTSDK_ENDPOINT,
    DCNT721A,
    DCNT4907A,
    DCNTCrescendo,
    DCNTVault,
    DCNTStaking
  );

  console.log('\nVerify DCNT721A:');
  console.log(`npx hardhat verify --network ${network.name} ${DCNT721A}`);

  console.log('\nVerify DCNT4907A:');
  console.log(`npx hardhat verify --network ${network.name} ${DCNT4907A}`);

  console.log('\nVerify DCNTCrescendo:');
  console.log(`npx hardhat verify --network ${network.name} ${DCNTCrescendo}`);

  console.log('\nVerify DCNTVault:');
  console.log(`npx hardhat verify --network ${network.name} ${DCNTVault}`);

  console.log('\nVerify DCNTStaking:');
  console.log(`npx hardhat verify --network ${network.name} ${DCNTStaking}\n`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
