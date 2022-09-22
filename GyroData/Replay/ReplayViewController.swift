//
//  ReplayViewController.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/21.
//

import UIKit
import SnapKit

class ReplayViewController: UIViewController {
    
    private var viewModel: ReplayViewModel = .init()
    private var timerState: Bool = false
    private var timer: Timer = Timer()
    private var endTime: Double = 3.0 //끝 타이머
    private var startTime: Double = 00.0{
        didSet {
            timerLabel.text = String(format: "%.1f", startTime)
        }
    }
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "다시보기"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let measureDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2020/09/07 HH:MM:nn"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "View"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.setupLayouts()
        self.btnAddTarget()
    }
    
    // MARK: - configure
    
    //    private func bind(_ viewModel: ReplayViewModel) {
    //        let input = ReplayViewModel.Input(
    //    }
    //
    private func setupLayouts() {
        self.view.addSubViews(
            self.navigationTitle,
            self.navigationBackButton,
            self.measureDateLabel,
            self.stateLabel,
            self.graphView,
            self.playButton,
            self.timerLabel
        )
        
        self.navigationBackButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.size.equalTo(30)
            $0.leading.equalToSuperview().offset(23)
        }
        
        self.navigationTitle.snp.makeConstraints {
            $0.top.equalTo(self.navigationBackButton.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        self.measureDateLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationTitle.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        self.stateLabel.snp.makeConstraints {
            $0.top.equalTo(self.measureDateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        self.graphView.snp.makeConstraints {
            $0.top.equalTo(self.stateLabel.snp.bottom).offset(30)
            $0.height.equalTo(200)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        self.playButton.snp.makeConstraints {
            $0.top.equalTo(self.graphView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        self.timerLabel.snp.makeConstraints {
            $0.top.equalTo(self.graphView.snp.bottom).offset(40)
            $0.leading.equalTo(self.playButton.snp.trailing).offset(50)
        }
    }
    
    private func btnAddTarget() {
        navigationBackButton.addTarget(self, action: #selector(backButtonTap(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonTap(_:)), for: .touchUpInside)
    }
    
    // MARK: - private func
    @objc func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func playButtonTap(_ sender: UIButton) {
        
        if timerState {
            timerState = false
            timer.invalidate()
        } else {
            timerState = true
            timerSetting()
        }
        guard let image = timerState ? UIImage(systemName: "stop.fill") : UIImage(systemName: "play.fill") else { return }
        self.playButton.setImage(image, for: .normal)
        
    }
    
    private func timerSetting() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(setTimer), userInfo: nil, repeats: true)
    }
    
    @objc func setTimer() {
        startTime += 0.1
        print("값 증가중", startTime)

        if startTime > endTime {
            timer.invalidate()
        }
    }
}



