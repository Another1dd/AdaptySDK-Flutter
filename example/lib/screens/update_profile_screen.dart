import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_flutter/models/adapty_enums.dart';
import 'package:adapty_flutter/models/adapty_error.dart';
import 'package:adapty_flutter/models/adapty_profile.dart';
import 'package:adapty_flutter_example/widgets/error_dialog.dart';
import 'package:adapty_flutter_example/widgets/simple_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  DateTime birthdayDate;
  AdaptyGender gender;

  Future<bool> _updateProfile() async {
    final profileBuilder = AdaptyProfileParameterBuilder();
    if (firstNameController.text.isNotEmpty) profileBuilder.setFirstName(firstNameController.text);
    if (lastNameController.text.isNotEmpty) profileBuilder.setLastName(lastNameController.text);
    if (phoneNumberController.text.isNotEmpty) profileBuilder.setPhoneNumber(phoneNumberController.text);
    if (birthdayDate != null) profileBuilder.setBirthday(birthdayDate);
    if (gender != null) profileBuilder.setGender(gender);

    bool result = false;
    try {
      result = await Adapty.updateProfile(profileBuilder);
      print('#Example# updateProfile done!');
    } on AdaptyError catch (adaptyError) {
      AdaptyErrorDialog.showAdaptyErrorDialog(context, adaptyError);
    } catch (e) {
      print('#Example# updateProfile error $e');
    }
    return result;
  }

  void _showSnackBar(BuildContext ctx) {
    Scaffold.of(ctx).showSnackBar(buildSimpleSnackbar('Profile updated.'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            size: 24,
          ),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Builder(
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('First Name:', style: TextStyle(fontSize: 17)),
                  TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                    controller: firstNameController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Last Name:', style: TextStyle(fontSize: 17)),
                  TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                    controller: lastNameController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Phone Number:', style: TextStyle(fontSize: 17)),
                  TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Birthday:', style: TextStyle(fontSize: 17)),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(birthdayDate != null ? DateFormat.yMMMMd().format(birthdayDate) : '', style: TextStyle(fontSize: 17)),
                        IconButton(
                            icon: Icon(Icons.calendar_today_sharp),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: ctx,
                                initialDate: birthdayDate ?? DateTime(2000),
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now(),
                              );
                              setState(() {
                                if (date != null) {
                                  birthdayDate = date;
                                }
                              });
                            })
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gender:', style: TextStyle(fontSize: 17)),
                      DropdownButton<AdaptyGender>(
                        value: gender,
                        icon: Icon(Icons.arrow_drop_down_outlined),
                        iconSize: 30,
                        // style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          // color: Colors.grey,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            gender = newValue;
                          });
                        },
                        items: AdaptyGender.values.map((value) {
                          return DropdownMenuItem<AdaptyGender>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          final res = await _updateProfile();
                          if (res) {
                            _showSnackBar(ctx);
                          }
                        },
                        child: Text('Update Profile'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
