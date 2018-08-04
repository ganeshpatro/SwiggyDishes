//
//  GroupParser.swift
//  SwiggyTest
//
//  Created by Ganesh Patro on 8/3/18.
//  Copyright © 2018 Ganesh Patro. All rights reserved.
//

import UIKit

typealias JSONObject = [String : Any]
typealias JSONArrayObject = [JSONObject]

class GroupParser: NSObject {

    class func parseGroupAPIResponse(_ response: JSONObject) -> GroupsAPIResponse {
        //Groups
        var arrGroups = [Group]()
        
        //Excludes
        var arrExcludes = [ExcludeList]()
        
        if let variantDict = response["variants"] as? JSONObject {
            
            if let variantGroupsDict = variantDict["variant_groups"] as? [JSONObject] {
                for variantGroupDict in variantGroupsDict {
                    arrGroups.append(self.parseGroupJsonObject(variantGroupDict))
                }
            }
            
            if let excludeGroupsArray = variantDict["exclude_list"] as? [JSONArrayObject] {
                for excludeGroupArray in excludeGroupsArray {
                    var arrExclusionModels = [ExclusionModel]()
                    for excludeGroupDict in excludeGroupArray {
                        arrExclusionModels.append(self.parseExcludeGroup(excludeGroupDict))
                    }
                    arrExcludes.append(ExcludeList(arrExclusions: arrExclusionModels))
                }
            }
        }
        return GroupsAPIResponse(arrGroups: arrGroups, arrExludeList: arrExcludes)
    }
    
    class func parseGroupJsonObject(_ groupdict: JSONObject) -> Group {
        let groupName = groupdict["name"] as! String
        let group_id = groupdict["group_id"] as! String
        
        var arrVariations = [Variant]()
        for variantdict in groupdict["variations"] as! [JSONObject] {
            arrVariations.append(self.parseVariationDict(variantdict))
        }
        
        return Group(group_id: group_id, name: groupName, variants: arrVariations)
    }
    
    class func parseVariationDict(_ variationDict: JSONObject) -> Variant {
        let name = variationDict["name"] as! String
        let price = variationDict["price"] as! Double
        let id = variationDict["id"] as! String
        let inStock = variationDict["inStock"] as! Int
        let isVeg = variationDict["isVeg"] as? Int
        
        return Variant(name: name, price: price, id: id, inStock: inStock, isVeg: isVeg)
    }
    
    class func parseExcludeGroup(_ jsonObject: JSONObject) -> ExclusionModel {
        let group_id = jsonObject["group_id"] as! String
        let variation_id = jsonObject["variation_id"] as! String
        return ExclusionModel(group_id: group_id, variantion_id: variation_id)
    }
}
