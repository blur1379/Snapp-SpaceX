//
//  AppStorage.swift
//  Snapp-SpaceX
//
//  Created by Mohammad Blur on 8/16/23.
//

import Foundation
class AppStorage {
    static let shared = AppStorage()
    let defaults = UserDefaults.standard
    private init(){}
    
    private let BOOK_MARKED_ID = "bookMarkId"
    
    private var bookMarkItems : [String] {
        get{
            return defaults.object(forKey: BOOK_MARKED_ID) as? [String] ?? []
        }
        set{
            defaults.set(newValue, forKey: BOOK_MARKED_ID)
        }
    }
    
    func addItemToBookMarks(id: String){
        if !isItemBookMarked(id: id){
            bookMarkItems.append(id)
        }
    }
    func removeItemFromBookMarks(id: String){
        if isItemBookMarked(id: id){
           
            bookMarkItems.remove(at: bookMarkItems.firstIndex{$0 == id} ?? 0)
        }
    }
    func isItemBookMarked(id: String) -> Bool {
        return bookMarkItems.contains(id)
    }
}
