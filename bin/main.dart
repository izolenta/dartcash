import 'package:dartcash/block/transaction.dart';
import 'package:dartcash/block/transaction_output.dart';
import 'package:dartcash/block/transaction_quant.dart';
import 'package:dartcash/infrastructure/dart_cash_address.dart';
import 'package:dartson/dartson.dart';

main(List<String> arguments) {
  final one = new DartCashAddress.createNew();
  final two = new DartCashAddress.createNew();
  final output = new TransactionOutput(two, 100, 2);
  final quant = new TransactionQuant(one, [output]);
  final transaction = new Transaction("123", [quant]);
  var dson = new Dartson.JSON();
  print(dson.encode(transaction));
}
