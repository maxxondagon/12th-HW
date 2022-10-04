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
        timerButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
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
            make.leading.trailing.equalToSuperview().inset(60)
            make.top.equalTo(timerlabel.snp.bottom).offset(40)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    
    @objc private func startButtonPressed() {
        isStarted = !isStarted
        if isStarted {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
            startButton.backgroundColor = .systemRed
            startButton.setTitle("Stop", for: .normal)
        } else {
            timer.invalidate()
            startButton.backgroundColor = .systemMint
            startButton.setTitle("Return", for: .normal)
        }
            }
    
    private func selectTypeOfTime() {
        if  isWorkingTime {
            timerlabel.text = "time to work"
            timer.invalidate()
            timerDuration = 10
            startButton.backgroundColor = .systemMint
            startButton.setTitle("Start work", for: .normal)
        } else {
            timerlabel.text = "time to rest"
            timer.invalidate()
            timerDuration = 5
            startButton.backgroundColor = .systemMint
            startButton.setTitle("Start rest", for: .normal)
        }
    }
    
    @objc private func timerTick() {
        timerDuration -= 1
        timerlabel.text = "\(timerDuration)"
        if timerDuration == 0 {
            isStarted = !isStarted
            isWorkingTime = !isWorkingTime
            selectTypeOfTime()
        }
    }
}

