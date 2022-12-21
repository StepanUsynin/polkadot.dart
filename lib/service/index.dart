import 'dart:async';

import 'package:polkadot_dart/api/api.dart';
import 'package:polkadot_dart/service/account.dart';
import 'package:polkadot_dart/service/assets.dart';
import 'package:polkadot_dart/service/bridge.dart';
import 'package:polkadot_dart/service/eth/index.dart';
import 'package:polkadot_dart/service/gov.dart';
import 'package:polkadot_dart/service/keyring.dart';
import 'package:polkadot_dart/service/parachain.dart';
import 'package:polkadot_dart/service/recovery.dart';
import 'package:polkadot_dart/service/setting.dart';
import 'package:polkadot_dart/service/staking.dart';
import 'package:polkadot_dart/service/tx.dart';
import 'package:polkadot_dart/service/uos.dart';
import 'package:polkadot_dart/service/walletConnect.dart';
import 'package:polkadot_dart/service/webViewRunner.dart';
import 'package:polkadot_dart/storage/keyring.dart';

/// The service calling JavaScript API of `polkadot-js/api` directly
/// through [WebViewRunner], providing APIs for [PolkawalletApi].
class SubstrateService {
  late ServiceKeyring keyring;
  late ServiceSetting setting;
  late ServiceAccount account;
  late ServiceTx tx;

  late ServiceStaking staking;
  late ServiceGov gov;
  late ServiceParachain parachain;
  late ServiceAssets assets;
  late ServiceBridge bridge;
  late ServiceUOS uos;
  late ServiceRecovery recovery;

  late ServiceWalletConnect walletConnect;
  late ServiceEth eth;

  WebViewRunner? _web;

  WebViewRunner? get webView => _web;

  Future<void> init(
    Keyring keyringStorage, {
    WebViewRunner? webViewParam,
    Function? onInitiated,
    String? jsCode,
    Function? socketDisconnectedAction,
  }) async {
    keyring = ServiceKeyring(this);
    setting = ServiceSetting(this);
    account = ServiceAccount(this);
    tx = ServiceTx(this);
    staking = ServiceStaking(this);
    gov = ServiceGov(this);
    parachain = ServiceParachain(this);
    assets = ServiceAssets(this);
    bridge = ServiceBridge(this);
    uos = ServiceUOS(this);
    recovery = ServiceRecovery(this);

    walletConnect = ServiceWalletConnect(this);
    eth = ServiceEth(this);

    _web = webViewParam ?? WebViewRunner();
    await _web!.launch(onInitiated,
        jsCode: jsCode, socketDisconnectedAction: socketDisconnectedAction);
  }
}
