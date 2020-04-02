import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/auth.dart';

import 'package:pocket/models/http_exception.dart';

import 'package:pocket/animations/fade.dart';
import 'package:pocket/widgets/bottom.dart';
import 'package:pocket/style/colors.dart';

import 'package:pocket/version.dart';

class AuthScreen extends StatefulWidget {

  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState ();

}

class _AuthScreenState extends State <AuthScreen> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  Map <String, String> _authData = {
    // 'username': '',
    'email': '',
    'password': '',
  };

  final FocusNode _passwordFocusNode = new FocusNode ();

  bool _signinLoading = false;

  @override
  void dispose()  {
    this._passwordFocusNode.dispose();

    super.dispose();
  }

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

  Future <void> _submitLogin() async {

    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      
      try {
        this.setState(() => this._signinLoading = true);
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } on HttpException catch (error) {
        var jsonError = json.decode(error.toString());

        String actualError;
        if (jsonError['email'] != null) actualError = jsonError['email'];
        else if (jsonError['username'] != null) actualError = jsonError['username'];
        else if (jsonError['password'] != null) actualError = jsonError['password'];

        // print(actualError);

        _showErrorDialog(actualError);
      }

      catch (error) {
        _showErrorDialog('Failed to authenticate!');
      }

      finally {
        this.setState(() => this._signinLoading = false);
      }
    }
  }

  Widget _forgot() {
    return Center(
      child: RawMaterialButton(
        onPressed: () => showModalBottomSheetApp(
          isDismissible: true,
          context: context, 
          builder: (bCtx) => new _ForgotPassword(),
          // isScrollControlled: true,
          // isDismissible: false,
        ),
        elevation: 0,
        textStyle: TextStyle(
          color: Color.fromRGBO(25, 42, 86, 0.6),
          fontSize: 16
        ),
        child: Text(
          "Forgot Password?"
        )
      ),
    );
  }

  Widget _create() {
    return new Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: mainDarkBlue
      ),
      child: Center(
        child: RawMaterialButton(
          onPressed: () => showModalBottomSheetApp(
            isDismissible: true,
            context: context, 
            builder: (bCtx) => new _CreateAccount(),
            // isScrollControlled: true,
            // isDismissible: false,
          ),
          elevation: 0,
          textStyle: TextStyle(
            color: Colors.white,
            // fontSize: 18,
            fontWeight: FontWeight.w800
          ),
          child: Text("Create Account"),
        ),
      ),
    );
  }

  void _info() {
    showModalBottomSheet(
      context: context, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0)
        ),
      ),
      builder: (bCtx) => new Container (
        height: MediaQuery.of(context).size.height * 0.2,
        padding: EdgeInsets.all(16),
        child: new Center(
          child: new Column(
            children: <Widget>[
              Text(
                'Tiny Pocket Mobile App',
                style: new TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: mainBlue),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                'Version $version_number -- $version_date',
                style: new TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),

              Spacer(),

              Text(
                'Created by Ermiry',
                style: new TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5)
            ],
          )
        )
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    var maxHeight = MediaQuery.of(context).size.height;
    // print(maxHeight);

    return new Scaffold(
      backgroundColor: mainBlue,
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              /*** title ***/
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                      FadeAnimation(1, -30, 0, Text(
                        "Login", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 64, 
                          fontWeight: FontWeight.bold
                        )
                      )),

                      SizedBox(height: 10,),

                      FadeAnimation(1.3, -30, 0, Text(
                        "Welcome Back!", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 24
                        )
                      )),
                    ],
                  ),
                ),
              ),

              new Stack(
                children: <Widget>[
                  // background
                  new Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                    ),
                  ),

                  new Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: maxHeight >= 900 ? 60 : 20),

                        // login input
                        FadeAnimation(1.4, -30, 0, Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: const Color.fromRGBO(25, 42, 86, 0.5),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),
                          child: new Form(
                            key: this._formKey,
                            child: new Column(
                              children: <Widget>[
                                // email input
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]
                                    ))
                                  ),

                                  child: new TextFormField(
                                    enabled: this._signinLoading ? false : true,
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: const TextStyle(color: Colors.grey)
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isEmpty) return 'Email field is required!';
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).requestFocus(
                                        this._passwordFocusNode
                                      );
                                    },
                                    onSaved: (value) {
                                      this._authData['email'] = value;
                                    },
                                  ),
                                ),

                                // password input
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: new TextFormField(
                                    enabled: this._signinLoading ? false : true,
                                    autofocus: false,
                                    focusNode: this._passwordFocusNode,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: const TextStyle(color: Colors.grey)
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value.isEmpty) return 'Password field is required!';
                                      else if (value.length < 5) return 'Password is too short!';
                                      else if (value.length > 64) return 'Password is too long!';
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    onSaved: (value) {
                                      this._authData['password'] = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        )),

                        SizedBox(height: maxHeight >= 900 ? 30 : 15),

                        FadeAnimation(1.5, -30, 0, this._forgot()),

                        SizedBox(height: maxHeight >= 900 ? 30 : 15),

                        // login button
                        FadeAnimation(1.6, -30, 0, new Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: mainBlue
                          ),
                          child: Center(
                            child: RawMaterialButton(
                              onPressed: this._signinLoading ? null : () => this._submitLogin(),
                              elevation: 0,
                              textStyle: TextStyle(
                                color: Colors.white,
                                // fontSize: 18,
                                fontWeight: FontWeight.w800
                              ),
                              // ,
                              child: this._signinLoading ? new CircularProgressIndicator(
                                // backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                              ) :
                              Text("Login!")
                              ,
                            ),
                          ),
                        )),

                        SizedBox(height: maxHeight >= 900 ? 30 : 15),

                        FadeAnimation(1.8, -30, 0, Text("or", style: TextStyle(color: Colors.grey),)),

                        SizedBox(height: maxHeight >= 900 ? 30 : 15),

                        // create account button
                        FadeAnimation(2.0, -30, 0, this._create()),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),

          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.02,
            left: MediaQuery.of(context).size.width * 0.85,
            child: Container(
              // decoration: ShapeDecoration(
              //   shape: CircleBorder (),
              //   color: Colors.white
              // ),
              child: IconButton(
                color: mainBlue,
                icon: Icon(Icons.info),
                onPressed: () => this._info(),
                iconSize: 36
              )
            ),
          )
        ],
      )
    );
  }

}

