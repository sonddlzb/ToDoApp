//
//  TaskStore.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 13/04/2022.
//

//store task is not type of list
import Foundation
class TaskStore
{
    var allTask = [Task]()
    func addTask(task: Task)
    {
        allTask.append(task)
    }
    var taskFinished: [Task]
    {
        var finished: [Task] = []
        for value in allTask
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
        for value in allTask
        {
            if value.isFinished == false
            {
                notFinished.append(value)
            }
        }
        return notFinished
    }
    var myDayTask: [Task]
    {
        var myDay: [Task] = []
        for value in allTask
        {
            if value.taskType == .myDay
            {
                myDay.append(value)
            }
        }
        return myDay
    }
    
    var importantTask: [Task]
    {
        var important: [Task] = []
        for value in allTask
        {
            if value.taskType == .important
            {
                important.append(value)
            }
        }
        return important
    }
    
    var planTask: [Task]
    {
        var plan: [Task] = []
        for value in allTask
        {
            if value.taskType == .planned
            {
                plan.append(value)
            }
        }
        return plan
    }
    
    var normalTask: [Task]
    {
        var normal: [Task] = []
        for value in allTask
        {
            if value.taskType == .normal
            {
                normal.append(value)
            }
        }
        return normal
    }
}

