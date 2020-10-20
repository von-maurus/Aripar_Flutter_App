import 'package:flutter/material.dart';

class SearchClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              elevation: 15.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                // controller: TextEditingController(text: locations[0]),
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                    hintText: "Buscar Cliente. Por Nombre o RUT",
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                    prefixIcon: Material(
                      elevation: 0.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(Icons.search),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
