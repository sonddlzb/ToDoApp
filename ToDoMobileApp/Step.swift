//
//  Step.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 09/05/2022.
//

import Foundation
import RealmSwift
class Step: Object
{
    //@objc dynamic private var stepID: String = NSUUID().uuidString
    @objc dynamic private var taskID: String!
    @objc dynamic private var isFinished: Bool = false
    @objc dynamic private var name: String!
    
    override init() {
        super.init()
    }
    init(taskID: String, name: String)
    {
        self.taskID = taskID
        self.name = name
    }
    init(taskID: String,isFinished: Bool, name: String)
    {
        self.taskID = taskID
        self.name = name
    }
    
//    func getStepID() -> String
//    {
//        return self.stepID
//    }
    func getTaskID() -> String
    {
        return self.taskID
    }
    func getIsFinished() -> Bool
    {
        return self.isFinished
    }
    func getName() -> String
    {
        return self.name
    }
    func setName(newName: String)
    {
        try! Database.realm.write(
            {
                self.name = newName
            })
        //self.name = newName

    }
    func setIsFinished(newIsFinished: Bool)
    {
        try! Database.realm.write(
            {
                self.isFinished = newIsFinished
            })
        //self.isFinished = newIsFinished

    }
}
