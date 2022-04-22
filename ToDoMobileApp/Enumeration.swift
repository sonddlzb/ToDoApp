//
//  Enumeration.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 18/04/2022.
//

import Foundation
enum DeadlineType
{
    case Today
    case Tomorrow
    case NextWeek
    case Other
    
}
enum TaskType
{
    case myDay
    case planned
    case important
    case normal
    case listed
}
enum DueType: Int
{
    case Overdue = 1
    case Today = 2
    case Tomorrow = 3
    case ThisWeek = 4
    case Later = 5
}
