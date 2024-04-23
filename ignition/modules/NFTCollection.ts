import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const OWNER = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";

const NFTCollectionModule = buildModule("NFTCollectionModule", (m) => {
  const owner = m.getParameter("owner", OWNER);

  const nftCollectionToken = m.contract("NFTCollecitonToken", [owner], {});

  return { nftCollectionToken };
});

export default NFTCollectionModule;
