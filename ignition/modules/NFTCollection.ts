import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const OWNER = "0x9c2D395baB90E4eCd5A892E6EC4199717972CAF0";

const NFTCollectionModule = buildModule("NFTCollectionModule", (m) => {
  const owner = m.getParameter("owner", OWNER);

  const nftCollectionToken = m.contract("NFTCollecitonToken", [owner], {});

  return { nftCollectionToken };
});

export default NFTCollectionModule;
