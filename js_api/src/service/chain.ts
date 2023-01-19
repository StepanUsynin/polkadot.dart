import { ApiPromise } from "@polkadot/api";

async function getLastBlockTimeStamp(api: ApiPromise) {
  const timestamp = await api.query.timestamp.now();
  return new Date(timestamp.toNumber());
}

export default {
  getLastBlockTimeStamp,
}