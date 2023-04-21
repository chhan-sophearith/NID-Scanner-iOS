//
//  String-Ext.swift
//  QKMRZParser
//
//  Created by Matej Dorcak on 14/10/2018.
//

import Foundation

// MARK: Parser related
extension String {
    func trimmingFillers() -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: "<"))
    }

    func trimCharacter() -> String {
        return self.filter("0123456789.".contains)
    }
}

// MARK: Generic
extension String {
    func substring(_ from: Int, to: Int) -> String {
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(startIndex, offsetBy: to + 1)
        return String(self[fromIndex..<toIndex])
    }

    var replaceStringWithEmpty: String {
        var newSelf = self
        let index = newSelf.index(newSelf.startIndex, offsetBy: 0)
        newSelf.replaceSubrange(index...index, with: "")
        return newSelf
    }
}

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String? {
        return self.removingPercentEncoding?.replace("+", with: " ")
    }

}

// Phone Format
extension String {
    func validatedPhoneZero() -> String {
        var phone = ""
        if self.prefix(3) == "855" {
            if self.dropFirst(3).prefix(1) == "0" {
                phone = String(self.dropFirst(3) )
            } else {
                phone = "0" + String(self.dropFirst(3) )
            }
        } else {
            if self.prefix(1) == "0" {
                phone = String(self )
            } else {
                phone = "0" + String(self )
            }
        }
        return phone
    }
}

// MARK: - Date format
extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd - MMM - yyyy"
        return dateFormatter.date(from: self)
    }
}
