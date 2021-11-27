/*
 * CalendarDayCell.swift
 * Created by Michael Michailidis on 02/04/2015.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit
import SnapKit
import Then

open class CalendarDayCell: UICollectionViewCell {
    
    var style: CalendarView.Style = CalendarView.Style.Default
    
    override open var description: String {
        let dayString = self.textLabel.text ?? " "
        return "<DayCell (text:\"\(dayString)\")>"
    }
    
    var eventsCount = 0 {
        didSet {
            self.dotsView.isHidden = (eventsCount == 0)
            self.setNeedsLayout()
        }
    }
    
    var day: Int? {
        set {
            guard let value = newValue else { return self.textLabel.text = nil }
            self.textLabel.text = String(value)
        }
        get {
            guard let value = self.textLabel.text else { return nil }
            return Int(value)
        }
    }
    
    func updateTextColor() {
        if isSelected {
            self.textLabel.textColor = style.cellSelectedTextColor
        }
        else if isToday {
            self.textLabel.textColor = style.cellTextColorToday
        }
        else if isOutOfRange {
            self.textLabel.textColor = style.cellColorOutOfRange
        }
        else if isAdjacent {
            self.textLabel.textColor = style.cellColorAdjacent
        }
        else if isWeekend {
            self.textLabel.textColor = style.cellTextColorWeekend
        }
        else {
            self.textLabel.textColor = style.cellTextColorDefault
        }
    }
    
    var isToday : Bool = false {
        didSet {
            switch isToday {
            case true:
                self.bgView.backgroundColor = style.cellColorToday
            case false:
                self.bgView.backgroundColor = style.cellColorDefault
            }
            
            updateTextColor()
        }
    }
    
    var isOutOfRange : Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    var isAdjacent : Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    var isWeekend: Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    override open var isSelected : Bool {
        didSet {
            switch isSelected {
            case true:
                self.bgView.layer.borderColor = style.cellSelectedBorderColor.cgColor
                self.bgView.layer.borderWidth = style.cellSelectedBorderWidth
                self.bgView.backgroundColor = style.cellSelectedColor
            case false:
                self.bgView.layer.borderColor = style.cellBorderColor.cgColor
                self.bgView.layer.borderWidth = style.cellBorderWidth
                if self.isToday {
                    self.bgView.backgroundColor = style.cellColorToday
                } else {
                    self.bgView.backgroundColor = style.cellColorDefault
                }
            }
            
            updateTextColor()
        }
    }
    
    // MARK: - Public methods
    public func clearStyles() {
        self.bgView.layer.borderColor = style.cellBorderColor.cgColor
        self.bgView.layer.borderWidth = style.cellBorderWidth
        self.bgView.backgroundColor = style.cellColorDefault
        self.textLabel.textColor = style.cellTextColorDefault
        self.eventsCount = 0
    }
    
    let checkBackView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let checkImageView = UIImageView()
    
    let checkLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.poppins()
        $0.textAlignment = .center
    }
    
    // 일 표시
    let textLabel   = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.spoqa(size: 11, family: .regular)
        $0.textColor = .gray
    }
    
    
    
    
    let dotsView    = UIView()
    let bgView      = UIView()
    
    override init(frame: CGRect) {
        
//        self.dotsView.backgroundColor = style.cellEventColor
        
        super.init(frame: frame)
        
//        self.addSubview(self.bgView)
//        self.addSubview(self.textLabel)
//        self.addSubview(self.dotsView)
        
        
        
        setLayout()
        
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    
    func setLayout() {
        self.addSubviews(
            checkBackView,
            textLabel)
        
        checkBackView.addSubviews(
            checkImageView,
            checkLabel)
        
        checkBackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(checkBackView.snp.width)
        }
        
        textLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.edges.equalTo(checkBackView)
        }
        
        checkLabel.snp.makeConstraints {
            $0.edges.equalTo(checkBackView)
        }
    }
    
    
    
    
    override open func layoutSubviews() {

        super.layoutSubviews()

//        var elementsFrame = self.bounds.insetBy(dx: 3.0, dy: 3.0)
//
//        if style.cellShape.isRound { // square of
//            let smallestSide = min(elementsFrame.width, elementsFrame.height)
//            elementsFrame = elementsFrame.insetBy(
//                dx: (elementsFrame.width - smallestSide) / 2.0,
//                dy: (elementsFrame.height - smallestSide) / 2.0
//            )
//        }
//
//        self.bgView.frame           = elementsFrame
//        self.textLabel.frame        = elementsFrame
//
//        let size                            = self.bounds.height * 0.08 // always a percentage of the whole cell
//        self.dotsView.frame                 = CGRect(x: 0, y: 0, width: size, height: size)
//        self.dotsView.center                = CGPoint(x: self.textLabel.center.x, y: self.bounds.height - (2.5 * size))
//        self.dotsView.layer.cornerRadius    = size * 0.5 // round it
//
//        switch style.cellShape {
//        case .square:
//            self.bgView.layer.cornerRadius = 0.0
//        case .round:
//            self.bgView.layer.cornerRadius = elementsFrame.width * 0.5
//        case .bevel(let radius):
//            self.bgView.layer.cornerRadius = radius
//        }
        
        
        
        
        checkBackView.layer.cornerRadius = checkBackView.frame.height/2
        checkBackView.layer.masksToBounds = true
        
        
    }
    
    
    
}
