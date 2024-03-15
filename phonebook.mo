// importlar

import Map "mo:base/HashMap";
import Text "mo:base/Text";

// actor --> canister --> smart contract

actor {
  // Motoko --> type language
  type Name = Text;
  type Phone = Text;

  type Entry = {
    desc: Text;
    phone: Phone;
  };

  // variable (değişkenler)
  // let --> immutable (değiştirilemez)
  // var --> mutable (değiştirilebilir)

  let phonebook = Map.HashMap<Name, Entry>(0, Text.equal, Text.hash);

  // fonksiyonlar 
  // query --> sorgulamak
  // update --> güncelleme

  public func insert(name: Name, entry: Entry) : async () {
    phonebook.put(name, entry);
  };

  public query func lookup (name: Name) : async ?Entry { // ?: ne olursan ol gel
    phonebook.get(name) // return phonebook.get(name);
  };

}