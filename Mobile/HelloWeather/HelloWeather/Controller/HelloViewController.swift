//
//  HelloViewController.swift
//  HelloWeather
//
//  Created by herongjin on 2022/3/1.
//

import UIKit
import SnapKit

class HelloViewController: UIViewController {
    
    lazy var helloLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var helloButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hello World!", for: .normal)
        button.tintColor = .white
        button.setBackgroundColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(goToWeatherView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        setUI()
    }
    
    func setUI() {
        view.addSubview(helloButton)
        helloButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.center.equalToSuperview()
        }
    }
    
    @objc func goToWeatherView() {
        self.navigationController?.pushViewController(WeatherViewController(), animated: true)
    }
    
    func assignbackground(){
        let background = UIImage(named: "hello")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}

// MARK: extensions
extension UIButton {
    func setBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(.pixel(ofColor: backgroundColor), for: state)
    }
}

extension UIImage {
    public static func pixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(pixel.size)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        context.setFillColor(color.cgColor)
        context.fill(pixel)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
