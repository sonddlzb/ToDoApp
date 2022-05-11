//
//  ListStore.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 08/04/2022.
//

import Foundation
class ListStore
{
    var allList = [List]()
    func createNewList(name: String)
    {
        let newList = List(name: name)
        Database.addList(newList: newList)
        allList.append(newList)
    }
    func taskNotFinished(currentList: Int) -> [Task]
    {
        return allList[currentList].listOfTask.filter{
            $0.getIsFinished() ==  false
        }
    }
    func taskFinished(currentList: Int) -> [Task]
    {
        return allList[currentList].listOfTask.filter{
            $0.getIsFinished() ==  true
        }
    }
    func numberOfImportantTaskInList() -> Int
    {
        var count = 0
        for list in allList
        {
            for task in list.listOfTask
            {
                if(task.getIsInterested() && !task.getIsFinished())
                {
                    count += 1
                }
            }
        }
        return count
    }
    var importantTaskListStoreNotFinished: [Task]
    {
        var res = [Task]()
        for list in allList
        {
            for task in list.listOfTask
            {
                if(task.getIsInterested() && !task.getIsFinished())
                {
                    res.append(task)
                }
            }
        }
        return res
    }
    
    var importantTaskListStoreBoth: [Task]
    {
        var res = [Task]()
        for list in allList
        {
            for task in list.listOfTask
            {
                if(task.getIsInterested() )
                {
                    res.append(task)
                }
            }
        }
        return res
    }
    
    var myDayListStore: [Task]
    {
        var res = [Task]()
        for list in allList
        {
            for task in list.listOfTask
            {
                if(task.getSecondTaskType() == .myDay)
                {
                    res.append(task)
                }
            }
        }
        return res
    }
    func removeByID(currentList: Int, id: String)
    {
        let task = self.findTaskByID(taskID: id)
            allList[currentList].listOfTask = allList[currentList].listOfTask.filter{
                $0.getTaskID() != id}
        print(task.getListID())
        Database.deleteTask(task: task)
    }
    
    func removeByID(id: String)
    {
        let task = self.findTaskByID(taskID: id)
        for list in allList
        {
            list.listOfTask = list.listOfTask.filter{
                $0.getTaskID() != id
            }
        }
        print(task.getListID())
        Database.deleteTask(task: task)
        
    }
    //search task
    func findTaskBySearchingKey(searchingKey: String) -> [Task]
    {
        var res = [Task]()
        for list in allList
        {
            for task in list.listOfTask
            {
                if task.getDetail().contains(searchingKey)
                {
                    res.append(task)
                }
            }
        }
        return res
    }
    func findTaskByID(taskID: String) -> Task
    {
        var foundTask: Task = Task()
        for list in allList
        {
            for task in list.listOfTask
            {
                if taskID == task.getTaskID()
                {
                    return task
                }
            }
        }
        return foundTask
    }
    func findListByListID(listID: String) -> List
    {
        var foundList: List = List()
        for list in allList {
            if list.getListID() == listID
            {
                foundList = list
                return foundList
            }
        }
        return foundList
    }
    func getListNameByTaskID(taskID: String) -> String
    {
        for list in allList
        {
            for task in list.listOfTask
            {
                if(taskID == task.getTaskID())
                {
                    return list.getName()
                }
            }
        }
        return ""
    }
}
