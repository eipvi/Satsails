import 'package:Satsails/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Satsails/screens/shared/bottom_navigation_bar.dart';
import 'package:Satsails/translations/translations.dart';
import 'package:Satsails/providers/navigation_provider.dart';

class Services extends ConsumerStatefulWidget {
  const Services({super.key});

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends ConsumerState<Services> with AutomaticKeepAliveClientMixin {
  late WebViewController _webViewController;
  String _currentTitle = 'Dashboards';
  bool _isLoading = true;
  String _currentUrl = 'https://bitcoincounterflow.com/satsails/dashboards-iframe';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_currentUrl));
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(settingsProvider).language;

    super.build(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading:
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() {
              _webViewController.reload();
            });
          },
        ),
        actions: [Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        ],
        title: Center(
          child: Text(
            _currentTitle.i18n(ref),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: _buildDrawer(ref, context, language),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController,
          ),
          if (_isLoading)
            Center(
              child: LoadingAnimationWidget.threeArchedCircle(size: 100, color: Colors.orange),
            ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_currentUrl.contains('bitcoincounterflow'))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () async {
                    if (await _webViewController.canGoBack()) {
                      _webViewController.goBack();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () async {
                    if (await _webViewController.canGoForward()) {
                      _webViewController.goForward();
                    }
                  },
                ),
              ],
            ),
          CustomBottomNavigationBar(
            currentIndex: ref.watch(navigationProvider),
            context: context,
            onTap: (int index) {
              ref.read(navigationProvider.notifier).state = index;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(WidgetRef ref, BuildContext context, String language) {
    final String baseUrl = language == 'pt' ? 'https://bitcoincounterflow.com/pt/satsails' : 'https://bitcoincounterflow.com/satsails';

    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide.none,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Services'.i18n(ref),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.school, color: Colors.orange),
              title: Text('Educação Real'.i18n(ref), style: const TextStyle(color: Colors.white)),
              children: [
                _buildDrawerItem(
                  ref,
                  icon: Icons.arrow_right,
                  title: 'Courses',
                  url: 'https://www.educacaoreal.com',
                ),
              ],
            ),
            _buildDrawerItem(
              ref,
              icon: Icons.dashboard,
              title: 'Dashboards',
              url: '$baseUrl/dashboards-iframe',
            ),
            _buildDrawerItem(
              ref,
              icon: Icons.assessment,
              title: 'ETF Tracker',
              url: '$baseUrl/etf-tracker-iframe',
            ),
            _buildDrawerItem(
              ref,
              icon: Icons.calculate,
              title: 'Retirement Calculator',
              url: '$baseUrl/bitcoin-retirement-calculator-iframe/',
            ),
            _buildDrawerItem(
              ref,
              icon: Icons.attach_money,
              title: 'Bitcoin Converter',
              url: '$baseUrl/bitcoin-converter-calculator-iframe/',
            ),
            _buildDrawerItem(
              ref,
              icon: Icons.history,
              title: 'DCA Calculator',
              url: '$baseUrl/dca-calculator-iframe/',
            ),
            _buildDrawerItem(
              ref,
              icon: Icons.trending_up,
              title: 'Bitcoin Counterflow Strategy',
              url: '$baseUrl/bitcoin-counterflow-strategy-iframe/',
            ),
            _buildDrawerItem(
              ref,
              icon: Icons.show_chart,
              title: 'Charts',
              url: '$baseUrl/charts-iframe',
            ),
            _buildDrawerItem(
              ref,
              icon: Icons.waterfall_chart,
              title: 'Liquidation Zone',
              url: '$baseUrl/liquidation-heatmap-iframe/',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(WidgetRef ref, {required IconData icon, required String title, required String url}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        title.i18n(ref),
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _currentUrl = url;
          _currentTitle = title;
          _webViewController.loadRequest(Uri.parse(url));
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
