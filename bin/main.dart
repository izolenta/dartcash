import 'package:crypto/crypto.dart';
import 'package:dartcash/block/block.dart';
import 'package:dartcash/block/transaction.dart';
import 'package:dartcash/block/transaction_output.dart';
import 'package:dartcash/block/transaction_quant.dart';
import 'package:dartcash/infrastructure/dart_cash_address.dart';

main(List<String> arguments) {
  final one = new DartCashAddress.createNew();
  final two = new DartCashAddress.createNew();
  final output = new TransactionOutput(two, 100, 2);
  final quant = new TransactionQuant(one, [output]);
  final transaction = new Transaction("123", [quant]);

  final timestamp = new DateTime.now().toUtc().millisecondsSinceEpoch;
  for (int i=0; i<65536*65536; i++) {
    final block = new Block(0, '0', '1', timestamp, i, [transaction]);
    final hash = sha256.convert(block.getHashableContent().codeUnits);
    if (hash.bytes[0] | hash.bytes[1] == 0) {
      print ("found $hash");
      print(block.getHashableContent());
    }
  }
}
