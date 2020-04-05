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

  String title;
  String placeholder;
  String secondPlaceholder;

  final _mainTextControler = new TextEditingController();
  final _subTextControler = new TextEditingController();

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
  void _showConfirmDialog(String message, bool logout, Future <void> callback ()) {
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
                await callback();
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
    this._mainTextControler.clear();
    this._subTextControler.clear();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: mainDarkBlue),
                  )
                ),

                const SizedBox(height: 24),

                CustomTextField(labelText: placeholder, controller: _mainTextControler),
                
                const SizedBox(height: 24),

                secondPlaceholder != null ? CustomTextField(labelText: secondPlaceholder, controller: _subTextControler) : Container (),

                SizedBox(height: secondPlaceholder != null ? 24 : 0),

                CustomModalActionButton(
                  onClose: () {
                    Navigator.of(context).pop();
                  },
                  onSave: () async {
                    setState(() => this._loading = true);

                    Navigator.of(context).pop();

                    try {
                      // check for empty
                      if (this._mainTextControler.text != "") {
                        Provider.of<Auth>(context, listen: false).editName(this._mainTextControler.text);
                      }
                    }

                    catch (err) {
                      this._showErrorDialog('Failed to delete account!');
                    }

                    finally { setState(() => this._loading = false); }

                    
                  },
                )
              ],
            ),
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
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),

              Center(
                child: Text(
                  "Account",
                  style: const TextStyle(
                    fontSize: 24,
                    color: mainBlue,
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              Consumer <Auth> (
                builder: (ctx, auth, _) => new Container(
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
                          subtitle: Text(
                            "${auth.userValues['name']}", 
                            style: new TextStyle(fontSize: 14)
                          ),
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
                          subtitle: Text(
                            "${auth.userValues['username']}", 
                            style: new TextStyle(fontSize: 14),
                          ),
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
                          subtitle: Text(
                            "${auth.userValues['email']}",
                            style: new TextStyle(fontSize: 14)
                          ),
                          // onTap: () => this._showChangeDialog("Change email", "Enter your email", null),
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
                          subtitle: Text(
                            DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.parse(auth.userValues['memberSince']).toLocal()),
                            style: new TextStyle(fontSize: 14)
                          ),
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
                          onTap: () => this._showConfirmDialog(
                            'Are you sure you want to logout?', 
                            true,
                            Provider.of<Auth>(context, listen: false).logout
                          )
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
                          onTap: () => this._showConfirmDialog(
                            'Are you sure you want to delete your account?',
                            false, 
                            Provider.of<Auth>(context, listen: false).delete
                          )
                        ),
                      ),

                      new SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    ],
                  ),
                ),
              )
            ],
          ),
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

// class _ChangeValue extends StatefulWidget {

//   final String title;
//   final String placeholder;
//   final String secondPlaceholder;

//   _ChangeValue({
//     @required this.title,
//     @required this.placeholder,
//     @required this.secondPlaceholder
//   });

//   @override
//   _ChangeValueState createState() => _ChangeValueState();

// }

// class _ChangeValueState extends State <_ChangeValue> {

//   @override
//   Widget build(BuildContext context) {
    

//     return 
//   }
// }