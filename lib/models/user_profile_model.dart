class UserProfileModel {
  bool success;
  String message;
  Data data;

  UserProfileModel({this.data, this.message, this.success});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool;
    message = json['message'] as String;
    data = json['data'] != null
        ? Data.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id, totalFunds;
  String firstName, lastName, email, phoneNo, pic, addr, status;
  List<BankDetails> bankDetails;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNo,
      this.pic,
      this.addr,
      this.status,
      this.totalFunds,
      this.bankDetails});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    firstName = json['first_name'] as String;
    lastName = json['last_name'] as String;
    email = json['email'] as String;
    phoneNo = json['phone_no'] as String;
    pic = json['pic'] as String;
    addr = json['addr'] as String;
    status = json['status'] as String;
    totalFunds = json['total_funds'] as int;
    if (json['bankDetails'] != null) {
      bankDetails = <BankDetails>[];
      json['bankDetails'].forEach((v) {
        bankDetails.add(BankDetails.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_no'] = phoneNo;
    data['addr'] = addr;
    data['status'] = status;
    data['total_funds'] = totalFunds;
    if (bankDetails != null) {
      data['bankDetails'] = bankDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankDetails {
  String bankName, branch, iban;
  int accNo;

  BankDetails({this.bankName, this.accNo, this.branch, this.iban});

  BankDetails.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'] as String;
    accNo = json['acc_no'] as int;
    branch = json['branch'] as String;
    iban = json['iban'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['bank_name'] = bankName;
    data['acc_no'] = accNo;
    data['branch'] = branch;
    data['iban'] = iban;
    return data;
  }
}
