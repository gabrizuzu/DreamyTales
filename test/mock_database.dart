import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';


class TestUtils {
  static bool _isDatabaseSet = false;
  static final FakeFirebaseFirestore _fakeFirebaseFirestore =
  FakeFirebaseFirestore();



  static Future<void> clearDatabase() {
    return _fakeFirebaseFirestore.clearPersistence();
  }

  /// create an instance of a mock database with pre-filled data and returns the FakeFirebaseFirestore instance
  static FirebaseFirestore createMockDatabase() {
    if (_isDatabaseSet) return _fakeFirebaseFirestore;
    _isDatabaseSet = true;

    // the logged in user
    final user1 = {
      "databaseId": 'user1_id',
      "createdAt": 1625751035020,
      "displayName": "John Doe",
      "email": "john@doe.com",
      "firstName": "John",
      "friends": <String, bool>{
        "user2_id": true,
        "user3_id": true,
        // this bad friend is here just to test for error checking:
        "johndoe2": true,
      },
      "isNew": false,
      "lastName": "Doe",
      "notificationTokens": [],
      "phoneNumber": null,
      "profilePictureURL": null,
      "username": "johndoe1",
    };

    final user2 = {
      "databaseId": 'user2_id',
      "createdAt": 1625751035020,
      "displayName": "John Doe",
      "email": "john@doe.com",
      "firstName": "John",
      "friends": <String, bool>{
        "user1_id": true,
      },
      "isNew": false,
      "lastName": "DoeSecond",
      "notificationTokens": [],
      "phoneNumber": null,
      "profilePictureURL": null,
      "username": "johndoe2",
    };
    // add a new user to be added as friend
    final user3 = {
      "databaseId": 'user3_id',
      "createdAt": 1625751035020,
      "displayName": "John DoeFriend",
      "email": "john@friend.com",
      "firstName": "John",
      "friends": <String, bool>{},
      "isNew": false,
      "lastName": "DoeFriend",
      "notificationTokens": [],
      "phoneNumber": null,
      "profilePictureURL": null,
      "username": "johndoe3",
    };

    final user4 = {
      "databaseId": 'user4_id',
      "createdAt": 1625751035020,
      "displayName": "John DoeFriend4",
      "email": "john@friend.com",
      "firstName": "John",
      "friends": <String, bool>{},
      "isNew": false,
      "lastName": "DoeFriend4",
      "notificationTokens": [],
      "phoneNumber": null,
      "profilePictureURL": null,
      "username": "johndoe4",
    };

    final user5 = {
      "databaseId": 'user5_id',
      "createdAt": 1625751035020,
      "displayName": "John DoeFriend5",
      "email": "john@friend.com",
      "firstName": "John",
      "friends": <String, bool>{},
      "isNew": false,
      "lastName": "DoeFriend5",
      "notificationTokens": [],
      "phoneNumber": null,
      "profilePictureURL": null,
      "username": "johndoe5",
    };

    final list1 = {
      "createdAt": 1626005532227,
      "creatorUid": "user1_id",
      "databaseId": "list1_id",
      "items": ["item1_id", "item2_id", "item3_id"],
      "description": "Lista numero 1",
      "expiryDate": null,
      "listType": "public",
      "members": <String, bool>{"user2_id": true},
      "name": "Nuova lista",
      "listStatus": "saved",
    };

    final list2 = {
      "createdAt": 1625160623927,
      "creatorUid": "user2_id",
      "databaseId": "list2_id",
      "items": ["item2_id"],
      "description": "Lista numero 2",
      "expiryDate": null,
      "listType": "public",
      "members": <String, bool>{"user1_id": true},
      "name": "Famiglia",
      "listStatus": "saved",
    };

    final list3 = {
      "createdAt": 1625160623929,
      "creatorUid": "user1_id",
      "databaseId": "list3_id",
      "items": ["item1_id"],
      "description": "Lista numero 3",
      "expiryDate": null,
      "listType": "private",
      "members": <String, bool>{"user2_id": true},
      "name": "Regali",
      "listStatus": "saved",
    };

    final list4 = {
      "createdAt": 1625160623929,
      "creatorUid": "user2_id",
      "databaseId": "list4_id",
      "items": ["item1_id"],
      "description": "Lista numero 4",
      "expiryDate": null,
      "listType": "private",
      "members": <String, bool>{"user1_id": true},
      "name": "Natale",
      "listStatus": "saved",
    };

    //list to test save list from draft
    final list5 = {
      "createdAt": 1625160623929,
      "creatorUid": "user1_id",
      "databaseId": "list5_id",
      "items": ["item1_id"],
      "description": "Lista numero 5",
      "expiryDate": null,
      "listType": "private",
      "members": <String, bool>{},
      "name": "Natale",
      "listStatus": "draft",
    };

    final item1 = {
      "createdAt": 1625838181902,
      "creatorUid": "user1_id",
      "databaseId": "item1_id",
      "description": "item1 description",
      "itemType": "simple",
      "maxQuantity": 1,
      "name": "prova",
      "quantityPerMember": 1,
    };

    final item2 = {
      "createdAt": 1625838181903,
      "creatorUid": "user2_id",
      "databaseId": "item2_id",
      "description": "item2 description",
      "itemType": "multiFulfillment",
      "maxQuantity": 3,
      "name": "multiFulfillment",
      "quantityPerMember": 1,
    };

    final item3 = {
      "createdAt": 1625838181903,
      "creatorUid": "user2_id",
      "databaseId": "item3_id",
      "description": "item3 description",
      "itemType": "multiFulfillmentMember",
      "maxQuantity": 6,
      "name": "multiFulfillmentMember",
      "quantityPerMember": 5,
      "usersCompletions": <String, int>{}
    };

    final item4 = {
      "createdAt": 1625838181903,
      "creatorUid": "user1_id",
      "databaseId": "item4_id",
      "description": "item4 description",
      "itemType": "multiFulfillment",
      "maxQuantity": 3,
      "name": "multiFulfillment1",
      "quantityPerMember": 1,
    };

    final item5 = {
      "createdAt": 1625838181903,
      "creatorUid": "user1_id",
      "databaseId": "item5_id",
      "description": "item5 description",
      "itemType": "multiFulfillmentMember",
      "maxQuantity": 6,
      "name": "multiFulfillmentMember1",
      "quantityPerMember": 2,
      "usersCompletions": <String, int>{}
    };

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .set(user1);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user2["databaseId"] as String)
        .set(user2);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user3["databaseId"] as String)
        .set(user3);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user4["databaseId"] as String)
        .set(user4);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user5["databaseId"] as String)
        .set(user5);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .collection('lists')
        .doc(list1['databaseId'] as String)
      ..set(list1)
      ..collection('items').doc(item1["databaseId"] as String).set(item1);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .collection('lists')
        .doc(list1['databaseId'] as String)
      ..set(list1)
      ..collection('items').doc(item3["databaseId"] as String).set(item3);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .collection('lists')
        .doc(list1['databaseId'] as String)
      ..set(list1)
      ..collection('items').doc(item4["databaseId"] as String).set(item4);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .collection('lists')
        .doc(list1['databaseId'] as String)
      ..set(list1)
      ..collection('items').doc(item5["databaseId"] as String).set(item5);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user2["databaseId"] as String)
        .collection('lists')
        .doc(list2['databaseId'] as String)
      ..set(list2)
      ..collection('items').doc(item2["databaseId"] as String).set(item2);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .collection('lists')
        .doc(list3['databaseId'] as String)
      ..set(list3)
      ..collection('items').doc(item1["databaseId"] as String).set(item1);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user2["databaseId"] as String)
        .collection('lists')
        .doc(list4['databaseId'] as String)
      ..set(list4)
      ..collection('items').doc(item2["databaseId"] as String).set(item2);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .collection('lists')
        .doc(list5['databaseId'] as String)
      ..set(list5)
      ..collection('items').doc(item1["databaseId"] as String).set(item1);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user2["databaseId"] as String)
        .collection('lists')
        .doc(list2['databaseId'] as String)
        .set(list2);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .collection('lists')
        .doc(list3['databaseId'] as String)
        .set(list3);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user2["databaseId"] as String)
        .collection('lists')
        .doc(list4['databaseId'] as String)
        .set(list4);

    _fakeFirebaseFirestore
        .collection('users')
        .doc(user1["databaseId"] as String)
        .collection('lists')
        .doc(list5['databaseId'] as String)
        .set(list5);

    return _fakeFirebaseFirestore;
  }
}