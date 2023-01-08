//
//  List.swift
//  ToDoClone
//
//  Created by đào sơn on 06/04/2022.
//

import Foundation
import RealmSwift
class List: Object
{
    override init() {
        
    }
    @objc dynamic private var listID: String = NSUUID().uuidString
    @objc dynamic private var name: String = ""
    var  listOfTask: [Task] = []
    func getName() -> String
    {
        return self.name
    }
    func setName(newName: String)
    {
        try! Database.realm.write(
            {
                self.name = newName
            }
        )
    }
    func getListID() -> String
    {
        return self.listID
    }
    func addTask(task: Task)
    {
        Database.addTask(newTask: task)
        self.listOfTask.append(task)
    }
    var taskFinished: [Task]
    {
        var finished: [Task] = []
        for value in listOfTask
        {
            if value.getIsFinished() == true
            {
                finished.append(value)
            }
        }
        return finished
    }
    var taskNotFinished: [Task]
    {
        var notFinished: [Task] = []
        for value in listOfTask
        {
            if value.getIsFinished() == false
            {
                notFinished.append(value)
            }
        }
        return notFinished
    }
    init(name: String)
    {
        self.name = name
    }
}
