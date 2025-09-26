// ui/_core/appbar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../widgets/bag_provider.dart';
import '../widgets/checkout/checkout.dart';

AppBar getAppBar({required BuildContext context, String? title}) {
  BagProvider bagProvider = Provider.of(context);
  return AppBar(
    title: title != null ? Text(title) : null,
    centerTitle: true,
    actions: [
      badges.Badge(
        showBadge: bagProvider.reservationsOnBag.isNotEmpty,
        position: badges.BadgePosition.bottomStart(start: 0, bottom: 0),
        badgeContent: Text(
          bagProvider.reservationsOnBag.length.toString(),
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
            );
          },
          icon: const Icon(Icons.shopping_basket),
        ),
      ),
    ],
  );
}
