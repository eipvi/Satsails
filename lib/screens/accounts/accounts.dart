import 'package:Satsails/assets/lbtc_icon.dart';
import 'package:Satsails/helpers/fiat_format_converter.dart';
import 'package:Satsails/translations/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Satsails/models/balance_model.dart';
import 'package:Satsails/providers/balance_provider.dart';
import 'package:Satsails/providers/bitcoin_provider.dart';
import 'package:Satsails/providers/liquid_provider.dart';
import 'package:Satsails/providers/settings_provider.dart';
import 'package:Satsails/screens/shared/copy_text.dart';
import 'package:Satsails/screens/shared/qr_code.dart';
import 'package:Satsails/screens/shared/qr_view_widget.dart';

class Accounts extends ConsumerWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Account Management'.i18n(ref)),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: screenWidth * 0.02),
            Text(
              'Secure Bitcoin'.i18n(ref),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenWidth * 0.02),
            Consumer(
              builder: (context, ref, _) {
                final format = ref.watch(settingsProvider).btcFormat;
                final currency = ref.watch(settingsProvider).currency;
                final balanceProvider = ref.watch(balanceNotifierProvider);
                final btcBalanceInFormat = ref.watch(btcBalanceInFormatProvider(format));
                final bitcoinAddress = ref.watch(bitcoinAddressProvider.future);
                final bitcoinInCurrency = ref.watch(currentBitcoinPriceInCurrencyProvider(CurrencyParams(ref.watch(settingsProvider).currency, balanceProvider.btcBalance))).toStringAsFixed(2);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        _buildListTile('Bitcoin', btcBalanceInFormat, const Icon(LineAwesome.bitcoin, color: Colors.white), context, bitcoinAddress, bitcoinInCurrency, currency, format, ref),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              'Instant Payments'.i18n(ref),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenWidth * 0.02),
            Consumer(
              builder: (context, ref, _) {
                final format = ref.watch(settingsProvider).btcFormat;
                final currency = ref.watch(settingsProvider).currency;
                final balanceProvider = ref.watch(balanceNotifierProvider);
                final liquidBalanceInFormat = ref.watch(liquidBalanceInFormatProvider(format));
                final liquid = ref.watch(liquidAddressProvider.future);
                final liquidInCurrency = ref.watch(currentBitcoinPriceInCurrencyProvider(CurrencyParams(ref.watch(settingsProvider).currency, balanceProvider.liquidBalance))).toStringAsFixed(2);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.deepPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        _buildListTile('Liquid', liquidBalanceInFormat, const Icon(Lbtc_icon.lbtc_icon, color: Colors.white), context, liquid, liquidInCurrency, currency, format, ref),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              'Assets'.i18n(ref),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenWidth * 0.02),
            Consumer(
              builder: (context, ref, _) {
                final balance = ref.watch(balanceNotifierProvider);
                final liquid = ref.watch(liquidAddressProvider.future);
                return Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF009B3A), Color(0xFF009B3A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            _buildListTile('Real', fiatInDenominationFormatted(balance.brlBalance), Flag(Flags.brazil), context, liquid, '', '', '', ref),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF008000), Color(0xFF008000)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            _buildListTile('Dollar', fiatInDenominationFormatted(balance.usdBalance), Flag(Flags.united_states_of_america), context, liquid, '', '', '', ref),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF003399), Color(0xFF003399)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            _buildListTile('Euro', fiatInDenominationFormatted(balance.eurBalance), Flag(Flags.european_union), context, liquid, '', '', '', ref),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String trailing, icon, BuildContext context, bitcoin, String balance, String denomination, String format, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: icon,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white, fontWeight: FontWeight.bold), // 4% of screen width
            ),
            if (balance.isNotEmpty)
              Row(
                children: [
                  Text(
                    balance,
                    style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white), // 4% of screen width
                  ),
                  Text(
                    ' $denomination',
                    style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white), // 4% of screen width
                  ),
                ],
              ),
          ],
        ),
        trailing: Text('$trailing $format', style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white)), // 4% of screen width
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  _receivePayment(context, bitcoin, ref);
                },
                child: const Icon(Icons.arrow_downward, color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        child: QRViewWidget(
                          qrKey: GlobalKey(debugLabel: 'QR'),
                          ref: ref,
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _receivePayment(BuildContext context, dynamic bitcoin, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        return FutureBuilder<dynamic>(
          future: bitcoin,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoadingAnimationWidget.threeArchedCircle(size: 200, color: Colors.orange));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final String address = snapshot.data is String ? snapshot.data : snapshot.data.confidential;
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: screenSize.height * 0.02),
                            child: Text(
                              'Receive'.i18n(ref),
                              style: TextStyle(fontSize: screenSize.width * 0.06),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildQrCode(address, context),
                        SizedBox(height: screenSize.height * 0.02),
                        buildAddressText(address, context, ref),
                        SizedBox(height: screenSize.height * 0.02),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No data'));
            }
          },
        );
      },
    );
  }
}
