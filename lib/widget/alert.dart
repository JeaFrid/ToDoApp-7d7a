import 'package:cosmos/cosmos.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/theme/color.dart';

TextEditingController title = TextEditingController();
TextEditingController subtitle = TextEditingController();

addToDo(context, {void Function()? onComplated}) {
  return CosmosAlert.showCustomAlert(
    context,
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: heightPercentage(context, 0.35),
          child: Container(
            padding: const EdgeInsets.all(15),
            width: widthPercentage(context, 0.8),
            decoration: BoxDecoration(
              color: JeaTheme.cColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: CosmosBody(
              scrollDirection: Axis.vertical,
              scrollable: true,
              children: [
                Row(
                  children: [
                    Text(
                      "Yeni bir görev ekle...",
                      style: TextStyle(
                        color: JeaTheme.txtColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Eklediğiniz görevler siz silene kadar burada olmaya devam edecekler.",
                        style: TextStyle(
                          color: JeaTheme.txtColor.withOpacity(0.7),
                          fontSize: 14,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CosmosTextBox(
                    "Görev Başlığı",
                    controller: title,
                    color: JeaTheme.txtColor,
                    borderRadius: BorderRadius.circular(10),
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CosmosTextBox(
                    "Görev Başlığı",
                    controller: subtitle,
                    color: JeaTheme.txtColor,
                    borderRadius: BorderRadius.circular(10),
                    maxLines: null,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        SharedPreferences db =
                            await SharedPreferences.getInstance();
                        String random = CosmosRandom.randomTag();
                        if (title.text != "" && subtitle.text != "") {
                          db.setStringList(
                            random,
                            [
                              title.text,
                              subtitle.text,
                              "false",
                            ],
                          );
                          onComplated!();
                          title.clear();
                          subtitle.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Yayınla",
                        style: TextStyle(
                          color: JeaTheme.txtColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
