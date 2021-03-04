import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:arturo_bruna_app/domain/repository/api_repository.dart';
import 'package:arturo_bruna_app/domain/repository/local_storage_repository.dart';
import 'package:arturo_bruna_app/domain/model/user.dart';
import 'package:arturo_bruna_app/presentation/common/theme.dart';
import 'package:arturo_bruna_app/presentation/home/home_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/clientes/clientes_screen.dart';
import 'package:arturo_bruna_app/presentation/home/preventas/preventas_bloc.dart';
import 'package:arturo_bruna_app/presentation/home/preventas/preventas_page.dart';
import 'package:arturo_bruna_app/presentation/home/productos/productos_screen.dart';
import 'package:arturo_bruna_app/presentation/home/userprofile/user_screen.dart';

class HomePage extends StatelessWidget {
  HomePage._();

  static Widget init(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue[900]),
    );
    return ChangeNotifierProvider(
      create: (_) => HomeBLoC(
        apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
      )..loadUser(),
      builder: (_, __) => HomePage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeBLoC>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: IndexedStack(
                index: bloc.indexSelected,
                children: [
                  ProductosScreen.init(context),
                  ClientesScreen(),
                  PreSalePage(
                    onShopping: () {
                      bloc.updateIndexSelected(0);
                    },
                  ),
                  UserScreen.init(context)
                ],
              ),
            ),
            _DeliveryNavigationBar(
              index: bloc.indexSelected,
              onIndexSelected: (index) {
                bloc.updateIndexSelected(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryNavigationBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onIndexSelected;

  const _DeliveryNavigationBar({
    Key key,
    this.index,
    this.onIndexSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeBLoC>(context);
    final preSaleBLoC = Provider.of<PreSaleBLoC>(context);
    final user = bloc.usuario;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        print('constrains.maxWidth ${constraints.maxWidth}');
        if (constraints.maxWidth >= 600.0) {
          return _BottomNavBarLarge(
            index: index,
            onIndexSelected: onIndexSelected,
            preSaleBLoC: preSaleBLoC,
            user: user,
          );
        } else {
          return _BottomNavBarSmall(
            index: index,
            onIndexSelected: onIndexSelected,
            preSaleBLoC: preSaleBLoC,
            user: user,
          );
        }
      },
    );
  }
}

class _BottomNavBarSmall extends StatelessWidget {
  const _BottomNavBarSmall({
    Key key,
    @required this.index,
    @required this.onIndexSelected,
    @required this.preSaleBLoC,
    @required this.user,
  }) : super(key: key);

  final int index;
  final onIndexSelected;
  final PreSaleBLoC preSaleBLoC;
  final Usuario user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: deliveryGradients,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.store_mall_directory,
                    color: index == 0 ? DeliveryColors.white : Colors.black87,
                  ),
                  onPressed: () => onIndexSelected(0),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.people,
                      color:
                          index == 1 ? DeliveryColors.white : Colors.black87),
                  onPressed: () => onIndexSelected(1),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange[700],
                      radius: 27.0,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(
                          Icons.shopping_basket,
                          size: 32.0,
                          color: index == 2
                              ? DeliveryColors.white
                              : Colors.purple[500],
                        ),
                        onPressed: () => onIndexSelected(2),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: preSaleBLoC.productsCount == 0
                          ? const SizedBox.shrink()
                          : CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.pinkAccent,
                              child: Text(
                                preSaleBLoC.productsCount.toString(),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 35,
              ),
              InkWell(
                onTap: () => onIndexSelected(3),
                child: user == null || user.imagen == null
                    ? ClipOval(
                        child: SvgPicture.asset(
                          "assets/icons/profile-user.svg",
                          height: 45,
                          width: 45,
                          color: Colors.orange,
                        ),
                      )
                    : CircleAvatar(
                        radius: 24.0,
                        backgroundImage: NetworkImage(
                          user.imagen,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBarLarge extends StatelessWidget {
  const _BottomNavBarLarge({
    Key key,
    @required this.index,
    @required this.onIndexSelected,
    @required this.preSaleBLoC,
    @required this.user,
  }) : super(key: key);

  final int index;
  final onIndexSelected;
  final PreSaleBLoC preSaleBLoC;
  final Usuario user;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: deliveryGradients,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: Colors.transparent,
              onPressed: () => onIndexSelected(0),
              icon: Icon(
                Icons.store_mall_directory,
                color: index == 0 ? DeliveryColors.white : Colors.black87,
              ),
              iconSize:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? MediaQuery.of(context).size.width * 0.04
                      : 50.0,
            ),
            IconButton(
              icon: Icon(Icons.people,
                  color: index == 1 ? DeliveryColors.white : Colors.black87),
              onPressed: () => onIndexSelected(1),
              iconSize:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? MediaQuery.of(context).size.width * 0.04
                      : 50.0,
            ),
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange[700],
                  radius: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? MediaQuery.of(context).size.width * 0.038
                      : 50.0,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    alignment: AlignmentDirectional.center,
                    icon: Icon(
                      Icons.shopping_basket,
                      color: index == 2
                          ? DeliveryColors.white
                          : Colors.purple[500],
                    ),
                    onPressed: () => onIndexSelected(2),
                    iconSize: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? MediaQuery.of(context).size.width * 0.056
                        : 50.0,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: preSaleBLoC.productsCount == 0
                      ? const SizedBox.shrink()
                      : CircleAvatar(
                          radius: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 12
                              : 11,
                          backgroundColor: Colors.pinkAccent,
                          child: Text(
                            preSaleBLoC.productsCount.toString(),
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? 12
                                  : 11,
                            ),
                          ),
                        ),
                )
              ],
            ),
            SizedBox(
              width: 35,
            ),
            InkWell(
              onTap: () => onIndexSelected(3),
              child: user == null || user.imagen == null
                  ? ClipOval(
                      child: SvgPicture.asset(
                        "assets/icons/profile-user.svg",
                        height: 45,
                        width: 45,
                        color: Colors.orange,
                      ),
                    )
                  : CircleAvatar(
                      radius: 28.0,
                      backgroundImage: NetworkImage(
                        user.imagen,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
