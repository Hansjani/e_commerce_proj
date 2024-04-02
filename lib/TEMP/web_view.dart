import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ItemWebView extends StatefulWidget {
  final String url;
  final String title;

  const ItemWebView({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<ItemWebView> createState() => _ItemWebViewState();
}

class _ItemWebViewState extends State<ItemWebView> {
  late final WebViewController controller;
  var loadingPercentage = 100;
  bool _executed = false;

  void _hideClass(String className) {
    const jsCode = """
                         var classes = ['header','related.spad','footer','social-media-bar','product__details__breadcrumb'];
classes.forEach(function(name){
    document.querySelectorAll('.'+name).forEach(function(node){
        node.style.display = 'none';
    });
});
var cartAdded = false;

// Function to add the cart
function addCart() {
    var productDetailsCartOption = document.querySelector(".product__details__cart__option");
    
    var secondAnchor = document.createElement("a");
    secondAnchor.href = "https://ishtexim.com/cartDetail";
    secondAnchor.style.color = "black";
    secondAnchor.style.fontSize = "20px";
    secondAnchor.style.position = "relative";
    secondAnchor.innerHTML = '<i class="fa fa-shopping-cart" aria-hidden="true"></i>';

    var badge = document.createElement("span");
    badge.className = "badge";
    badge.style.backgroundColor = "#e53637";
    badge.style.color = "white";
    badge.style.borderRadius = "50%";
    badge.style.padding = "4px 8px";
    badge.style.position = "absolute";
    badge.style.top = "-15px";
    badge.style.right = "-10px";
    badge.textContent = "0";

    secondAnchor.appendChild(badge);

    productDetailsCartOption.insertAdjacentElement("afterend", secondAnchor);

    cartAdded = true; // Set the flag to true to indicate that the cart is added
}

// Event listener for DOMContentLoaded
document.addEventListener("DOMContentLoaded", function() {
    if (!cartAdded) {
        addCart(); // Add the cart if it's not already added
    }
});


                   """;
    controller.runJavaScript(jsCode).then((value) {
      setState(() {
        _executed = true;
      });
    });
  }

  @override
  void initState() {
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            _hideClass('shop-details');
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            if (_executed) {
              setState(() {
                loadingPercentage = 100;
              });
            }
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [NavigationControls(controller: controller)],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100,
            ),
        ],
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.controller});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () async {
              final message = ScaffoldMessenger.of(context);
              if (await controller.canGoBack()) {
                await controller.goBack();
              } else {
                message.showSnackBar(
                    const SnackBar(content: Text('No backward history')));
              }
            },
            icon: const Icon(Icons.arrow_back)),
        IconButton(
            onPressed: () async {
              final message = ScaffoldMessenger.of(context);
              if (await controller.canGoForward()) {
                await controller.goForward();
              } else {
                message.showSnackBar(
                    const SnackBar(content: Text('No forward history')));
              }
            },
            icon: const Icon(Icons.arrow_forward)),
        IconButton(
            onPressed: () {
              controller.reload();
            },
            icon: const Icon(Icons.replay)),
      ],
    );
  }
}
