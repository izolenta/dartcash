import 'package:dartcash/block/transaction_output.dart';
import 'package:dartcash/infrastructure/dart_cash_address.dart';
import 'package:dartson/dartson.dart';

@Entity()
class TransactionQuant {

  @Property()
  String get from => sender.toString();

  @Property(ignore: true)
  final DartCashAddress sender;

  @Property()
  final List<TransactionOutput> outputs;

  TransactionQuant(this.sender, this.outputs);
}