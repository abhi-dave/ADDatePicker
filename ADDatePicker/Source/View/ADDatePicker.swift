//
//  ADDatePicker.swift
//  horizontal-date-picker
//
//  Created by SOTSYS027 on 20/04/18.
//  Copyright © 2018 SOTSYS027. All rights reserved.
//

import UIKit


open class ADDatePicker: UIView {
    
    @IBOutlet weak var dateRow: UICollectionView!
    @IBOutlet weak var monthRow: UICollectionView!
    @IBOutlet weak var yearRow: UICollectionView!
    @IBOutlet public var calendarView: UIView!

    private var years = ModelDate.getYears()
    private let Months = ModelDate.getMonths()
    private var currentDay = "31"
    private var days:[ModelDate] = []
    
    
    // Accessible Properties
    public var selectedBgColor: UIColor = .darkGray
    public var selectedTextColor: UIColor = .orange
    public var deselectedBgColor: UIColor = .white
    public var deselectTextColor: UIColor = .black
    public var fontFamily: UIFont = UIFont(name: "GillSans-SemiBold", size: 20)!
    public var selectionType: SelectionType = .circle
    

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
        initialState(collectionView: dateRow)
        initialState(collectionView: monthRow)
        initialState(collectionView: yearRow)
    }

    private func loadinit(){
        let bundle = Bundle(for: self.classForCoder)
        bundle.loadNibNamed("ADDatePicker", owner: self, options: nil)
        addSubview(calendarView)
        calendarView.frame = self.bounds

    }
    
    private func initialState(collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
       

    delay(0.1){
        let indexPathForFirstRow = IndexPath(row: 4, section: 0)
        if let cell = collectionView.cellForItem(at: indexPathForFirstRow) as? ADDatePickerCell{
            cell.selectedCell(bgColor: self.selectedBgColor, textColor: self.selectedTextColor)
            switch collectionView.tag {
                case 0:
                    self.days[indexPathForFirstRow.row].isSelected = true
                    break
                case 1:
                    self.Months[indexPathForFirstRow.row].isSelected = true
                case 2:
                    self.years[indexPathForFirstRow.row].isSelected = true
                default:
                    break
            }
            collectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
        }
      }
    }
    
   private func registerCell(){
        let bundle = Bundle(for: self.classForCoder)
        let nibName = UINib(nibName: "ADDatePickerCell", bundle:bundle)
        dateRow.register(nibName, forCellWithReuseIdentifier: "cell")
        monthRow.register(nibName, forCellWithReuseIdentifier: "cell")
        yearRow.register(nibName, forCellWithReuseIdentifier: "cell")
    }
    
}

extension ADDatePicker: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return days.count
        case 1:
            return Months.count
        case 2:
            return years.count
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ADDatePickerCell
        cell.dateLbl.font = fontFamily
        cell.selectSelectionType(selectionType: selectionType)
        switch collectionView.tag {
        case 0:
            if days[indexPath.row].isSelected {
                cell.selectedCell(bgColor: selectedBgColor, textColor: selectedTextColor)
                
            }else {
                cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
            }
            cell.dateLbl.text = days[indexPath.row].type
        case 1:
            cell.dateLbl.text = Months[indexPath.row].type
            if Months[indexPath.row].isSelected {
                cell.selectedCell(bgColor: selectedBgColor, textColor: selectedTextColor)
            }else {
                cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
            }
        case 2:
            cell.dateLbl.text = years[indexPath.row].type
            if years[indexPath.row].isSelected {
                cell.selectedCell(bgColor: selectedBgColor, textColor: selectedTextColor)
            }else {
                cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
            }
        default:
            return cell
        }
        return cell
    }

    
}

extension ADDatePicker: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ADDatePickerCell {
            if collectionView.tag == 0 {
                for i in 0..<days.count {
                    if i != indexPath.row {
                        currentDay = days[i].type
                        days[i].isSelected = false
                    }
                }
                days[indexPath.row].isSelected = true
                compareDays()
                cell.selectedCell(bgColor: selectedBgColor, textColor: selectedTextColor)
            } else if collectionView.tag == 1 {
                for i in 0..<Months.count {
                    if i != indexPath.row {
                        Months[i].isSelected = false
                    }
                }
                Months[indexPath.row].isSelected = true
                cell.selectedCell(bgColor: selectedBgColor, textColor: selectedTextColor)
                compareDays()
                monthRow.reloadData()
                
            } else {
                for i in 0..<years.count {
                    if i != indexPath.row {
                        years[i].isSelected = false
                    }
                }
                years[indexPath.row].isSelected = true
                cell.selectedCell(bgColor: selectedBgColor, textColor: selectedTextColor)
                compareDays()
                yearRow.reloadData()
            }
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let focusedView = context.nextFocusedView as? UICollectionViewCell {
            let indexPath = collectionView.indexPath(for: focusedView)
            collectionView.scrollToItem(at: indexPath!, at: .centeredHorizontally, animated: true)
        }


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
        dateRow.reloadData()
        
        if Int(currentDay)! > days.count{
            days[days.count - 1].isSelected = true
            currentDay = "\(days.count)"
        }
    }
}


extension ADDatePicker {
    
   public func yearRange(inBetween start: Int, end: Int) {
        years = ModelDate.getYears(startYear: start, endYear: end)
        yearRow.reloadData()
    }
    public func getSelectedDate() -> Date{
        let date = CalendarHelper.getThatDate(days, Months, years)
        return date
    }
    
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }

}


