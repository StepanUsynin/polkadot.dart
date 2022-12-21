import 'package:polkadot_dart/api/api.dart';
import 'package:polkadot_dart/api/eth/apiAccountEth.dart';
import 'package:polkadot_dart/api/eth/apiKeyringEth.dart';
import 'package:polkadot_dart/service/eth/index.dart';

class ApiEth {
  ApiEth(PolkawalletApi apiRoot, ServiceEth service) {
    account = ApiAccountEth(apiRoot, service.account);
    keyring = ApiKeyringEth(apiRoot, service.keyring);
  }

  late ApiAccountEth account;
  late ApiKeyringEth keyring;
}
