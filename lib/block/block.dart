import 'dart:convert';
import 'package:dartcash/block/transaction.dart';
import 'package:dartson/dartson.dart';

@Entity()
class Block {

  @Property()
  final int id;

  @Property()
  int difficulty;

  @Property()
  final String prevHash;

  @Property()
  final String protocolVersion;

  @Property()
  final int timestamp;

  @Property()
  final int nonce;

  @Property()
  final List<Transaction> transactions;

  Block(this.id, this.prevHash, this.protocolVersion, this.timestamp, this.nonce, this.transactions) {
    difficulty = calculateDifficulty();
  }

  String getHashableContent() {
    var dson = new Dartson.JSON();
    return dson.encode(this);
  }

  String sealBlock(String hash) {
    var content = JSON.decode(getHashableContent()) as Map<String, Object>;
    content['hash'] = hash;
    return JSON.encode(content);
  }

  int calculateDifficulty() {
    return 10000000;
  }
}