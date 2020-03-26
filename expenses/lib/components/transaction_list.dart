import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onDelete;

  TransactionList(this.transactions, this.onDelete);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Nenhuma Despesa Cadastrada',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];

              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: FittedBox(
                      child: Text('R\$ ${tr.value}'),
                    ),
                  ),
                ),
                title: Text(
                  tr.title,
                  style: Theme.of(context).textTheme.title,
                ),
                subtitle: Text(DateFormat('d MMM y').format(tr.date)),
                trailing: MediaQuery.of(context).size.width > 400
                    ? FlatButton.icon(
                        onPressed: () => onDelete(tr.id),
                        icon: Icon(Icons.delete),
                        label: Text('Excluir'),
                        textColor: Theme.of(context).errorColor,
                      )
                    : IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => onDelete(tr.id),
                        color: Theme.of(context).errorColor,
                      ),
              );
            },
          );
  }
}
