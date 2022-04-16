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
            if value.taskType == .myDay && !value.isFinished
            {
                myDay.append(value)
            }
        }
        return myDay
    }
        
    var planTask: [Task]
    {
        var plan: [Task] = []
        for value in allTask
        {
            if value.taskType == .planned && !value.isFinished
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
            if value.taskType == .normal && !value.isFinished
            {
                normal.append(value)
            }
        }
        return normal
    }
    var importantTaskTaskStore: [Task]
    {
        var res: [Task] = []
        for task in allTask
        {
            if(task.taskType == .important && !task.isFinished)
            {
                res.append(task)
            }
            if(task.taskType == .myDay && task.isInterested && !task.isFinished)
            {
                res.append(task)
            }
            if(task.taskType == .planned && task.isInterested && !task.isFinished)
            {
                res.append(task)
            }
            if(task.taskType == .normal && task.isInterested && !task.isFinished)
            {
                res.append(task)
            }
        }
        return res
    }
}

