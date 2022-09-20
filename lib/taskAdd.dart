import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            hintStyle: TextStyle(
              color: Colors.black26,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              gapPadding: 9,
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                  Radius.circular(12.0)),
            ),
            contentPadding:
            EdgeInsets.symmetric(
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
  String _value = "low";

  @override
  void initState() {
    super.initState();
    _value= widget.cartItem.itemName!=""?widget.cartItem.itemName:"low";
    widget.cartItem.itemName="low";
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
              items: const [
                DropdownMenuItem(
                  child: Text("low"),
                  value: "low",
                ),
                DropdownMenuItem(
                  child: Text("medium"),
                  value: "medium",
                ),
                DropdownMenuItem(child: Text("high"), value: "high"),

              ],
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
  CartItem({required this.productType, required this.itemName, required this.flavor});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              cart.add(CartItem(
                  productType: "",
                  itemName: "",
                  flavor: ""));
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
                    var item={"task":element.flavor,"priority":element.itemName};
                    data.add(item);
                  }
                else
                  {
                    count++;
                  }

              });
              if(count==0)
                {
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
                }
              else
                {
                  Fluttertoast.showToast(msg: "Fill Task");
                }



    },icon: const Icon(Icons.send),
          )
        ],
      ),
      body: !loder?Column(
        children: <Widget>[
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         cart.add(CartItem(
          //             productType: "",
          //             itemName: "",
          //             flavor: ""));
          //         setState(() {
          //         });
          //       },
          //       child: Text("Add Task"),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Align(
          //         alignment: Alignment.centerRight,
          //         child: FloatingActionButton(
          //           onPressed: () {
          //            var data=[];
          //             cart.forEach((element) {
          //               var item={"task":element.itemName,"priority":element.flavor};
          //               data.add(item);
          //             });
          //             Sendtask({"emp_id":userId,"assigned_to":widget.empid,"tasks":data});
          //           },
          //           backgroundColor: Colors.green,
          //           child: const Icon(Icons.navigation),
          //         ),
          //       ),
          //     ),
          //     // RaisedButton(
          //     //   onPressed: () {
          //     //     for (int i = 0; i < cart.length; i++) {
          //     //       print(cart[i].itemName);
          //     //     }
          //     //   },
          //     //   child: Text("Print Pizza"),
          //     // ),
          //   ],
          // )
        ],
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}