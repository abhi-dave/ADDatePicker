![ADDatePicker: Horizontal Date Picker](https://github.com/abhiperry/ADDatePicker/blob/master/Documentation/AdDatePicker.png)


ADDatePicker is Horizontal Date Picker Library written in Swift


- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
- [Demo](#demo)
- [Customization](#customization)
- [Credits](#credits)
- [License](#license)

## Requirements

- iOS 10.0+
- Xcode 10.0+
- Swift 4.2+

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required

To integrate ADDatePicker into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
pod 'ADDatePicker'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

- First, set Custom Class of UIView to ADDatePicker...

<img src="https://github.com/abhiperry/ADDatePicker/blob/master/Documentation/Add%20Class.png" width="480">


..And That's it., you can run the project now. it's that simple. ;]


## Demo

<img src="https://github.com/abhiperry/ADDatePicker/blob/master/Documentation/ADDatePicker_Demo1.gif" width="240">  <img src="https://github.com/abhiperry/ADDatePicker/blob/master/Documentation/ADDatePicker_Demo2.gif" width="240">

Customize with ease..!

## Customization 

> "Listen up, Dave. Your code is poor and colour choices are even poorer. this doesn't look good"

> "Calm Down Joe, I gotchu.."

```swift
 @IBOutlet weak var datePicker: ADDatePicker!
```
#### 1. Reset Range of years.
  ```swift
   datePicker.yearRange(inBetween: 1990, end: 2022)
  ``` 
#### 2. Set Intial Date to Picker.
  ```swift
   datePicker.intialDate = Date()
  ``` 
#### 3. Yay, Colours.. or Colors. (depends.. where you came from)
  ```swift
    //set BackGround Color of DatePicker
    datePicker.bgColor = .blue

    //set Selection and Deselection Background Colors
        
    datePicker.deselectedBgColor = .clear
    datePicker.selectedBgColor = .white
        
    //set Selection and Deselection Text Colors
    datePicker.selectedTextColor = .black 
    datePicker.deselectTextColor = UIColor.init(white: 1.0, alpha: 0.7)
  ```

#### 4. Customize Selector..

   Currently, there are three selectionType available. you're most welcome to contribute if you want to extand this       list.
  ```swift
   enum SelectionType {
       case square
       case roundedsquare
       case circle
   }    
  ```
  You can change selector by writing this piece of code.
  ```swift
   datePicker.selectionType = .circle
  ```
  
 #### 5. Delegate Methods..
    
   Now, You can confirm to Delegate method to access date on scroll 
   ```swift
   datePicker.delegate = self
   func ADDatePicker(didChange date: Date)
   ```
   Which allows you to get new date on every scroll.
      
## Credits

ADDatePicker is developed under observation of the great minds of [Space-O Technology](https://www.spaceotechnologies.com)

## License

ADDatePicker is released under the MIT license. [See License](https://github.com/abhiperry/ADDatePicker/blob/master/LICENSE) for details.
