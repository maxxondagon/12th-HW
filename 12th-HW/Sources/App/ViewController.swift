//
//  ViewController.swift
//  12th-HW
//
//  Created by Максим Солобоев on 29.09.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var timer = Timer()
    var timerDuration = 10.00
    var isStarted = false
    var isWorkingTime = true
    let shapeLayer = CAShapeLayer()
    let roundLayer = CAShapeLayer()
    
    // MARK: - Outlets
    
    private lazy var timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.text = String(Int(timerDuration))
        timerLabel.font = UIFont.systemFont(ofSize: 25)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerLabel
    }()
    
    private lazy var playButtonIcon: UIImageView = {
        let buttonIconPlay = UIImage(systemName: "play")
        let playButtonView = UIImageView(image: buttonIconPlay)
        playButtonView.tintColor = .black
        playButtonView.isHidden = false
        playButtonView.translatesAutoresizingMaskIntoConstraints = false
        return playButtonView
    }()
    
    private lazy var stopButtonIcon: UIImageView = {
        let buttonIconStop = UIImage(systemName: "pause")
        let stopButtonView = UIImageView(image: buttonIconStop)
        stopButtonView.tintColor = .black
        stopButtonView.isHidden = true
        stopButtonView.translatesAutoresizingMaskIntoConstraints = false
        return stopButtonView
    }()
    
    private lazy var startButton: UIButton = {
        let timerButton = UIButton(type: .system)
        timerButton.setTitle("Start", for: .normal)
        timerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        timerButton.setTitleColor(.black, for: .normal)
        timerButton.backgroundColor = .systemOrange.withAlphaComponent(0.8)
        timerButton.layer.cornerRadius = 25
        timerButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        timerButton.translatesAutoresizingMaskIntoConstraints = false
        return timerButton
    }()
    
    private lazy var progressCirсleView: UIView = {
        let progressView = UIView()
        
        let circularPath = UIBezierPath(
            arcCenter: progressView.center,
            radius: 100,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true)
        
        roundLayer.path = circularPath.cgPath
        roundLayer.lineCap = .round
        roundLayer.lineWidth = 10
        roundLayer.fillColor = UIColor.clear.cgColor
        roundLayer.strokeColor = UIColor.systemOrange.withAlphaComponent(0.4).cgColor
        roundLayer.strokeEnd = 1
        progressView.layer.addSublayer(roundLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.systemOrange.cgColor
        shapeLayer.strokeEnd = 0
        progressView.layer.addSublayer(shapeLayer)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
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
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        startButton.addSubview(playButtonIcon)
        startButton.addSubview(stopButtonIcon)
        view.addSubview(progressCirсleView)
    }
    
    private func setupLayout() {
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerLabel.snp.bottom).offset(120)
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        playButtonIcon.snp.makeConstraints { make in
            make.leading.equalTo(startButton.snp.leading).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(26)
            make.bottom.equalTo(startButton.snp.bottom).inset(15)
        }
        
        stopButtonIcon.snp.makeConstraints { make in
            make.leading.equalTo(startButton.snp.leading).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.bottom.equalTo(startButton.snp.bottom).inset(15)
        }
        
        progressCirсleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(0)
        }
    }
    
    // MARK: - Private funtions
    
    private func changeButtonWhenStarting() {
        startButton.backgroundColor = .systemRed
        startButton.setTitle("Pause", for: .normal)
        playButtonIcon.isHidden = !playButtonIcon.isHidden
        stopButtonIcon.isHidden = !stopButtonIcon.isHidden
    }
    
    private func changeButtonWhenPaused() {
        startButton.setTitle("Resume", for: .normal)
        playButtonIcon.isHidden = !playButtonIcon.isHidden
        stopButtonIcon.isHidden = !stopButtonIcon.isHidden
        
        // Setup button color for type of work
        if !isWorkingTime {
            startButton.backgroundColor = .systemMint
        } else {
            startButton.backgroundColor = .systemOrange
        }
    }
    
    private func startAnimation() {
        if let keys = shapeLayer.animationKeys(), keys.contains("basicAnimation") {
            let pausedTime = shapeLayer.timeOffset
            shapeLayer.speed = 1.0
            shapeLayer.timeOffset = 0.0
            shapeLayer.beginTime = 0.0
            let timeAfterPause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            shapeLayer.beginTime = timeAfterPause
            return
        }
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(timerDuration)
        basicAnimation.fillMode = .forwards
        basicAnimation.speed = 1.0
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    private func stopAnimation() {
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0
        shapeLayer.timeOffset = pausedTime
    }
    
    private func selectTypeOfTime() {
        if  isWorkingTime {
            timerLabel.text = "time to work"
            timer.invalidate()
            timerDuration = 10.0
            playButtonIcon.isHidden = !playButtonIcon.isHidden
            stopButtonIcon.isHidden = !stopButtonIcon.isHidden
            startButton.backgroundColor = .systemOrange.withAlphaComponent(0.8)
            startButton.setTitle("Start work", for: .normal)
            roundLayer.strokeColor = UIColor.systemOrange.withAlphaComponent(0.4).cgColor
            shapeLayer.strokeColor = UIColor.systemOrange.cgColor
        } else {
            timerLabel.text = "time to rest"
            timer.invalidate()
            timerDuration = 5.0
            startButton.backgroundColor = .systemMint.withAlphaComponent(0.8)
            startButton.setTitle("Start rest", for: .normal)
            playButtonIcon.isHidden = !playButtonIcon.isHidden
            stopButtonIcon.isHidden = !stopButtonIcon.isHidden
            roundLayer.strokeColor = UIColor.systemMint.withAlphaComponent(0.4).cgColor
            shapeLayer.strokeColor = UIColor.systemMint.cgColor
        }
    }
    
    // MARK: - Actions
    
    @objc private func startButtonPressed() {
        isStarted = !isStarted
        if isStarted {
            timer = Timer.scheduledTimer(
                timeInterval: 0.01,
                target: self,
                selector: #selector(timerTick),
                userInfo: nil,
                repeats: true)
            changeButtonWhenStarting()
            startAnimation()
        } else {
            timer.invalidate()
            changeButtonWhenPaused()
            stopAnimation()
        }
    }
    
    @objc private func timerTick() {
        timerDuration -= 0.01
        
        // Change time format for last second
        if timerDuration < 1.0 {
            timerLabel.text = String(format: "%.1f", timerDuration)
        } else {
            timerLabel.text = String(format: "%.0f", timerDuration)
        }
        
        if timerDuration <= 0.0 {
            isStarted = !isStarted
            isWorkingTime = !isWorkingTime
            selectTypeOfTime()
        }
    }
}

