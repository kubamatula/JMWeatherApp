//
//  WeatherDetailsView.swift
//  WeatherApp
//
//  Created by Jakub Matuła on 1/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class WeatherDetailsView: UIView {

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private var contentView:UIView?
    @IBOutlet private weak var current: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var weatherDescription: UILabel!
    @IBOutlet private weak var temprature: UILabel!
    @IBOutlet private weak var pressure: UILabel!
    @IBOutlet private weak var weatherIcon: UIImageView!
    
    var weather: Weather? {
        didSet {
            guard let weather = weather else { return}
            temprature?.text = String(describing: weather.temprature) + " °C"
            weatherDescription?.text = weather.weatherText
            pressure?.text = "Pressure" + " " + String(describing: weather.pressure) + " hPa"
            date?.text = "15:44, 19.02.2017"
        }
    }
    
    var icon: UIImage? {
        get {
            return weatherIcon?.image
        }
        set {
            weatherIcon?.image = newValue
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return stackView.intrinsicContentSize
    }
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("WeatherDetailsView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    
}
