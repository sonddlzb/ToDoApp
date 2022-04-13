//
//  List.swift
//  ToDoClone
//
//  Created by đào sơn on 06/04/2022.
//

import Foundation
class List
{
    @objc dynamic var name: String
    var  listOfTask: [Task] = []
    func addTask(task: Task)
    {
        self.listOfTask.append(task)
    }
    var taskFinished: [Task]
    {
        var finished: [Task] = []
        for value in listOfTask
        {
            if value.isFinished == true
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
            if value.isFinished == false
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
