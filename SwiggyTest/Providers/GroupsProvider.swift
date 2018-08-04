//
//  CategoryProvider.swift
//  SwiggyTest
//
//  Created by Ganesh Patro on 8/3/18.
//  Copyright © 2018 Ganesh Patro. All rights reserved.
//

import UIKit

enum AppURL: String {
    case GROUPS = "http://api.myjson.com/bins/3b0u2"
}

enum GroupsResult<T> {
    case success(T)
    case error(Error)
}

typealias CategoriesCallback = (_ groupsResult: GroupsResult<GroupsAPIResponse>) -> Void

class GroupsProvider: NSObject {

    static func getAllGroups(withGroupResult callback:@escaping (CategoriesCallback)) {
        NetworkRequestManager.sharedManager.sendGETRequest(AppURL.GROUPS.rawValue) { (result) in
            switch (result) {
            case .success(let dataResponnse):
                //Handle the response and do the parsing
                do {
                    let searchResultDict = try JSONSerialization.jsonObject(with: dataResponnse, options: JSONSerialization.ReadingOptions.allowFragments);
                callback(GroupsResult<GroupsAPIResponse>.success(GroupParser.parseGroupAPIResponse(searchResultDict as! JSONObject)))
                } catch(let error) {
                    print("Error in serializing - \(error)")
                    callback(GroupsResult.error(error))
                }
            case .failue(let error):
                callback(GroupsResult.error(error))
            }
        }
    }
}
