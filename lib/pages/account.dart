import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/auth.dart';

import 'package:pocket/widgets/custom/textfield.dart';
import 'package:pocket/widgets/custom/modal_action_button.dart';

import 'package:pocket/style/colors.dart';
// import 'package:pocket/style/style.dart';

class AccountPage extends StatefulWidget with NavigationStates {

  @override
  AccountPageState createState() => AccountPageState();

}

class AccountPageState extends State <AccountPage> {

  bool _loading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Error!', 
          style: const TextStyle(color: Colors.red, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Text (
          message,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  // used only for both logout and delete account button
  void _showConfirmDialog(String message, bool logout) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Are you sure?', 
          style: const TextStyle(color: mainDarkBlue, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Text (
          message,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () async {
              setState(() => this._loading = true);

              Navigator.of(context).pop();

              try {
                if (logout) await Provider.of<Auth>(context, listen: false).logout();
                else await Provider.of<Auth>(context, listen: false).delete();
              }

              catch (err) {
                if (!logout) this._showErrorDialog('Failed to delete account!');
              }

              finally { setState(() => this._loading = false); }
            },
          )
        ],
      )
    );
  }

  void _showChangeDialog(String title, String placeholder, String secondPlaceholder) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: _ChangeValue(title: title, placeholder: placeholder, secondPlaceholder: secondPlaceholder,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Center(
              child: Text(
                "Your Account",
                style: const TextStyle(
                  fontSize: 24,
                  color: mainBlue,
                  fontWeight: FontWeight.w800
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text ('General', style: new TextStyle(fontSize: 18, color: mainBlue, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          width: 0.7,
                          color: mainDarkBlue.withAlpha(204)
                        ))
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text ('Avatar', style: new TextStyle(fontSize: 16)),
                        subtitle: Text('Change your avatar', style: new TextStyle(fontSize: 14),),
                      ),
                    ),

                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          width: 0.7,
                          color: mainDarkBlue.withAlpha(204)
                        ))
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text ('Name', style: new TextStyle(fontSize: 16)),
                        subtitle: Text('Erick Salas', style: new TextStyle(fontSize: 14),),
                        onTap: () => this._showChangeDialog("Change name", "Enter your name", null),
                      ),
                    ),

                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          width: 0.7,
                          color: mainDarkBlue.withAlpha(204)
                        ))
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text ('Username', style: new TextStyle(fontSize: 16)),
                        subtitle: Text('erick', style: new TextStyle(fontSize: 14),),
                      ),
                    ),

                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          width: 0.7,
                          color: mainDarkBlue.withAlpha(204)
                        ))
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text ('Email', style: new TextStyle(fontSize: 16)),
                        subtitle: Text('erick@test.com', style: new TextStyle(fontSize: 14),),
                        onTap: () => this._showChangeDialog("Change email", "Enter your email", null),
                      ),
                    ),

                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          width: 0.7,
                          color: mainDarkBlue.withAlpha(204)
                        ))
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text ('Password', style: new TextStyle(fontSize: 16)),
                        subtitle: Text('Change your password', style: new TextStyle(fontSize: 14),),
                        onTap: () => this._showChangeDialog("Change password", "Enter new password", "Confirm password"),
                      ),
                    ),

                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          width: 0.7,
                          color: mainDarkBlue.withAlpha(204)
                        ))
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text ('Member Since', style: new TextStyle(fontSize: 16)),
                        subtitle: Text(DateFormat ().format(DateTime.now()), style: new TextStyle(fontSize: 14),),
                      ),
                    ),

                    new SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text ('Danger Zone', style: new TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          width: 0.7,
                        ))
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        leading: Icon(Icons.exit_to_app, color: Colors.black87,),
                        title: Text ('Logout', style: new TextStyle(fontSize: 16)),
                        onTap: () => this._showConfirmDialog('Are you sure you want to logout?', true)
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          width: 0.7,
                          color: Colors.red.withAlpha(204)
                        ))
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        leading: Icon(Icons.report_problem, color: Colors.red),
                        title: Text ('Delete account', style: new TextStyle(fontSize: 16, color: Colors.red)),
                        subtitle: const Text('Deleting your account is permanent. All your data will be wiped out immediately and you won\'t be able to get it back.'),
                        onTap: () => this._showConfirmDialog('Are you sure you want to delete your account?', false)
                      ),
                    ),

                    new SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),

        this._loading ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withAlpha(128),
          child: Center(
            child:  new CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: new AlwaysStoppedAnimation<Color>(mainBlue),
            ),
          ),
        ) : Container()
      ],
    );
  }

}

class _ChangeValue extends StatefulWidget {

  final String title;
  final String placeholder;
  final String secondPlaceholder;

  _ChangeValue({
    @required this.title,
    @required this.placeholder,
    @required this.secondPlaceholder
  });

  @override
  _ChangeValueState createState() => _ChangeValueState();

}

class _ChangeValueState extends State <_ChangeValue> {

  final _textTaskControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _textTaskControler.clear();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: mainDarkBlue),
            )
          ),

          const SizedBox(height: 24),

          CustomTextField(labelText: widget.placeholder, controller: _textTaskControler),
          
          const SizedBox(height: 24),

          widget.secondPlaceholder != null ? CustomTextField(labelText: widget.secondPlaceholder, controller: _textTaskControler) : Container (),

          SizedBox(height: widget.secondPlaceholder != null ? 24 : 0),

          CustomModalActionButton(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSave: () {
              // if (_textTaskControler.text == "") {
              //   print("data not found");
              // } else {
              //   provider
              //       .insertTodoEntries(new TodoData(
              //           date: _selectedDate,
              //           time: DateTime.now(),
              //           isFinish: false,
              //           task: _textTaskControler.text,
              //           description: "",
              //           todoType: TodoType.TYPE_TASK.index,
              //           id: null))
              //       .whenComplete(() => Navigator.of(context).pop());
              // }
            },
          )
        ],
      ),
    );
  }
}