//
//  Extension.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 18/04/2022.
//

import Foundation
import UIKit
// MARK: - get day in week
extension Date {

     var dayofTheWeek: String {
          let dayNumber = Calendar.current.component(.weekday, from: self)
          // day number starts from 1 but array count from 0
          return daysOfTheWeek[dayNumber - 1]
     }
    var day: String
    {
        let dayCount: Int = Calendar.current.component(.day, from: self)
        return "\(dayCount)"
    }
    var week: Int
    {
        let weekCount: Int = Calendar.current.component(.yearForWeekOfYear, from: self)
        return weekCount
    }
    var monthString: String
    {
        let monthCount = Calendar.current.component(.month, from: self)
        // day number starts from 1 but array count from 0
        return monthsCount[monthCount - 1]
    }
     private var daysOfTheWeek: [String] {
          return  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
     }
    var dayOfTheWeekByInt: Int
    {
        return Calendar.current.component(.weekday, from: self)
    }
    private var monthsCount: [String] {
         return  ["January", "February", "March", "April", "May", "July", "June", "August", "September", "October", "November", "December"]
    }
  }

// MARK: - overloading operator - between 2 Date

extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}

extension UIColor
{
    enum ColorType: Int
    {
        case Blue = 0,Brown, Cyan, Green, Orange, Pink, Purple, Red, Yellow
    }
    func getColorFromInt(rawColorValue i: Int) -> UIColor
    {
        switch i
        {
        case 0: return .systemBlue
        case 1: return .systemBrown
        case 2: return .systemCyan
        case 3: return .systemGreen
        case 4: return .systemOrange
        case 5: return .systemPink
        case 6: return .systemPurple
        case 7: return .systemRed
        case 8: return .systemYellow
        default: return .systemBackground
        }
    }
}
