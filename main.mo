import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

// Donation Place data structure
type DonationPlace = {
  id: Nat;
  name: Text;
  location: Text;
};

// Natural Disaster Relief Smart Contract

// User data structure
type User = {
  id: Nat;
  name: Text;
  donatedAmount: Nat;
};

// Smart contract
actor NaturalDisasterRelief {

  // List of users
  var users: [User] = [];

  // List of donation places
  var donationPlaces: [DonationPlace] = [];

  // Function to add a user
  public shared({ name }: { name: Text }) : async Nat {
    let id = Array.length(users);
    let newUser = { id = id; name = name; donatedAmount = 0 };
    users := Array.append(users, [newUser]);
    return id;
  };

  // Function to make a donation
  public shared({ userId, amount }: { userId: Nat; amount: Nat }) : async Bool {
    if (userId >= Array.length(users)) {
      return false; // Invalid user ID
    } else {
      users.[userId].donatedAmount += amount;
      return true;
    }
  };

  // Function to distribute aid
  public shared({ totalAmount }: { totalAmount: Nat }) : async Bool {
    let totalDonations = 0;
    for (user in users) {
      totalDonations += user.donatedAmount;
    }
    if (totalDonations < totalAmount) {
      return false; // Insufficient donations
    } else {
      // Distribution process is carried out, for example transferred to areas in need of assistance
      return true;
    }
  };

  // Function to get user information
  public query shared({ userId }: { userId: Nat }) : async ?User {
    if (userId >= Array.length(users)) {
      return null; // Invalid user ID
    } else {
      return users.[userId];
    }
  };

  // Function to get the total donation amount
  public query shared() : async Nat {
    let totalDonations = 0;
    for (user in users) {
      totalDonations += user.donatedAmount;
    }
    return totalDonations;
  };

  // Function to collect user IDs
  public query shared() : async [Nat] {
    var userIds: [Nat] = [];
    for (user in users) {
      userIds := Array.append(userIds, [user.id]);
    }
    return userIds;
  };

  // Function to distribute donations equally to those in need
  public shared({ needyUsers: [Nat] }) : async Bool {
    let totalDonations = await self.totalDonations();
    let donationPerUser = totalDonations / Nat.fromInt(Array.length(needyUsers));

    for (userId in needyUsers) {
      if (userId >= Array.length(users)) {
        return false; // Invalid user ID
      } else {
        users.[userId].donatedAmount += donationPerUser;
      }
    }
    return true;
  };

  // Function to add donation places
  public shared({ name, location }: { name: Text; location: Text }) : async Nat {
    let id = Array.length(donationPlaces);
    let newPlace = { id = id; name = name; location = location };
    donationPlaces := Array.append(donationPlaces, [newPlace]);
    return id;
  };

  // Function to get all donation places
  public query shared() : async [DonationPlace] {
    return donationPlaces;
  };
};