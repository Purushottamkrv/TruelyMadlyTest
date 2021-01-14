//
//  ContactListModel.swift
//  iOS Contact List
//
//  Created by Purushottam on 14/01/21.
//  Copyright © 2021 Purushottam. All rights reserved.
//

import Foundation

struct ContactStructmodel {
    var alphaBateType : String
    var contactList :[ContactData]
}

struct ContactData {
    var image: Data
    var name : String
    var contact: String
    var email: String
    var contactId: String
}
