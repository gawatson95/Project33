//
//  Whistle.swift
//  Project33
//
//  Created by Grant Watson on 11/9/22.
//

import CloudKit
import UIKit

class Whistle: NSObject {
    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
