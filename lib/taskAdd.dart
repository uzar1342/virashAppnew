import 'dart:convert';
import 'dart:io' as Io;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'globals.dart';

final List<DropdownMenuItem<String>> item=[];
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
    return Container(
      child:TextFormField(
        initialValue: _value,
        maxLines:2,
        onChanged: (value) {
          setState(() {
            _value = value.toString();
            widget.cartItem.flavor = value.toString();
          });
        },
        cursorColor: primaryColor,
        decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.assignment,
              color: Colors.red.shade200,
            ),
            hintText: "Task",
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              gapPadding: 9,
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                  Radius.circular(12.0)),
            ),
            contentPadding:
            const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0)),
      ),

    );
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
    _value= widget.cartItem.itemName!=""?widget.cartItem.itemName:"Low";
    widget.cartItem.itemName="Low";
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
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity - 50,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              filled: true,
              fillColor: Colors.blueGrey,
            ),
            dropdownColor: Colors.blueGrey,
            isExpanded: false,
               items: item
            // const [
              //   DropdownMenuItem(
              //     value: "low",
              //     child: Text("low"),
              //   ),
              //   DropdownMenuItem(
              //     value: "medium",
              //     child: Text("medium"),
              //   ),
              //   DropdownMenuItem(value: "high", child: Text("high")),
              //
              // ]
               ,
              onChanged: (value) {
        setState(() {
        _value = value.toString();
        widget.cartItem.itemName = value.toString();
        });
        },
            value: _value,
            hint: const Text(
              "Select Priority",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),


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
  late bool selectimg;
  final ImagePicker _picker = ImagePicker();
  addimg()
  async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery ,imageQuality: 15);
    final bytes = await Io.File(image!.path.toString()).readAsBytes();
    String img64 = base64Encode(bytes);
    print(img64);
    widget.cartItem.img=img64;
    setState(() {
      selectimg=!selectimg;
    });
  }
  picimg()
  async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 15);
    final bytes = await Io.File(image!.path.toString()).readAsBytes();
// or
    String img64 = base64Encode(bytes);
    print(img64);
    widget.cartItem.img=img64;
  }

 @override
  void initState() {
    widget.cartItem.img!=""?selectimg=false:selectimg=true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  selectimg?Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){
              setState(() {
                selectimg=false;
              });
              picimg();
            }, child: Text("Image from camera")),
          ),
        ), 
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){
              addimg();
            }, child: Text("Image from gallery")),
          ),
        ),
      ],
    ):Text("Image Selected");
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 9,child: Priorety(cartItem: widget.cart[widget.index])),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    print(widget.index);
                    widget.cart.removeAt(widget.index);
                    widget.callback();
                  });
                },
              ),
            )
          ],
        ),
        Task(cartItem: widget.cart[widget.index]),
        pickerImage(cartItem: widget.cart[widget.index],)
      ],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<CartItem> cart = [];

  bool loder= false;

  void refresh() {
    setState(() {});
  }
  Sendtask(task) async {
        print(task);
        setState(() {
          loder=true;
        });
        Dio dio=Dio();
        var response = await dio.post('http://training.virash.in/provide_task', data: task);
        if (response.statusCode == 200) {
          setState(() {
            cart.clear();
            loder=false;
          });
          print(response.data.length);
          Fluttertoast.showToast(msg: "Sucessfull Send");
        }
        else {
          setState(() {
            loder=false;
          });
          Fluttertoast.showToast(msg: "Unable to send task");
        }


  }
  ADDtaskpriorety() async {
    setState(() {
      loder=true;
    });
    Dio dio=Dio();
    var response = await dio.post('http://training.virash.in/showPriority');
    print(response.data.length);



    if (response.statusCode == 200) {
      if(response.data["data"]!=null)
      {
        int len=int.parse(response.data["data"].length.toString());
        for(int i=0;i<len;i++)
        {
          item.add(DropdownMenuItem(
            value: response.data["data"][i].toString(),
            child: Text(response.data["data"][i].toString()),
          )) ;
        }
      }
      setState(() {
        loder=false;
      });

    }
    else {
      setState(() {
        loder=false;
      });
      Fluttertoast.showToast(msg: "Unable to send task");
    }
  }
  @override
  void initState() {
    ADDtaskpriorety();
    super.initState();
  }
  @override
  void dispose() {
    item.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: !loder?SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 0.0),
                height: h * 0.09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
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
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    IconButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const AttendancePage()));
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.chartArea,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    IconButton(
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
                    IconButton(
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
                        print(data);
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
                          } else
                            Fluttertoast.showToast(msg: "Add Task");
                        }
                        else
                        {
                          Fluttertoast.showToast(msg: "Fill Task");
                        }
                      },icon: const Icon(Icons.send),
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
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}