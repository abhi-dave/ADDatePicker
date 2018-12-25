//
//  ADDatePicker.swift
//  horizontal-date-picker
//
//  Created by SOTSYS027 on 20/04/18.
//  Copyright © 2018 SOTSYS027. All rights reserved.
//

import UIKit

public protocol ADDatePickerDelegate {
    func ADDatePicker(didChange date: Date)
}

open class ADDatePicker: UIView {
    
    @IBOutlet weak var dateRow: UICollectionView!
    @IBOutlet weak var monthRow: UICollectionView!
    @IBOutlet weak var yearRow: UICollectionView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var selectionView: UIView!
    
    private var years = ModelDate.getYears()
    private let Months = ModelDate.getMonths()
    private var currentDay = "31"
    private var days:[ModelDate] = []
    var infiniteScrollingBehaviourForYears: InfiniteScrollingBehaviour!
    var infiniteScrollingBehaviourForDays: InfiniteScrollingBehaviour!
    var infiniteScrollingBehaviourForMonths: InfiniteScrollingBehaviour!
    
    // Accessible Properties
    
    public var bgColor: UIColor = #colorLiteral(red: 0.5564764738, green: 0.754239738, blue: 0.6585322022, alpha: 1)
    public var selectedBgColor: UIColor = .white
    public var selectedTextColor: UIColor = .white
    public var deselectedBgColor: UIColor = .clear
    public var deselectTextColor: UIColor = UIColor.init(white: 1.0, alpha: 0.7)
    public var fontFamily: UIFont = UIFont(name: "GillSans-SemiBold", size: 20)!
    public var selectionType: SelectionType = .roundedsquare
    public var intialDate:Date = Date()
    public var delegate:ADDatePickerDelegate?
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadinit()
        registerCell()
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadinit()
        registerCell()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        days = ModelDate.getDays(years, Months)
        
        if let _ = infiniteScrollingBehaviourForDays {}
        else {
            let configuration = CollectionViewConfiguration(layoutType: .fixedSize(sizeValue: 60, lineSpacing: 10), scrollingDirection: .horizontal)
            infiniteScrollingBehaviourForMonths = InfiniteScrollingBehaviour(withCollectionView: monthRow, andData: Months, delegate: self, configuration: configuration)
            infiniteScrollingBehaviourForDays = InfiniteScrollingBehaviour(withCollectionView: dateRow, andData: days, delegate: self, configuration: configuration)
            infiniteScrollingBehaviourForYears = InfiniteScrollingBehaviour(withCollectionView: yearRow, andData: years, delegate: self, configuration: configuration)
        }
    }
    
    private func loadinit(){
        let bundle = Bundle(for: self.classForCoder)
        bundle.loadNibNamed("ADDatePicker", owner: self, options: nil)
        addSubview(calendarView)
        calendarView.frame = self.bounds
        delay(0.1){
            self.selectionView.backgroundColor = self.selectedBgColor
            self.selectionView.selectSelectionType(selectionType: self.selectionType)
            self.initialDate(date: self.intialDate)
            self.calendarView.backgroundColor = self.bgColor
        }
    }
    
    func initialDate(date: Date){
        let (mm,dd,yyyy) = date.seprateDateInDDMMYY
        let y = years.index { (modelObj) -> Bool in
            return modelObj.type == yyyy
        }
        
        let d = days.index { (modelObj) -> Bool in
            return Int(modelObj.type) == Int(dd)
        }
        
        let m = Int(mm)! - 1
        
        years[y!].isSelected = true
        Months[m].isSelected = true
        days[d!].isSelected = true
        
        collectionState(infiniteScrollingBehaviourForYears, y!)
        collectionState(infiniteScrollingBehaviourForMonths, m)
        collectionState(infiniteScrollingBehaviourForDays, d!)
        
    }
    
    private func collectionState(_ collectionView: InfiniteScrollingBehaviour, _ index: Int) {
        let indexPathForFirstRow = IndexPath(row: index, section: 0)
        switch collectionView.collectionView.tag {
        case 0:
            self.days[indexPathForFirstRow.row].isSelected = true
            infiniteScrollingBehaviourForDays.reload(withData: days)
            break
        case 1:
            self.Months[indexPathForFirstRow.row].isSelected = true
            infiniteScrollingBehaviourForMonths.reload(withData: Months)
            break
        case 2:
            self.years[indexPathForFirstRow.row].isSelected = true
            infiniteScrollingBehaviourForYears.reload(withData: years)
            break
        default:
            break
        }
        
        collectionView.scroll(toElementAtIndex: index)
    }
    
    private func registerCell(){
        let bundle = Bundle(for: self.classForCoder)
        let nibName = UINib(nibName: "ADDatePickerCell", bundle:bundle)
        dateRow.register(nibName, forCellWithReuseIdentifier: "cell")
        monthRow.register(nibName, forCellWithReuseIdentifier: "cell")
        yearRow.register(nibName, forCellWithReuseIdentifier: "cell")
    }
}

