//
//  QKMRZScanResult.swift
//  QKMRZScanner
//
//  Created by Matej Dorcak on 16/10/2018.
//

import Foundation
import UIKit

public class QKMRZScanResult {
    public let documentImage: UIImage
    public let documentType: String
    public let countryCode: String
    public let surnames: String
    public let givenNames: String
    public let documentNumber: String
    public let nationality: String
    public var birthDate: Date?
    public var sex: String?
    public var expiryDate: Date?
    public let personalNumber: String
    public let personalNumber2: String?

    init(mrzResult: QKMRZResult, documentImage image: UIImage) {
        documentImage = image
        documentType = mrzResult.documentType
        countryCode = mrzResult.countryCode
        surnames = mrzResult.surnames
        givenNames = mrzResult.givenNames
        documentNumber = mrzResult.documentNumber
        nationality = mrzResult.nationality
        birthDate = mrzResult.birthDate
        sex = mrzResult.sex
        expiryDate = mrzResult.expiryDate
        personalNumber = mrzResult.personalNumber
        personalNumber2 = mrzResult.personalNumber2
    }

    init() {
        documentImage = UIImage(named: "alertIcon")!
        documentType = ""
        countryCode = ""
        surnames = ""
        givenNames = ""
        documentNumber = ""
        nationality = ""
        sex = ""
        personalNumber = ""
        personalNumber2 = ""
    }
}
