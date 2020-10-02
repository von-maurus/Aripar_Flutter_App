import 'package:arturo_bruna_app/pages/user_profile.dart';
import 'package:arturo_bruna_app/size_config.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context,
    {bool isTransparent = false, String title, Size size}) {
  return AppBar(
    backgroundColor: isTransparent ? Colors.transparent : Colors.white,
    elevation: 0,
    // leading: IconButton(
    //   onPressed: () {},
    //   icon: Icon(
    //     Icons.menu,
    //     color: Colors.blue[500],
    //   ),
    // ),
    actions: [
      _StatusButton(),
      _RoundedProfilePicture(
        size: size,
      )
    ],
    title: !isTransparent ? Text(title) : null,
    centerTitle: true,
  );
}

class _StatusButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isConnected = true;
    return Container(
        margin: EdgeInsets.only(right: 7.0),
        child: isConnected
            ? InkWell(
                borderRadius: BorderRadius.circular(50.0),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green[300],
                ),
                onTap: () {
                  print("Mostrar snackbar verde 'Conectado'");
                },
              )
            : InkWell(
                onTap: () {
                  print("Mostrar snackbar rojo 'Desconectado'");
                },
                child: Icon(
                  Icons.offline_bolt,
                  color: Colors.red,
                ),
              ));
  }
}

class _RoundedProfilePicture extends StatelessWidget {
  final Size size;
  const _RoundedProfilePicture({Key key, @required this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2, top: 2),
      child: RawMaterialButton(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.asset(
            "assets/images/james.png",
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return UserProfilePage(
              size: size,
            );
          }));
        },
        splashColor: Colors.blue,
        fillColor: Colors.transparent,
        elevation: 2,
        shape: CircleBorder(),
      ),
    );
  }
}
