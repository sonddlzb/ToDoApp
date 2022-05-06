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
    func colorViewController(setBackgroundColorTo newColor: UIColor)
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
        switch sender
        {
        case colorButtons[0]: selectedIndex = 0
        case colorButtons[1]: selectedIndex = 1
        case colorButtons[2]: selectedIndex = 2
        case colorButtons[3]: selectedIndex = 3
        case colorButtons[4]: selectedIndex = 4
        case colorButtons[5]: selectedIndex = 5
        case colorButtons[6]: selectedIndex = 6
        case colorButtons[7]: selectedIndex = 7
        case colorButtons[8]: selectedIndex = 8
        default: print("Wrong index")
        }
        delegate?.colorViewController(setBackgroundColorTo: sender.backgroundColor!)
    }

    func setUpColorButtonForStackView()
    {
        for(index,value) in colors.enumerated()
        {
            let newColorButton = UIButton()
            newColorButton.backgroundColor = colors[index]
            newColorButton.sizeToFit()
            newColorButton.layer.masksToBounds = true
            colorStackView.addArrangedSubview(newColorButton)
            newColorButton.layer.cornerRadius = min(newColorButton.frame.height, newColorButton.frame.width) / 2
            print("add target to button \(index)")
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
