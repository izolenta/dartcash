import 'package:dartcash/infrastructure/dart_cash_address.dart';
import 'package:dartson/dartson.dart';

@Entity()
class TransactionOutput {

  @Property()
  String get to => address.toString();

  @Property()
  final int amount;

  @Property()
  final int commission;

  @Property(ignore: true)
  final DartCashAddress address;

  TransactionOutput(this.address, this.amount, this.commission);
}