import 'package:flutter/material.dart';

import 'package:pocket/widgets/transactions/user.dart';

void main () => runApp (TinyPocket ());

class TinyPocket extends StatelessWidget {

	@override
	Widget build (BuildContext context) {

		return MaterialApp (
			title: 'Tiny Pocket',
			home: HomePage ()
		);

	}

}

class HomePage extends StatelessWidget {

	@override
	Widget build (BuildContext context) {

		return (Scaffold (
			appBar: AppBar (
				title: Text ('Tiny Pocket'),
			),
			body: SingleChildScrollView (
				child: Column (
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>[
						Card (
							color: Colors.blue, 
							child: Text ('Chart!')
							),

						UserTransactions ()
					]
				) 
			) 
		)
		);

	}

}