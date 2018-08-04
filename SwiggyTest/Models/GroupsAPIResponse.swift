//
//  CategoriesAPIResponse.swift
//  SwiggyTest
//
//  Created by Ganesh Patro on 8/3/18.
//  Copyright © 2018 Ganesh Patro. All rights reserved.
//

import UIKit

struct ExclusionModel {
    let group_id: String
    let variantion_id: String
}

struct ExcludeList {
    let arrExclusions: [ExclusionModel]
}

struct GroupsAPIResponse {
    let arrGroups: [Group]
    let arrExludeList: [ExcludeList]
}
