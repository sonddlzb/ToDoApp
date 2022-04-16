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
//    func findTaskByID(taskID: String) -> Task?
//    {
//        for list in allList
//        {
//            for task in list.listOfTask
//            {
//                if(taskID == task.taskID)
//                {
//                    return task
//                }
//            }
//        }
//        return nil
//    }
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
    var importantTaskListStore: [Task]
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
}
