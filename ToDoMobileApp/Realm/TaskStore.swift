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
        Database.addTask(newTask: task)
        allTask.append(task)
        
    }
    var taskFinished: [Task]
    {
        var finished: [Task] = []
        for value in allTask
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
        for value in allTask
        {
            if value.getIsFinished() == false
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
            if value.getTaskType() == .myDay && !value.getIsFinished()
            {
                myDay.append(value)
            }
            if value.getSecondTaskType() == .myDay && !value.getIsFinished()
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
            if value.getTaskType() == .planned && !value.getIsFinished()
            {
                plan.append(value)
            }
        }
        return plan
    }
    var planTaskAnphabeticallySort: [Task]
    {
        var plan: [Task] = []
        for value in allTask
        {
            if value.getTaskType() == .planned && !value.getIsFinished()
            {
                plan.append(value)
            }
        }
        return plan.sorted{
            $0.getDetail() < $1.getDetail()
        }
        
    }
    var bothPlanTask: [Task]
    {
        var plan: [Task] = []
        for value in allTask
        {
            if value.getTaskType() == .planned
            {
                plan.append(value)
            }
        }
        return plan
    }
    var planOverdueTask: [Task]
    {
        return planTask.filter{$0.due == .Overdue}
    }
    var planTodayTask: [Task]
    {
        return planTask.filter{$0.due == .Today}
    }
    var planTomorrowTask: [Task]
    {
        return planTask.filter{$0.due == .Tomorrow}
    }
    
    var planThisWeekTask: [Task]
    {
        return planTask.filter{$0.due == .ThisWeek}
    }
    var planLaterTask: [Task]
    {
        return planTask.filter{$0.due == .Later}
    }
    var bothPlanOverdueTask: [Task]
    {
        return bothPlanTask.filter{$0.due == .Overdue}
    }
    var bothPlanTodayTask: [Task]
    {
        return bothPlanTask.filter{$0.due == .Today}
    }
    var  bothPlanTomorrowTask: [Task]
    {
        return bothPlanTask.filter{$0.due == .Tomorrow}
    }
    
    var bothPlanThisWeekTask: [Task]
    {
        return bothPlanTask.filter{$0.due == .ThisWeek}
    }
    var bothPlanLaterTask: [Task]
    {
        return bothPlanTask.filter{$0.due == .Later}
    }
    var normalTask: [Task]
    {
        var normal: [Task] = []
        for value in allTask
        {
            if value.getTaskType() == .normal && !value.getIsFinished()
            {
                normal.append(value)
            }
        }
        return normal
    }
    var importantTaskTaskStoreNotFinished: [Task]
    {
        var res: [Task] = []
        for task in allTask
        {
            if(task.getTaskType() != .listed && task.getIsInterested() && !task.getIsFinished())
            {
                res.append(task)
            }
        }
        return res
    }
    var importantTaskTaskStoreBoth: [Task]
    {
        var res: [Task] = []
        for task in allTask
        {
            if(task.getTaskType() != .listed && task.getIsInterested())
            {
                res.append(task)
            }
        }
        return res
    }
    func removeByID(id: String)
    {
        let task = self.getTaskByID(id: id)
        for (index,task) in allTask.enumerated()
        {
            if(task.getTaskID() == id)
            {
                allTask.remove(at: index)
            }
        }
        Database.deleteTask(task: task)
        


    }
    
    //search Task
    func searchTaskBySearchingKey(searchingKey: String) -> [Task]
    {
        return self.allTask.filter{
            $0.getDetail().contains(searchingKey)
        }
    }
    
    func getTaskByID(id: String) -> Task
    {
        var foundTask: Task = Task()
        for task in allTask {
            if task.getTaskID() == id
            {
                foundTask = task
                return foundTask
            }
        }
        return foundTask
    }
}

