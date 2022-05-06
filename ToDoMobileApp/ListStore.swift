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
        allList.append(newList)
    }
    func taskNotFinished(currentList: Int) -> [Task]
    {
        return allList[currentList].listOfTask.filter{
            $0.isFinished ==  false
        }
    }
    func taskFinished(currentList: Int) -> [Task]
    {
        return allList[currentList].listOfTask.filter{
            $0.isFinished ==  true
        }
    }
    func numberOfImportantTaskInList() -> Int
    {
        var count = 0
        for list in allList
        {
            for task in list.listOfTask
            {
                if(task.isInterested && !task.isFinished)
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
                if(task.isInterested && !task.isFinished)
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
                if(task.isInterested )
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
                if(task.secondTaskType == .myDay)
                {
                    res.append(task)
                }
            }
        }
        return res
    }
    func removeByID(currentList: Int, id: String)
    {
        allList[currentList].listOfTask = allList[currentList].listOfTask.filter{$0.taskID != id}
    }
    
    func removeByID(id: String)
    {
        for list in allList
        {
            list.listOfTask = list.listOfTask.filter{
                $0.taskID != id
            }
        }
    }
    //search task
    func findTaskBySearchingKey(searchingKey: String) -> [Task]
    {
        var res = [Task]()
        for list in allList
        {
            for task in list.listOfTask
            {
                if task.detail.contains(searchingKey)
                {
                    res.append(task)
                }
            }
        }
        return res
    }
}
