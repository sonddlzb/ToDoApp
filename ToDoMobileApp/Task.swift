//
//  Task.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 08/04/2022.
//

import Foundation
class Task
{
    @objc dynamic var listName = ""
    @objc dynamic var taskID = NSUUID().uuidString
    @objc dynamic var  detail: String
    @objc dynamic var  isFinished: Bool = false
    @objc dynamic var  isInterested: Bool = false
    @objc dynamic var timeCreate: Date
    init(detail: String, taskType: TaskType, timeCreate: Date)
    {
        self.detail = detail
        self.taskType = taskType
        self.timeCreate = timeCreate
    }
    var taskType: TaskType
}
enum TaskType
{
    case myDay
    case planned
    case important
    case normal
    case listed
}
