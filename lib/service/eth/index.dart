import 'package:polkadot_dart/service/eth/accountEth.dart';
import 'package:polkadot_dart/service/eth/keyringEth.dart';
import 'package:polkadot_dart/service/index.dart';

class ServiceEth {
  ServiceEth(SubstrateService serviceRoot) {
    account = ServiceAccountEth(serviceRoot);
    keyring = ServiceKeyringEth(serviceRoot);
  }

  late ServiceAccountEth account;
  late ServiceKeyringEth keyring;
}
