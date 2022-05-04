//
//  ColorViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 29/04/2022.
//

import UIKit
import Foundation
protocol ColorViewControllerDelegate
{
    func colorViewController(Opacity opacity: Float)
}
class ColorViewController: UIViewController {

    var delegate: ColorViewControllerDelegate?
    private let highlightView: UIView =
    {
        let view = UIView()
        view.backgroundColor = view.tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var highlightViewXConstraint: NSLayoutConstraint! {
        didSet {
            oldValue?.isActive = false
            highlightViewXConstraint.isActive = true
        }
    }
    var selectedIndex = 0 {
        didSet {
            if selectedIndex < 0 {
                selectedIndex = 0
            }
            print(selectedIndex)
            let colorButton = colorButtons[selectedIndex]
            highlightViewXConstraint =
                highlightView.centerXAnchor.constraint(equalTo: colorButton.centerXAnchor)
        }
    }
    @IBOutlet weak var colorStackView: UIStackView!
    var colorButtons: [UIButton] = []
    var colors: [UIColor] = [.systemBlue, .systemBrown, .systemCyan, .systemGreen, .systemOrange, .systemPink, .systemPurple, .systemRed, .systemYellow]
    
    @IBAction func doneButtonTap(_ sender: UIBarButtonItem) {
        delegate?.colorViewController(Opacity: 1.0)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func colorSelected(_ sender: UIButton)
    {
        switch sender.backgroundColor!
        {
        case .systemBlue: selectedIndex = 0
        case .systemBrown: selectedIndex = 1
        case .systemCyan: selectedIndex = 2
        case .systemGreen: selectedIndex = 3
        case .systemOrange: selectedIndex = 4
        case .systemPink: selectedIndex = 5
        case .systemPurple: selectedIndex = 6
        case .systemRed: selectedIndex = 7
        case .systemYellow: selectedIndex = 8
        default: "Wrong index"
        }
    }

    func setUpColorButtonForStackView()
    {
        for(index,value) in colors.enumerated()
        {
            let newColorButton = UIButton()
            newColorButton.backgroundColor = colors[index]
            newColorButton.sizeToFit()
            //newColorButton.setTitleColor(UIColor.getColorFromInt(rawColorValue: index), for: .normal)
            newColorButton.layer.masksToBounds = true
            colorStackView.addArrangedSubview(newColorButton)
            newColorButton.layer.cornerRadius = min(newColorButton.frame.height, newColorButton.frame.width) / 2
            newColorButton.addTarget(self, action: #selector(self.colorSelected(_:)), for: .touchUpInside)
            colorButtons.append(newColorButton)
        }
        
        self.view.insertSubview(highlightView, belowSubview: colorStackView)
        NSLayoutConstraint.activate([
            highlightView.heightAnchor.constraint(equalTo: highlightView.widthAnchor),
            highlightView.heightAnchor.constraint(equalTo: colorStackView.heightAnchor, multiplier: 1.1),
            highlightView.centerYAnchor.constraint(equalTo: colorStackView.centerYAnchor),
                ])
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        colorStackView.distribution = .fillEqually
        setUpColorButtonForStackView()

        // Do any additional setup after loading the view.
    }



}
