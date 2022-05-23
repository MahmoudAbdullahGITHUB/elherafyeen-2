import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateSelectFormField extends StatefulWidget {
  final Function onValidated;
  final TextStyle style;
  DateSelectFormField({this.onValidated, this.style});

  @override
  _DateSelectFormFieldState createState() => _DateSelectFormFieldState();
}

class _DateSelectFormFieldState extends State<DateSelectFormField> {
  DateTime _dateTime;
  DateFormat dateFormat;

  @override
  void initState() {
    _dateTime = DateTime.now();
    dateFormat = DateFormat("yyyy-MM-dd","en");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: dateFormat.format(_dateTime),
      builder: (FormFieldState<String> state) {
        return InkWell(
          child: Container(
            alignment: Alignment.centerLeft,
            // height: 50.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   color: HColors.colorPrimaryDark,
            //   border: Border.all(
            //     color: Colors.white,
            //     width: 1,
            //   ),
            // ),
            child: Text(
              state.value,
              style: widget.style,
              // style: Theme.of(context)
              //     .textTheme
              //     .subtitle1
              //     .copyWith(color: HColors.colorPrimaryDark,
              //   locale: Locale("en","US"),
              // )
              //     .merge(widget.style),
            ),
          ),
          onTap: () async {
            FocusScope.of(context).unfocus();
            DateTime time = await showDatePicker(
                context: context,
                locale: Locale('en', ""),
                initialDate: _dateTime,
                firstDate: _dateTime,
                lastDate: _dateTime.add(Duration(days: 60)));

            if (time != null) {
              state.didChange(dateFormat.format(time));
              _dateTime = time;
              print("vv" + _dateTime.toString());
              print("vv" + dateFormat.format(_dateTime));
              widget.onValidated(dateFormat.format(_dateTime));
            }
          },
        );
      },
      validator: (String value) {
        if (value == null) {
          return "No please select date";
        }
        print("vv" + value);
        widget.onValidated(value);
        return null;
      },
    );
  }
}
