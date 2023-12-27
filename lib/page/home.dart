import 'package:cosmos/cosmos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/theme/color.dart';
import 'package:todoapp/widget/alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> widgets = <Widget>[];
  Future<void> getToDo() async {
    widgets = [];

    SharedPreferences db = await SharedPreferences.getInstance();
    Set<String> allKeys = db.getKeys();
    for (var element in allKeys) {
      List datas = db.get(element) as List;
      String title = datas[0];
      String subtitle = datas[1];
      String status = datas[2];
      if (kDebugMode) {
        print(status);
      }
      // ignore: use_build_context_synchronously
      widgets.add(
        // ignore: use_build_context_synchronously
        post(
          context,
          id: element,
          title: title,
          subtitle: subtitle,
          initStatus: status == "true" ? true : false,
        ),
      );
      print(title);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JeaTheme.bgColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "To*Do",
                        style: TextStyle(
                          color: JeaTheme.txtColor,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "7 Day, 7 App",
                        style: TextStyle(
                          color: JeaTheme.txtColor.withOpacity(0.4),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width(context),
            height: height(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  SizedBox(
                    width: width(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            addToDo(
                              context,
                              onComplated: () async {
                                await getToDo();
                                setState(() {});
                              },
                            );
                          },
                          child: const Text("Yeni Görev"),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences db =
                                await SharedPreferences.getInstance();
                            db.clear();
                            await getToDo();
                            setState(() {});
                          },
                          child: const Text("Tamamını Sil"),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: widgets,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget post(BuildContext context,
      {String? title, String? subtitle, String? id, bool? initStatus}) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: widthPercentage(context, 0.9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: JeaTheme.cColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CosmosCheckBox(
                    initStatus: initStatus ?? false,
                    onTap: (isChecked) async {
                      SharedPreferences db =
                          await SharedPreferences.getInstance();
                      List<String>? datas = db.getStringList(id ?? "");
                      String titles = datas?[0] as String;
                      String subtitles = datas?[1] as String;

                      if (isChecked == true) {
                        List<String> newDatas = [titles, subtitles, "true"];
                        db.setStringList(id ?? "", newDatas);
                        print(db.getStringList(id ?? ""));
                      } else if (isChecked == false) {
                        List<String> newDatas = [titles, subtitles, "false"];
                        db.setStringList(id ?? "", newDatas);
                        print(db.getStringList(id ?? ""));
                      }
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    title ?? "",
                    style: TextStyle(
                      color: JeaTheme.txtColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences db =
                        await SharedPreferences.getInstance();
                    db.remove(id ?? "");
                    getToDo();
                  },
                  child: Icon(
                    Icons.close,
                    color: JeaTheme.txtColor,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitle ?? "",
                  style: TextStyle(
                    color: JeaTheme.txtColor.withOpacity(0.7),
                    fontSize: 14,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
