import 'package:dartson/dartson.dart';
import 'package:dartcash/block/transaction_quant.dart';

@Entity()
class Transaction {

  @Property()
  final String hash;

  @Property()
  final List<TransactionQuant> quants;

  Transaction(this.hash, this.quants);
}