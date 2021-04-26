import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:typed_data';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/services.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _result = '';
  Uint8List ss = Uint8List(0);
  TextEditingController _inputController;
  TextEditingController _outputController;

  @override
  initState() {
    super.initState();

    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
  }

  // var ads = Container(
  //   height: 50.0,
  //   color: Colors.white,
  // );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR code',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF010729),
      ),
      home: Scaffold(
        //ads
        // bottomNavigationBar: ,
        appBar: AppBar(
          title: Text(
            "QR CODE",
          ),
          centerTitle: true,
        ),
        // bottomNavigationBar: banner,
        floatingActionButton: SpeedDial(
          marginEnd: 18,
          marginBottom: 20,
          icon: Icons.menu,
          activeIcon: Icons.menu_open_outlined,
          activeBackgroundColor: Colors.green[900],
          buttonSize: 56.0,
          visible: true,
          closeManually: false,
          renderOverlay: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () {},
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.green,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            //floationg action buttom is here
            SpeedDialChild(
              child: Icon(Icons.qr_code),
              backgroundColor: Colors.green,
              label: 'Scan Qr Code',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                final permissionValidator = EasyPermissionValidator(
                  context: context,
                  appName: 'Qr code',
                );
                var result = await permissionValidator.camera();
                if (result) {
                  setState(() => _result = 'Permission accepted');
                }

                String barcode = await scanner.scan();
                _outputController.text = barcode;
              },
              onLongPress: () => print('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.image),
              backgroundColor: Colors.green,
              label: 'Import Gallery',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                final permissionValidator = EasyPermissionValidator(
                  context: context,
                  appName: 'Qr code',
                );
                var result = await permissionValidator.storage();
                if (result) {
                  setState(() => _result = 'Permission accepted');
                }

                String barcode = await scanner.scanPhoto();
                _outputController.text = barcode;
              },
              onLongPress: () => print('SECOND CHILD LONG PRESS'),
            ),
            SpeedDialChild(
                child: Icon(CupertinoIcons.barcode),
                backgroundColor: Colors.green,
                label: 'Scan Bar Code',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                  final permissionValidator = EasyPermissionValidator(
                    context: context,
                    appName: 'Qr code',
                  );
                  var result = await permissionValidator.camera();
                  if (result) {
                    setState(() => _result = 'Permission accepted');
                  }
                  String barcode = await scanner.scan();
                  _outputController.text = barcode;
                },
                onLongPress: () async {
                  final permissionValidator = EasyPermissionValidator(
                    context: context,
                    appName: 'Qr code',
                  );
                  var result = await permissionValidator.camera();
                  if (result) {
                    setState(() => _result = 'Permission accepted');
                  }

                  // print('THIRD CHILD LONG PRESS'),
                }),
          ],
        ),
        backgroundColor: Color(0xFF010729),
        body: Builder(
          // PermissionAskerBuilder(
          //   permissions: [
          //     Permission.storage,
          //     Permission.camera,
          //   ],
          //   grantedBuilder: (context) => Center(
          //     child: Text('All permissions granted!'),
          //   ),
          //   notGrantedBuilder: (context, notGrantedPermissions) =>
          //       Center(
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text('Not granted permissions:'),
          //         for (final p in notGrantedPermissions)
          //           Text(p.toString())
          //       ],
          //     ),
          //   ),
          //   notGrantedListener: (notGrantedPermissions) =>
          //       print('Not granted:\n$notGrantedPermissions'),
          // ),
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF010729),
                  ),
                  child: Column(
                    children: <Widget>[
                      // SizedBox(
                      //   child: Text.rich(
                      //     TextSpan(
                      //         text: 'QR Code Gererated',
                      //         style: TextStyle(
                      //             fontSize: 21.0,
                      //             color: Colors.white) // default text style
                      //         ),
                      //   ),
                      // ),
                      SizedBox(),
                      SizedBox(
                          child: Text.rich(
                        TextSpan(
                            text: 'Data for the generation of QR Code',
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.white)),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          controller: this._inputController,
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) async {
                            Uint8List result =
                                await scanner.generateBarCode(value);
                            setState(() => ss = result);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15.0),
                              ),
                              gapPadding: 5.0,
                            ),
                            suffixIcon: IconButton(
                              onPressed: _inputController.clear,
                              icon: Icon(Icons.clear),
                            ),
                            helperStyle: TextStyle(color: Colors.white),
                            hintText: 'Please Input Your Data for QR Code',
                            hintStyle: TextStyle(
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          child: Text.rich(
                        TextSpan(
                            text: 'The Scanned Result',
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.white)),
                      )),

                      SizedBox(
                        height: 2,
                      ),

                      SizedBox(
                        height: 1.0,
                      ),
                      //AQUI O FINAL
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          controller: this._outputController,
                          readOnly: true,
                          //maxLines: 2,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15.0),
                              ),
                              gapPadding: 5.0,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                GlobalKey();

                                await Clipboard.setData(ClipboardData(
                                    text: _outputController.text));

                                final snackBar = SnackBar(
                                  content: Text('Copied'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                print("copied and clear");

                                if (snackBar == snackBar) {
                                  _outputController.clear();
                                } else {
                                  print("err SuffixIcon Copy");
                                }
                              },
                              icon: Icon(Icons.copy),
                            ),
                            helperStyle: TextStyle(color: Colors.white),
                            hintText: 'The results after scanning are :',
                            hintStyle: TextStyle(fontSize: 16),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      //ULTIMA TELA

                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Card(
                          elevation: 6,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.qr_code_scanner,
                                        size: 18, color: Colors.green),
                                    Text(' Generated QR Code',
                                        style: TextStyle(fontSize: 18)),
                                    Spacer(),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 190,
                                      child: ss.isEmpty
                                          ? Center(
                                              child: Text(
                                                  'The Generated QR Code displays here',
                                                  style: TextStyle(
                                                      color: Colors.black38)),
                                            )
                                          : Image.memory(ss),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.black26,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 7, left: 25, right: 55),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          InkWell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 25),
                                                child: new Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.black,
                                                  size: 30.0,
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  ss = Uint8List(0);
                                                  if (ss.isEmpty) {
                                                    final snackBar = SnackBar(
                                                      content: Text('Deleted'),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                    print("apagado");
                                                  } else {
                                                    print("erro ao apagar");
                                                  }
                                                });
                                              }),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var sucess =
                                                  await ImageGallerySaver
                                                      .saveImage(ss);
                                              var hash =
                                                  sucess.hashCode.toString();

                                              if (hash.isNotEmpty) {
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                      'Saved successfully'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                final snackBar = SnackBar(
                                                  content: Text('Error'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                print("essa merda");
                                              }
                                            },
                                            child: new Icon(
                                              Icons.save,
                                              color: Colors.black,
                                              size: 30.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.black26),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  //fineshed here
}
