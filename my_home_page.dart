import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqlitte/home_page_controller.dart';
import 'package:sqlitte/todo_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController? nameController = TextEditingController();
  TextEditingController? descController = TextEditingController();
  TextEditingController? dateController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<int> items = List<int>.generate(20, (int index) => index);
  ImagePicker picker = ImagePicker();
  RxString imageshow = "".obs;
  var homeController = Get.put(HomePageController());
  @override
  void initState() {
    dateController!.text = "";
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile"),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Dismissible(
                    background: Container(
                      color: Colors.indigoAccent,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    key: ValueKey<int>(items[index]),
                    onDismissed: (DismissDirection direction) {
                      homeController.deleteTodo(
                          id: homeController.todoList[index].id);
                    },
                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () {},
                        icon: IconButton(
                            onPressed: () async {
                              await buildShowModalBottomSheet(context,
                                  isUpdate: true,
                                  id: homeController.todoList[index].id);
                              nameController!.text =
                                  homeController.todoList[index].name!;
                              descController!.text =
                                  homeController.todoList[index].desc!;
                              dateController!.text =
                                  homeController.todoList[index].date!;
                            },
                            icon: Icon(Icons.edit)),
                      ),
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: FileImage(File(
                                "${homeController.todoList[index].avatar}")),
                            radius: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("${homeController.todoList[index].id}"),
                              Text("${homeController.todoList[index].name}"),
                              Text("${homeController.todoList[index].desc}"),
                              Text("${homeController.todoList[index].date}"),
                            ],
                          ),
                        ],
                      ),
                    ));
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: homeController.todoList.length),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await buildShowModalBottomSheet(context, isUpdate: false);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  buildShowModalBottomSheet(BuildContext context,
      {required bool isUpdate, String? id}) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              height: 800,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Obx(
                            () => CircleAvatar(
                              radius: 50,
                              child: ClipOval(
                                  child: imageshow.value != ""
                                      ? Image.file(
                                          File(imageshow.value),
                                          fit: BoxFit.cover,
                                          width: 100,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    AlertDialog(
                                                      title:
                                                          Text("Choose Option"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              final XFile?
                                                                  image =
                                                                  await picker
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.camera);
                                                              imageshow.value =
                                                                  image!.path;
                                                            },
                                                            child:
                                                                Text("Camera")),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              final XFile?
                                                                  image =
                                                                  await picker
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.gallery);
                                                              imageshow.value =
                                                                  image!.path;
                                                            },
                                                            child: Text(
                                                                "Gallary")),
                                                      ],
                                                    ));
                                          },
                                          child: Icon(Icons.camera_alt))),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Name";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Name",
                            labelText: "name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        controller: nameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enter description";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Description",
                            labelText: "Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        controller: descController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            String formatedDate =
                                DateFormat("dd-MM-yyyy").format(pickedDate);
                            setState(() {
                              dateController!.text = formatedDate.toString();
                            });
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enter date";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Date",
                            labelText: "Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        controller: dateController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            if (isUpdate == false) {
                              homeController.addData(
                                  avatar: imageshow.value,
                                  name: nameController!.text,
                                  desc: descController!.text,
                                  date: dateController!.text);
                            } else {
                              homeController.updateTodo(TodoModel(
                                  id: id!,
                                  avatar: imageshow.value,
                                  name: nameController!.text,
                                  desc: descController!.text,
                                  date: dateController!.text));
                            }
                            Navigator.pop(context);
                            nameController!.clear();
                            descController!.clear();
                            dateController!.clear();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                              child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
