import 'dart:convert';
import 'dart:developer';
import 'dart:io' as Io;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'flutter_flow/flutter_flow_drop_down.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'globals.dart';

class Taskadd extends StatefulWidget {
   Taskadd({Key? key,required this.empid}) : super(key: key);
    String empid;
  @override
  State<Taskadd> createState() => _TaskaddState();
}

class _TaskaddState extends State<Taskadd> {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Add Task', empid: widget.empid,);
  }
}

class Task extends StatefulWidget {
  CartItem cartItem;

  Task({required this.cartItem});
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  String _value = "";
  void initState() {
    super.initState();
    _value= widget.cartItem.flavor!=""?widget.cartItem.flavor:"";
  }

  @override
  void didUpdateWidget(Task oldWidget) {
    if (oldWidget.cartItem.flavor != widget.cartItem.flavor) {
      _value = widget.cartItem.flavor;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return // Generated code for this Container Widget...
      Expanded(
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBtnText,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
            child: TextFormField(
              onChanged: (value){
                _value = value.toString();
                widget.cartItem.flavor = value.toString();
              },
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Enter Task',
                hintStyle: FlutterFlowTheme.of(context).bodyText2,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).lineColor,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).lineColor,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: FlutterFlowTheme.of(context).subtitle1,
              maxLines: 5,
            ),
          ),
        ),
      )
    ;
  }
}

class Priorety extends StatefulWidget {
  CartItem cartItem;

  Priorety({required this.cartItem});
  @override
  _PrioretyState createState() => _PrioretyState();
}

class _PrioretyState extends State<Priorety> {
  String _value = "Low";
  @override
  void initState() {
    super.initState();
    print(widget.cartItem.itemName);
    _value= widget.cartItem.itemName!=""?widget.cartItem.itemName:"Low";
    widget.cartItem.itemName=_value;
  }

  @override
  void didUpdateWidget(Priorety oldWidget) {
    if (oldWidget.cartItem.itemName != widget.cartItem.itemName) {
      _value = widget.cartItem.itemName;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
        child: FlutterFlowDropDown(
          initialOption: _value,
          options:  item,
          onChanged: (val) => setState(() => {_value = val!,widget.cartItem.itemName=_value}),
          width: MediaQuery.of(context).size.width * 0.5,
          height: 50,
          textStyle: FlutterFlowTheme.of(context).bodyText1.override(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          fillColor: Colors.white,
          elevation: 2,
          borderColor: FlutterFlowTheme.of(context).primaryBtnText,
          borderWidth: 0,
          borderRadius: 2,
          margin: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
          hidesUnderline: true,
        ),
      )


    );
  }
}





class MyHomePage extends StatefulWidget {
  MyHomePage({ Key? key, required this.title,required this.empid}) : super(key: key);

