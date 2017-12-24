import 'package:dartcash/utils/crypto_utils.dart';
import 'package:dartson/dartson.dart';
import 'package:dartcash/block/transaction_quant.dart';
import 'package:pointycastle/pointycastle.dart';

@Entity()
class Transaction {

  @Property()
  final String hash;

  @Property()
  final List<TransactionQuant> quants;

  @Property()
  String signature;

  @Property()
  String pubkey;

  Transaction(this.hash, this.quants) {
    final keyPair = CryptoUtils.generateKeyPair();
    signature = CryptoUtils.signContent(_getSignableContent(), keyPair.privateKey);
    pubkey = CryptoUtils.ecPublicKeyToString(keyPair.publicKey as ECPublicKey);
  }

  String _getSignableContent() {
    final dson = new Dartson.JSON();
    return dson.encode(quants);
  }
}