extension ADDatePicker: UICollectionViewDelegate {
    
    
    public func didEndScrolling(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) {
        selectMiddleRow(collectionView: behaviour.collectionView, data: behaviour.dataSetWithBoundary as! [ModelDate])
        switch behaviour.collectionView.tag {
        case 0:
            behaviour.reload(withData: days)
        case 1:
            behaviour.reload(withData: Months)
            break
        case 2:
            behaviour.reload(withData: years)
        default:
            break
        }
        
        let date = CalendarHelper.getThatDate(days, Months, years)
        delegate?.ADDatePicker(didChange: date)
    }
    func selectMiddleRow(collectionView: UICollectionView, data: [ModelDate]){
        
        let Row = calculateMedian(array: collectionView.indexPathsForVisibleItems)
        let selectedIndexPath = IndexPath(row: Int(Row), section: 0)
        for i in 0..<data.count {
            if i != selectedIndexPath.row {
                data[i].isSelected = false
            }
        }
        if let cell = collectionView.cellForItem(at: selectedIndexPath) as? ADDatePickerCell {
            cell.selectedCell(textColor: self.selectedTextColor)
            data[Int(Row)].isSelected = true
            if collectionView.tag != 0{
                compareDays()
            }
        }
        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
    }
    
}

extension ADDatePicker {
    
    private func compareDays(){
        let newDays = ModelDate.getDays(years, Months)
        if let selectedDay = days.filter({ (modelObject) -> Bool in
            return modelObject.isSelected
        }).first {
            newDays.selectDay(selectedDay: selectedDay)
        }
        days = newDays
        // infiniteScrollingBehaviourForDays.collectionView.reloadSections(IndexSet(integer: 0))
        infiniteScrollingBehaviourForDays.reload(withData: days)
        if Int(currentDay)! > days.count{
            let index = days.count - 1
            days[index].isSelected = true
            currentDay = "\(days.count)"
        }
    }
    
}

extension ADDatePicker : InfiniteScrollingBehaviourDelegate {
    public func configuredCell(collectionView: UICollectionView, forItemAtIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell {
        let cell = behaviour.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ADDatePickerCell
        cell.dateLbl.font = fontFamily
        switch behaviour.collectionView.tag {
        case 0:
            if let day = data as? ModelDate {
                if day.isSelected {
                    cell.selectedCell(textColor: selectedTextColor)
                }else {
                    cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                }
                cell.dateLbl.text = day.type
            }
        case 1:
            if let month = data as? ModelDate {
                cell.dateLbl.text = month.type
                if month.isSelected {
                    cell.selectedCell(textColor: selectedTextColor)
                    
                }else {
                    cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                }
            }
            
        case 2:
            if let year = data as? ModelDate {
                cell.dateLbl.text = year.type
                if year.isSelected {
                    cell.selectedCell(textColor: selectedTextColor)
                }else {
                    cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                }
            }
        default:
            return cell
        }
        
        return cell
    }
    
    
    public func didSelectItem(collectionView: UICollectionView,atIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) {
        if let cell = behaviour.collectionView.cellForItem(at: indexPath) as? ADDatePickerCell {
            cell.dateLbl.font = fontFamily
            if behaviour.collectionView.tag == 0 {
                for i in 0..<days.count {
                    if i != originalIndex {
                        currentDay = days[i].type
                        days[i].isSelected = false
                    }
                }
                days[originalIndex].isSelected = true
                compareDays()
                cell.selectedCell(textColor: selectedTextColor)
            } else if behaviour.collectionView.tag == 1 {
                for i in 0..<Months.count {
                    if i != originalIndex {
                        Months[i].isSelected = false
                    }
                }
                Months[originalIndex].isSelected = true
                cell.selectedCell(textColor: selectedTextColor)
                compareDays()
                infiniteScrollingBehaviourForMonths.reload(withData: Months)
                
            } else {
                for i in 0..<years.count {
                    if i != originalIndex {
                        years[i].isSelected = false
                    }
                }
                years[originalIndex].isSelected = true
                cell.selectedCell(textColor: selectedTextColor)
                compareDays()
                infiniteScrollingBehaviourForYears.reload(withData: years)
            }
        }
        let date = CalendarHelper.getThatDate(days, Months, years)
        delegate?.ADDatePicker(didChange: date)
        behaviour.scroll(toElementAtIndex: originalIndex)
    }
    
}

extension ADDatePicker {
    
    public func yearRange(inBetween start: Int, end: Int) {
        years = ModelDate.getYears(startYear: start, endYear: end)
        infiniteScrollingBehaviourForYears.reload(withData: years)
        //yearRow.reloadData()
    }
    public func getSelectedDate() -> Date{
        let date = CalendarHelper.getThatDate(days, Months, years)
        return date
    }
}

extension ADDatePicker {
    
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func calculateMedian(array: [IndexPath]) -> Float {
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return Float((sorted[(sorted.count / 2)].row + sorted[(sorted.count / 2) - 1].row)) / 2
        } else {
            return Float(sorted[(sorted.count - 1) / 2].row)
        }
    }
    
}
