//
//  Extensions.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/20/24.
//

import Foundation


extension String{
    func capiatalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    func capitalizeEveryWord() ->String{
        let words = self.components(separatedBy: " ")
        var result = ""
        for word in words {
            if word.lowercased() == "tv"{
                result.append("TV ")
            }else{
                let capitalWord = word.capiatalizeFirstLetter()
                result.append(capitalWord+" ")
            }
        }
        return result.trimmingCharacters(in: .whitespaces)
    }
}
