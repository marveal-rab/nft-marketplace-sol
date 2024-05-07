import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const INITIAL_OWNER = "0x9c2D395baB90E4eCd5A892E6EC4199717972CAF0";
const URI =
  "http://127.0.0.1:8080/ipfs/QmUURppuo9yyyKrNDKxeC5eWG3w8yvZsdvb6wqAYhWBpcf";
const NAME = "TEST COLLECTION";
const SYMBOL = "TEST";

const NFTCollectionModule = buildModule("NFTCollectionModule", (m) => {
  const initialAdmin = m.getParameter("initial_admin", INITIAL_OWNER);
  const uri = m.getParameter("uri", URI);
  const name = m.getParameter("name", NAME);
  const symbol = m.getParameter("symbol", SYMBOL);

  const nftCollectionToken = m.contract(
    "NFTCollection",
    [initialAdmin, uri, name, symbol],
    {}
  );

  return { nftCollectionToken };
});

export default NFTCollectionModule;
