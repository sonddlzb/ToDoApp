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
        self.timePlanned = timePlanned
    }
    init(detail: String, taskType: TaskType, secondTaskType: TaskType, timeCreate: Date, timePlanned: Date)
    {
        self.detail = detail
        self.taskType = taskType
        self.timeCreate = timeCreate
        self.timePlanned = timePlanned
        self.secondTaskType = secondTaskType
    }

    var taskType: TaskType
    var steps: [(Bool,String)] = []
    var secondTaskType: TaskType = .normal
    var due: DueType
    {
        if self.timePlanned.day == Date().day        {
            return .Today
        }
        if self.timePlanned < Date()
        {
            return .Overdue
        }
        if Int(self.timePlanned.day)! - Int(Date().day)! == 1
        {
            return .Tomorrow
        }
        if (self.timePlanned - Date()).day! <= 7
        {
            return .ThisWeek
        }

        return .Later
    }
}
