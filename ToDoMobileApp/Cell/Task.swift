//
//  Task.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 08/04/2022.
//

import Foundation
import RealmSwift
class Task: Object
{
    @objc dynamic private var taskID = NSUUID().uuidString
    @objc dynamic private var listID = ""
    @objc dynamic private var  detail: String!
    @objc dynamic private var  isFinished: Bool = false
    @objc dynamic private var  isInterested: Bool = false
    @objc dynamic private var timeCreate: Date!
    @objc dynamic private var timePlanned: Date!
    
    override init() {
    }
    
    func getTaskID() -> String
    {
        return self.taskID
    }
    
    func getDetail() -> String
    {
        return self.detail
    }
    func setDetail(newDetail: String)
    {
        try! Database.realm.write(
            {
                self.detail = newDetail
            })
        //self.detail = newDetail

    }
    
    func getListID() -> String
    {
        return self.listID
    }
    func setListID(listID: String)
    {
        try! Database.realm.write(
            {
                self.listID = listID
            })
    }
    func getIsFinished() -> Bool
    {
        return self.isFinished
    }
    func setIsFinished(newState: Bool)
    {
        try! Database.realm.write(
            {
                self.isFinished = newState
            })
        //self.isFinished = newState

    }
    
    func getIsInterested() -> Bool
    {
        return self.isInterested
    }
    func setIsInterested(newState: Bool)
    {
        try! Database.realm.write(
            {
                self.isInterested = newState
            })
        //self.isInterested = newState

    }
    
    func getTimeCreate() -> Date
    {
        return self.timeCreate
    }
    func setTimeCreate(newTime: Date)
    {
        self.timeCreate = newTime
        try! Database.realm.write(
            {
                self.timeCreate = newTime
            })
    }
    
    func getTimePlanned() -> Date
    {
        return self.timePlanned
    }
    func setTimePlanned(newTime: Date)
    {
        try! Database.realm.write(
            {
                self.timePlanned = newTime
            })
        //self.timePlanned = newTime

    }
    @objc dynamic private var taskTypeRaw: Int = TaskType.normal.rawValue
    private var taskType: TaskType!
    {
        get{
            return TaskType(rawValue: taskTypeRaw)
        }
        set
        {
            taskTypeRaw = newValue.rawValue
        }
    }
    func getTaskType() -> TaskType
    {
        return TaskType(rawValue: taskTypeRaw)!
    }
    func setTaskType(newTaskType: TaskType)
    {
        //taskTypeRaw = newTaskType.rawValue
        try! Database.realm.write(
            {
                self.taskTypeRaw = newTaskType.rawValue
            })
    }
    var steps: [Step] = []
    @objc dynamic private var secondTaskTypeRaw: Int = TaskType.normal.rawValue
    private var secondTaskType: TaskType!
    {
        get{
            return TaskType(rawValue: secondTaskTypeRaw)
        }
        set
        {
            secondTaskTypeRaw = newValue.rawValue
        }
    }
    func getSecondTaskType() -> TaskType
    {
        return TaskType(rawValue: secondTaskTypeRaw)!
    }
    func setSecondTaskType(newTaskType: TaskType)
    {
        try! Database.realm.write(
            {
                self.secondTaskTypeRaw = newTaskType.rawValue
            })
        //secondTaskTypeRaw = newTaskType.rawValue
    }
    var note: String = ""
    
    
    init(detail: String, taskType: TaskType, timeCreate: Date)
    {
        super.init()
        if(taskType == .important)
        {
            self.isInterested = true
        }
        self.detail = detail
        self.timeCreate = timeCreate
        self.timePlanned = timeCreate
        self.taskType = taskType
    }
    
    init(detail: String, taskType: TaskType, timeCreate: Date, timePlanned: Date)
    {
        super.init()
        if(taskType == .important)
        {
            self.isInterested = true
        }
        self.detail = detail
        self.timeCreate = timeCreate
        self.timePlanned = timePlanned
        self.taskType = taskType
    }
    init(detail: String, taskType: TaskType, secondTaskType: TaskType, timeCreate: Date, timePlanned: Date)
    {
        super.init()
        if(taskType == .important)
        {
            self.isInterested = true
        }
        self.detail = detail
        self.timeCreate = timeCreate
        self.timePlanned = timePlanned
        self.secondTaskType = secondTaskType
        self.taskType = taskType
    }
    init(detail: String, taskType: TaskType, secondTaskType: TaskType, timeCreate: Date, timePlanned: Date, listID: String)
    {
        super.init()
        if(taskType == .important)
        {
            self.isInterested = true
        }
        self.detail = detail
        self.timeCreate = timeCreate
        self.timePlanned = timePlanned
        self.secondTaskType = secondTaskType
        self.listID = listID
        self.taskType = taskType

    }
    
    init(detail: String, taskType: TaskType, timeCreate: Date, timePlanned: Date, listID: String)
    {
        super.init()
        if(taskType == .important)
        {
            self.isInterested = true
        }
        self.detail = detail
        self.timeCreate = timeCreate
        self.timePlanned = timePlanned
        self.listID = listID
        self.taskType = taskType
    }

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