class _CreateAccount extends StatefulWidget {

  @override
  _CreateAccountState createState() => new _CreateAccountState ();

}

class _CreateAccountState extends State <_CreateAccount> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  final Map <String, String> _authData = {
    'name': '',
    'username': '',
    'email': '',
    'password': '',
    'password2': '',
  };

  final FocusNode _usernameFocusNode = new FocusNode ();
  final FocusNode _emailFocusNode = new FocusNode ();
  final FocusNode _passwordFocusNode = new FocusNode ();
  final FocusNode _confirmFocusNode = new FocusNode ();

  final TextEditingController _nameController = new TextEditingController ();
  final TextEditingController _usernameController = new TextEditingController ();
  final TextEditingController _emailController = new TextEditingController ();
  final TextEditingController _passwordController = new TextEditingController ();
  final TextEditingController _confirmController = new TextEditingController ();

  bool _createLoading = false;

  @override
  void dispose()  {
    // 13/02/2020 -- caused error when closing modal bottom sheet
    // _usernameFocusNode.dispose();
    // _emailFocusNode.dispose();
    // _passwordFocusNode.dispose();
    // _confirmFocusNode.dispose();

    // this._nameController.dispose();
    // this._usernameController.dispose();
    // this._emailController.dispose();
    // this._passwordController.dispose();
    // this._confirmController.dispose();

    super.dispose();
  }

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
            child: Text ('Okay', style: const TextStyle(color: mainDarkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Success!', 
          style: const TextStyle(color: mainBlue, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Text (
          message,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainDarkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  Future <void> _submitRegister() async {
    bool fail = false;
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      
      try {
        setState(() => this._createLoading = true);
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['name'],
          _authData['username'],
          _authData['email'],
          _authData['password'],
          _authData['password2']
        );
        fail = false;
      } on HttpException catch (error) {
        var jsonError = json.decode(error.toString());

        String actualError;
        if (jsonError['email'] != null) actualError = jsonError['email'];
        else if (jsonError['username'] != null) actualError = jsonError['username'];
        else if (jsonError['password'] != null) actualError = jsonError['password'];

        // print(actualError);

        _showErrorDialog(actualError);
        fail = true;
      }

      catch (error) {
        _showErrorDialog('Failed to create new account!');
        fail = true;
      }

      finally {
        setState(() => this._createLoading = false);
      }

      if (!fail) {
        _showSuccessDialog("Created new account! Now login.");

        // clear input texts
        this._nameController.clear();
        this._usernameController.clear();
        this._emailController.clear();
        this._passwordController.clear();
        this._confirmController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),

      child: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          
          Center(
            child: Text(
              "Create your free account!", 
              style: TextStyle(
                color: mainBlue, 
                fontWeight: FontWeight.bold, fontSize: 20
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: new Form(
              key: this._formKey,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(25, 42, 86, 0.5),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ]
                ),
                child: Column(
                  children: <Widget>[
                    // name input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: new BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: Colors.grey[200]
                        ))
                      ),
                      child: new TextFormField(
                        autofocus: false,
                        enabled: this._createLoading ? false : true,
                        controller: this._nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                          hintStyle: const TextStyle(color: Colors.grey)
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) return 'Name field is required!';
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(
                            this._usernameFocusNode
                          );
                        },
                        onSaved: (value) {
                          this._authData['name'] = value;
                        },
                      ),
                    ),

                    // username input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: new BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: Colors.grey[200]
                        ))
                      ),
                      child: new TextFormField(
                        autofocus: false,
                        enabled: this._createLoading ? false : true,
                        controller: this._usernameController,
                        focusNode: this._usernameFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Username",
                          hintStyle: const TextStyle(color: Colors.grey)
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) return 'Username field is required!';
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(
                            this._emailFocusNode
                          );
                        },
                        onSaved: (value) {
                          _authData['username'] = value;
                        },
                      ),
                    ),

                    // email input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: new BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: Colors.grey[200]
                        ))
                      ),
                      child: new TextFormField(
                        autofocus: false,
                        enabled: this._createLoading ? false : true,
                        controller: this._emailController,
                        focusNode: this._emailFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: const TextStyle(color: Colors.grey)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) return 'Email field is required!';
                          else if (!value.contains('@')) return 'Invalid email!';
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(
                            this._passwordFocusNode
                          );
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                    ),

                    // password input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: Colors.grey[200]
                        ))
                      ),
                      child: new TextFormField(
                        autofocus: false,
                        enabled: this._createLoading ? false : true,
                        controller: this._passwordController,
                        focusNode: this._passwordFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.grey)
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) return 'Password field is required!';
                          else if (value.length < 5) return 'Password is too short!';
                          else if (value.length > 64) return 'Password is too long!';
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(
                            this._confirmFocusNode
                          );
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                      ),
                    ),

                    // confirm password input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: new TextFormField(
                        autofocus: false,
                        enabled: this._createLoading ? false : true,
                        controller: this._confirmController,
                        focusNode: this._confirmFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Confirm Password",
                          hintStyle: const TextStyle(color: Colors.grey)
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) return 'Confirm password field is required!';
                          if (value != this._passwordController.text) return 'Passwords do not match!';
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onSaved: (value) {
                          _authData['password2'] = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // signup button
          new Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: mainBlue
            ),
            child: Center(
              child: RawMaterialButton(
                onPressed: this._createLoading ? null : () => _submitRegister(),
                elevation: 0,
                textStyle: TextStyle(
                  color: Colors.white,
                  // fontSize: 18,
                  fontWeight: FontWeight.w800
                ),
                child: this._createLoading ? new CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(mainDarkBlue),
                ) :
                Text("Signup!")
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      )
    );
  }

}

