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
import 'flutter_flow/flutter_flow_widgets.dart';
import 'globals.dart';

class Taskadd extends StatefulWidget {
   Taskadd({Key? key,required this.empid,required this.name}) : super(key: key);
    String empid;
    String name;

  @override
  State<Taskadd> createState() => _TaskaddState();
}

class _TaskaddState extends State<Taskadd> {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Add Task', empid: widget.empid, name: widget.name,);
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
      Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBtnText,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          child: Card(
            elevation: 3,
            child: TextFormField(
              onChanged: (value){
                _value = value.toString();
                widget.cartItem.flavor = value.toString();
              },
              initialValue: _value,
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
  MyHomePage({ Key? key, required this.title,required this.empid,required this.name}) : super(key: key);

  final String title;
  final String empid,name;


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
      gall=false;
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
      cam=false;
    });
  }
 @override
  void initState() {
    widget.cartItem.img!=""?gall=false:gall=true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
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
                      widget.cartItem.img.trim()==""?
                      addimg():
                      {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  title: Text(
                                    "View Image",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Container(
                                    child: SingleChildScrollView(
                                      child: Form(
                                        child: Column(
                                          children: [
                                            Image.memory(base64Decode( widget.cartItem.img)),
                                            SizedBox(
                                              height: h * 0.04,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: ()  {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      gall=true;cam=true;
                                                      widget.cartItem.img="";
                                                    });
                                                  },
                                                  child: Container(
                                                    height: h * 0.04,
                                                    width: w*0.5,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(6.0),
                                                        ),
                                                        color: primaryColor),
                                                    child: const Center(
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                      };},
                    child:  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Center(
                        child: Card(
                          elevation: 3,
                          child: Icon(
                            Icons.image,
                            color: gall?Colors.grey:Colors.lightBlue ,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      widget.cartItem.img.trim()==""?
                      addimg():
                      {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  title: Text(
                                    "View Image",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Container(
                                    child: SingleChildScrollView(
                                      child: Form(
                                        child: Column(
                                          children: [
                                            Image.memory(base64Decode( widget.cartItem.img)),
                                            SizedBox(
                                              height: h * 0.04,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: ()  {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      gall=true;cam=true;
                                                      widget.cartItem.img="";
                                                    });
                                                  },
                                                  child: Container(
                                                    height: h * 0.04,
                                                    width: w*0.5,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(6.0),
                                                        ),
                                                        color: primaryColor),
                                                    child: const Center(
                                                      child: Text(
                                                        "Cancle",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                      };
                    },
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Card(
                        elevation: 3,
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                gall? Expanded(
                  child: GestureDetector(
                    onTap: (){
                      picimg();
                    },
                    child:  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Center(
                        child: Card(
                          elevation: 3,
                          child: Icon(
                            Icons.photo_camera_sharp,
                            color: !cam?Colors.lightBlue:Colors.grey,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                    },
                    child:  const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Card(
                        elevation: 3,
                        child: Icon(
                          Icons.photo_camera_sharp,
                          color: Colors.grey,
                          size: 28,
                        ),
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
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
        else {
          setState(() {
            context.loaderOverlay.hide();
          });
          final snackBar = SnackBar(
            content: const Text('Unable to send task',),
            backgroundColor: (Colors.red),
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
      bottomSheet: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: FFButtonWidget(
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
                    content: const Text('Add Task',style: TextStyle(color: Colors.red),),
                    backgroundColor: (primaryColor),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
              else
              {
                final snackBar = SnackBar(
                  content: const Text('Fill Task'),
                  backgroundColor: (Colors.red),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            text: 'Send',
            options: FFButtonOptions(
              width: double.infinity,
              height: 40,
              color: Color(0xFF398DEF),
              textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: 10,
            ),
          ),
        ),
      ),
      body: LoaderOverlay(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(top: 0.0),
                    height: h * 0.09,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                              // top: 10.0,
                              left: 15.0,
                            ),
                            //padding: const EdgeInsets.only(left: 5.0),
                            height: h * 0.05,
                            width: h * 0.05,
                            decoration: BoxDecoration(
                              // color: primaryColor,
                                border: Border.all(color: Colors.black26, width: 1.0),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black87,
                              size: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ),
                      ],
                    )),

                Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        key: UniqueKey(),
                        itemCount: cart.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return ListTile(
                            title: CartWidget(
                                cart: cart, index: index, callback: refresh),
                          );
                        }),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
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
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.add),
                        ),
                      ),
                    )
                    ,
                    SizedBox(height: 60,)
                  ],
                ),


              ],
            ),
          ),
        ),
      )
    );
  }
}