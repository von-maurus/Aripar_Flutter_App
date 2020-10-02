import 'package:flutter/material.dart';

import 'package:arturo_bruna_app/pages/components/app_bar.dart';
import 'package:arturo_bruna_app/pages/components/animated_bottom_bar.dart';
import 'package:arturo_bruna_app/pages/delivery_page.dart';
import 'package:arturo_bruna_app/pages/notificaciones_page.dart';
import 'package:arturo_bruna_app/pages/preventas_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage;

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context, isTransparent: true, size: size),
      body: getPage(_currentPage),
      bottomNavigationBar: AnimatedBottomBar(
        currentIndex: _currentPage,
        onChange: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return PreVentasPage();
      case 1:
        return NotificacionesPage();
    }
  }
}
