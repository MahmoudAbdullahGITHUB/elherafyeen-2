import 'package:elherafyeen/online_store/src/model/category.dart';
import 'package:elherafyeen/online_store/src/themes/light_color.dart';
import 'package:elherafyeen/online_store/src/themes/theme.dart';
import 'package:elherafyeen/online_store/src/widgets/title_text.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/material.dart';

class ProductIcon extends StatelessWidget {
  // final String imagePath;
  // final String text;
  final ValueChanged<Category> onSelected;
  final Category model;
  ProductIcon({Key key, this.model, this.onSelected}) : super(key: key);

  Widget build(BuildContext context) {
    return model.id == null
        ? Container(width: 5)
        : Container(
            width: MediaQuery.of(context).size.width*.4,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: InkWell(
              onTap: (){
                onSelected(model);
              },
            child:Container(
              padding: AppTheme.hPadding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: model.isSelected
                    ? LightColor.background
                    : Colors.transparent,
                border: Border.all(
                  color: model.isSelected ? HColors.colorPrimaryDark : LightColor.grey,
                  width: model.isSelected ? 2 : 1,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: model.isSelected ? Color(0xfffbf2ef) : Colors.white,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  model.image.isNotEmpty ? Image.asset(model.image) : SizedBox(),
                  model.name == null
                      ? Container()
                      : Container(
                          child: TitleText(
                            text: model.name,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        )
                ],
              ),
            )
            )
          );
  }
}