class _ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState ();

}

class _ForgotPasswordState extends State <_ForgotPassword> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  Map <String, String> _authData = {
    'email': '',
  };

  final TextEditingController _emailController = new TextEditingController ();

  bool _recoverLoading = false;

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
            child: Text ('Okay', style: const TextStyle(color: mainDarkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Success!', 
          style: const TextStyle(color: mainBlue, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Text (
          message,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainDarkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  Future <void> _submitRecover() async {
    bool fail = false;
    
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      
      try {
        setState(() => this._recoverLoading = true);
        await Provider.of<Auth>(context, listen: false).recover(this._authData['email']);
      }

      catch (error) {
        _showErrorDialog('Failed to manage account recovery!');
        fail = true;
      }

      finally {
        setState(() => this._recoverLoading = false);
      }

      if (!fail) {
        this._emailController.clear();
        _showSuccessDialog('Check your mailbox for recovery instructions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: new ListView(
        children: <Widget>[
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                "Enter the email address associated with your account", 
                style: TextStyle(
                  color: mainBlue, 
                  fontWeight: FontWeight.bold, fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(25, 42, 86, 0.5),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  new Form(
                    key: this._formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: new TextFormField(
                        enabled: this._recoverLoading ? false : true,
                        autofocus: false,
                        controller: this._emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: const TextStyle(color: Colors.grey)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) return 'Email field is required!';
                          else if (!value.contains('@')) return 'Invalid email!';
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          // nothing here
                        },
                        onSaved: (value) {
                          this._authData['email'] = value;
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height >= 900 ? 60 : 30),

          // recover button
          new Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: mainBlue
            ),
            child: Center(
              child: RawMaterialButton(
                onPressed: this._recoverLoading ? null : () => _submitRecover(),
                elevation: 0,
                textStyle: TextStyle(
                  color: Colors.white,
                  // fontSize: 18,
                  fontWeight: FontWeight.w800
                ),
                child: this._recoverLoading ? new CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(mainDarkBlue),
                ) :
                Text("Recover Account!")
              ),
            ),
          )
        ],
      )
    );
  }

}