  final String title;
  final String empid;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CartItem {
  String productType;
  String itemName;
  String flavor;
  String img;
  CartItem({required this.productType, required this.itemName, required this.flavor,required this.img});
}


class pickerImage extends StatefulWidget {
  CartItem cartItem;
   pickerImage({Key? key,required this.cartItem}) : super(key: key);
  @override
  State<pickerImage> createState() => _pickerImageState();
}
class _pickerImageState extends State<pickerImage> {
  late bool gall=true,cam=true;
  final ImagePicker _picker = ImagePicker();
  addimg()
  async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery ,imageQuality: 15);
    final bytes = await Io.File(image!.path.toString()).readAsBytes();
    String img64 = base64Encode(bytes);
    print(img64);
    widget.cartItem.img=img64;
    setState(() {
      cam=false;
    });
  }
  picimg()
  async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 15);
    final bytes = await Io.File(image!.path.toString()).readAsBytes();
    String img64 = base64Encode(bytes);
    print(img64);
    widget.cartItem.img=img64;
    setState(() {
      gall=false;
    });
  }
 @override
  void initState() {
    widget.cartItem.img!=""?gall=false:gall=true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children:  [
                cam?  Expanded(
                  child: GestureDetector(
                    onTap: (){
                      addimg();
                    },
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                    },
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                gall? Expanded(
                  child: GestureDetector(
                    onTap: (){
                      picimg();
                    },
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Center(
                        child: Icon(
                          Icons.photo_camera_sharp,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                    },
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Icon(
                        Icons.photo_camera_sharp,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}





class CartWidget extends StatefulWidget {
  List<CartItem> cart;
  int index;
  VoidCallback callback;

  CartWidget({required this.cart, required this.index, required this.callback});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {


  @override
  Widget build(BuildContext context) {
    return

      // Generated code for this Row Widget...
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: FlutterFlowTheme.of(context).primaryBtnText,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: FlutterFlowTheme.of(context).primaryBtnText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Priorety(cartItem: widget.cart[widget.index],),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(flex: 2,child: pickerImage(cartItem: widget.cart[widget.index],)),
                          widget.index!=0? Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(Icons.delete,color: Colors.black,),
                                        onPressed: () {
                                          setState(() {
                                            print(widget.index);
                                            widget.cart.removeAt(widget.index);
                                            widget.callback();
                                          });
                                        })):Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBtnText,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                              child:  Task(cartItem: widget.cart[widget.index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );








    // Column(
    //   children: [
    //     Row(
    //       children: [
    //         Expanded(flex: 9,child: Priorety(cartItem: widget.cart[widget.index])),
    //         widget.index!=0? Expanded(
    //           flex: 1,
    //           child: IconButton(
    //             icon: Icon(Icons.delete),
    //             onPressed: () {
    //               setState(() {
    //                 print(widget.index);
    //                 widget.cart.removeAt(widget.index);
    //                 widget.callback();
    //               });
    //             },
    //           ),
    //         ):Container()
    //       ],
    //     ),
    //     Task(cartItem: widget.cart[widget.index]),
    //     pickerImage(cartItem: widget.cart[widget.index],)
    //   ],
    // );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<CartItem> cart = [];


  void refresh() {
    setState(() {});
  }
  Sendtask(task) async {
    log(task.toString());
        setState(() {
          context.loaderOverlay.show();
        });
        Dio dio=Dio();
        var response = await dio.post('http://training.virash.in/provide_task', data: task);
        if (response.statusCode == 200) {
          setState(() {
            cart.clear();
            cart.add(CartItem(
                productType: "",
                itemName: "",
                flavor: "",
                img:""
            ));
            context.loaderOverlay.hide();
          });
          print(response.data.length);
          final snackBar = SnackBar(
            content: const Text('Sucessfull Send'),
            backgroundColor: (primaryColor),
            action: SnackBarAction(
              label: 'dismiss',
              onPressed: () {
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
        else {
          setState(() {
            context.loaderOverlay.hide();
          });
          final snackBar = SnackBar(
            content: const Text('Unable to send task'),
            backgroundColor: (primaryColor),
            action: SnackBarAction(
              label: 'dismiss',
              onPressed: () {
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
  }

  @override
  void initState() {
    cart.add(CartItem(
        productType: "",
        itemName: "",
        flavor: "",
        img:""
    ));
    setState(() {
    });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    setState(() {
    });
    return Scaffold(
      body: LoaderOverlay(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  height: h * 0.09,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: IconButton(
                            onPressed: () {
                              cart.add(CartItem(
                                  productType: "",
                                  itemName: "",
                                  flavor: "",
                                img:""
                              ));
                              setState(() {
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: IconButton(
                            onPressed: () {
                              var count=0;
                              var data=[];
                              cart.forEach((element) {
                                if(element.flavor.trim()!="")
                                {
                                  var item={"task":element.flavor,"priority":element.itemName,"task_img": element.img};
                                  data.add(item);
                                }
                                else
                                {
                                  count++;
                                }

                              });
                              log(data.toString());
                              if(count==0)
                              {
                                if(data.length>0) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: new Text('Are you sure?'),
                                      content: new Text('Do you want ADD Task'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: new Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () => {
                                            Navigator.of(context).pop(false),
                                            Sendtask({
                                              "emp_id": userId,
                                              "assigned_to": widget.empid,
                                              "tasks": data
                                            })
                                          },
                                          child: new Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  final snackBar = SnackBar(
                                    content: const Text('Add Task'),
                                    backgroundColor: (primaryColor),
                                    action: SnackBarAction(
                                      label: 'dismiss',
                                      onPressed: () {
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }
                              else
                              {
                                final snackBar = SnackBar(
                                  content: const Text('Fill Task'),
                                  backgroundColor: (primaryColor),
                                  action: SnackBarAction(
                                    label: 'dismiss',
                                    onPressed: () {
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              }
                            },icon: const Icon(Icons.send),
                          ),
                        ),
                      )
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                    key: UniqueKey(),
                    itemCount: cart.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return ListTile(
                        title: CartWidget(
                            cart: cart, index: index, callback: refresh),
                      );
                    }),
              ),

            ],
          ),
        ),
      )
    );
  }
}