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
    @objc dynamic var timePlanned: Date
    init(detail: String, taskType: TaskType, timeCreate: Date)
    {
        self.detail = detail
        self.taskType = taskType
        self.timeCreate = timeCreate
        self.timePlanned = timeCreate
    }
    
    init(detail: String, taskType: TaskType, timeCreate: Date, timePlanned: Date)
    {
        self.detail = detail
        self.taskType = taskType
        self.timeCreate = timeCreate
        self.timePlanned = timeCreate
    }
    init(detail: String, taskType: TaskType, secondTaskType: TaskType, timeCreate: Date, timePlanned: Date)
    {
        self.detail = detail
        self.taskType = taskType
        self.timeCreate = timeCreate
        self.timePlanned = timeCreate
        self.secondTaskType = secondTaskType
    }

    var taskType: TaskType
    var secondTaskType: TaskType = .normal
}
