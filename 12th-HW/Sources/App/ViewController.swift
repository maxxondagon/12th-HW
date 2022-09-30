//
//  ViewController.swift
//  12th-HW
//
//  Created by Максим Солобоев on 29.09.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Outlets
    
    var timer = Timer()
    var timerDuration = 10
    var isStarted = false
    var isWorkingTime = true
    
    private lazy var timerlabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.text = "\(timerDuration)"
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerLabel
    }()
    
    private lazy var startButton: UIButton = {
        let timerButton = UIButton(type: .system)
        timerButton.setTitle("Start", for: .normal)
        timerButton.backgroundColor = .systemMint
        timerButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        timerButton.translatesAutoresizingMaskIntoConstraints = false
        return timerButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup
    
    private func setupHierarchy() {
        view.addSubview(timerlabel)
        view.addSubview(startButton)
    }
    
    private func setupLayout() {
        timerlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(timerlabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    // MARK: - Actions
    
    @objc private func buttonPressed() {
        isStarted = !isStarted
        if isStarted {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
        }
            }
 
    @objc private func timerTick() {
        timerDuration -= 1
        timerlabel.text = "\(timerDuration)"
        if timerDuration == 0 {
            isStarted = !isStarted
            isWorkingTime = !isWorkingTime
            if !isWorkingTime {
                timerlabel.text = "time to rest"
                timer.invalidate()
                timerDuration = 5
            } else {
                timerlabel.text = "time to work"
                timer.invalidate()
                timerDuration = 10
            }
        }
    }
  
}

