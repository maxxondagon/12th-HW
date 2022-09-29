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
    
    private lazy var timerlabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.text = "0)))"
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerLabel
    }()
    
    private lazy var startButton: UIButton = {
        let timerButton = UIButton(type: .system)
        timerButton.setTitle("Start", for: .normal)
        timerButton.backgroundColor = .systemMint
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
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Actions
}

