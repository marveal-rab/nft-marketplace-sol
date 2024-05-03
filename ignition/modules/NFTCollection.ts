import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DEFAULT_ADMIN = "0x9c2D395baB90E4eCd5A892E6EC4199717972CAF0";
const MINTER = "0x9c2D395baB90E4eCd5A892E6EC4199717972CAF0";
const URI =
  "http://127.0.0.1:8080/ipfs/QmUURppuo9yyyKrNDKxeC5eWG3w8yvZsdvb6wqAYhWBpcf";
const NAME = "TEST COLLECTION";
const SYMBOL = "TEST";

const NFTCollectionModule = buildModule("NFTCollectionModule", (m) => {
  const defaultAdmin = m.getParameter("default_admin", DEFAULT_ADMIN);
  const minter = m.getParameter("minter", MINTER);
  const uri = m.getParameter("uri", URI);
  const name = m.getParameter("name", NAME);
  const symbol = m.getParameter("symbol", SYMBOL);

  const nftCollectionToken = m.contract(
    "NFTCollection",
    [defaultAdmin, minter, uri, name, symbol],
    {}
  );

  return { nftCollectionToken };
});

export default NFTCollectionModule;
