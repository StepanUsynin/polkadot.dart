import 'dart:convert';

import 'package:polkadot_dart/api/apiAccount.dart';
import 'package:polkadot_dart/api/apiAssets.dart';
import 'package:polkadot_dart/api/apiBridge.dart';
import 'package:polkadot_dart/api/apiGov.dart';
import 'package:polkadot_dart/api/apiKeyring.dart';
import 'package:polkadot_dart/api/apiParachain.dart';
import 'package:polkadot_dart/api/apiRecovery.dart';
import 'package:polkadot_dart/api/apiSetting.dart';
import 'package:polkadot_dart/api/apiStaking.dart';
import 'package:polkadot_dart/api/apiTx.dart';
import 'package:polkadot_dart/api/apiUOS.dart';
import 'package:polkadot_dart/api/apiWalletConnect.dart';
import 'package:polkadot_dart/api/eth/index.dart';
import 'package:polkadot_dart/api/subscan.dart';
import 'package:polkadot_dart/api/types/networkParams.dart';
import 'package:polkadot_dart/service/index.dart';
import 'package:polkadot_dart/storage/keyring.dart';

/// The [PolkawalletApi] instance is the wrapper of `polkadot-js/api`.
/// It provides:
/// * [ApiKeyring] of npm package [@polkadot/keyring](https://www.npmjs.com/package/@polkadot/keyring)
/// * [ApiSetting], the [networkConst] and [networkProperties] of `polkadot-js/api`.
/// * [ApiAccount], for querying on-chain data of accounts, like balances or indices.
/// * [ApiTx], sign and send tx.
/// * [ApiStaking] and [ApiGov], the staking and governance module of substrate.
/// * [ApiUOS], provides the offline-signature ability of polkawallet.
/// * [ApiRecovery], the social-recovery module of Kusama network.
class PolkawalletApi {
  PolkawalletApi(this.service) {
    keyring = ApiKeyring(this, service.keyring);
    setting = ApiSetting(this, service.setting);
    account = ApiAccount(this, service.account);
    tx = ApiTx(this, service.tx);

    staking = ApiStaking(this, service.staking);
    gov = ApiGov(this, service.gov);
    parachain = ApiParachain(this, service.parachain);
    assets = ApiAssets(this, service.assets);
    bridge = ApiBridge(this, service.bridge);
    uos = ApiUOS(this, service.uos);
    recovery = ApiRecovery(this, service.recovery);

    walletConnect = ApiWalletConnect(this, service.walletConnect);
    eth = ApiEth(this, service.eth);
  }

  final SubstrateService service;

  NetworkParams? _connectedNode;

  late ApiKeyring keyring;
  late ApiSetting setting;
  late ApiAccount account;
  late ApiTx tx;

  late ApiStaking staking;
  late ApiGov gov;
  late ApiParachain parachain;
  late ApiAssets assets;
  late ApiBridge bridge;
  late ApiUOS uos;
  late ApiRecovery recovery;

  late ApiWalletConnect walletConnect;
  late ApiEth eth;

  final SubScanApi subScan = SubScanApi();

  // void init() {
  //   keyring = ApiKeyring(this, service.keyring);
  //   setting = ApiSetting(this, service.setting);
  //   account = ApiAccount(this, service.account);
  //   tx = ApiTx(this, service.tx);

  //   staking = ApiStaking(this, service.staking);
  //   gov = ApiGov(this, service.gov);
  //   parachain = ApiParachain(this, service.parachain);
  //   assets = ApiAssets(this, service.assets);
  //   uos = ApiUOS(this, service.uos);
  //   recovery = ApiRecovery(this, service.recovery);

  //   walletConnect = ApiWalletConnect(this, service.walletConnect);
  // }

  NetworkParams? get connectedNode => _connectedNode;

  /// connect to a list of nodes, return null if connect failed.
  Future<NetworkParams?> connectNode(
      Keyring keyringStorage, List<NetworkParams> nodes) async {
    _connectedNode = null;
    final NetworkParams? res = await service.webView!.connectNode(nodes);
    if (res != null) {
      _connectedNode = res;

      // update indices of keyPairs after connect
      keyring.updateIndicesMap(keyringStorage);
    }
    return res;
  }

  Future<NetworkParams?> connectEVM(NetworkParams node) async {
    _connectedNode = null;
    final NetworkParams? res = await service.webView!.connectEVM(node);
    if (res != null) {
      _connectedNode = res;
    }
    return res;
  }

  /// subscribe message.
  Future<void> subscribeMessage(
    String JSCall,
    List params,
    String channel,
    Function callback,
  ) async {
    service.webView!.subscribeMessage(
      'settings.subscribeMessage($JSCall, ${jsonEncode(params)}, "$channel")',
      channel,
      callback,
    );
  }

  /// unsubscribe message.
  void unsubscribeMessage(String channel) {
    service.webView!.unsubscribeMessage(channel);
  }
}
