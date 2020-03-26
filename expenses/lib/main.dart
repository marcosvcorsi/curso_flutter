import 'dart:io';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:intl/date_symbol_data_local.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  _openTransacationFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  _addTransaction(String title, double value, DateTime dateTime) {
    final transaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: dateTime,
    );

    setState(() {
      _transactions.add(transaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Confirma exclusão desta despesa?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                setState(() {
                  _transactions.removeWhere((tr) => tr.id == id);

                  Navigator.of(context).pop();
                });
              },
            ),
            FlatButton(
              child: Text('Não'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Despesas Pessoais'),
            trailing: Text('Teste'),
          )
        : AppBar(
            title: Text(
              'Despesas Pessoais',
              style: TextStyle(
                fontFamily: 'OpenSans',
              ),
            ),
            actions: <Widget>[
              if (isLandscape)
                IconButton(
                  icon: Icon(_showChart ? Icons.list : Icons.show_chart),
                  onPressed: () {
                    setState(() {
                      _showChart = !_showChart;
                    });
                  },
                ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _openTransacationFormModal(context),
              ),
            ],
            centerTitle: true,
          );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_showChart || !isLandscape)
            Container(
              height: availableHeight * (isLandscape ? 0.7 : 0.3),
              child: Chart(_recentTransactions),
            ),
          if (!_showChart || !isLandscape)
            Container(
              height: availableHeight * (isLandscape ? 0.9 : 0.7),
              child: TransactionList(_transactions, _deleteTransaction),
            ),
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isAndroid
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openTransacationFormModal(context),
                  )
                : null,
          );
  }
}
