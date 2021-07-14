//
//  CLCustomTransitionPushController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit


//MARK: - JmoVxia---类-属性
class CLCustomTransitionPresentController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = bubbleDelegate
        modalPresentationStyle = .custom
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        CLLog("==================")
    }
    private lazy var bottomButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 30)
        view.setTitle("+", for: .normal)
        view.setTitle("+", for: .selected)
        view.setTitle("+", for: .highlighted)
        view.setTitleColor(.hex("#FF6666"), for: .normal)
        view.setTitleColor(.hex("#FF6666"), for: .selected)
        view.setTitleColor(.hex("#FF6666"), for: .highlighted)
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        return view
    }()
    lazy var bubbleDelegate: CLCustomTransitionDelegate = {
        let delegate = CLCustomTransitionDelegate {[weak self] in
            guard let self = self else { return (.zero , .white) }
            return (self.bottomButton.center, .hex("#FF6666"))
        } endCallback: {[weak self] in
            guard let self = self else { return (.zero , .white) }
            return (self.bottomButton.center, .hex("#FF6666"))
        }
        delegate.interactiveTransition.attach(to: self)
        return delegate
    }()
}
//MARK: - JmoVxia---生命周期
extension CLCustomTransitionPresentController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLCustomTransitionPresentController {
    func initUI() {
        transitioningDelegate = bubbleDelegate
        view.backgroundColor = .hex("#FF6666")
        view.addSubview(bottomButton)
    }
    func makeConstraints() {
        bottomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-safeAreaEdgeInsets.bottom - 40)
            make.size.equalTo(60)
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLCustomTransitionPresentController {
    func initData() {
    }
}
//MARK: - JmoVxia---override
extension CLCustomTransitionPresentController {
}
//MARK: - JmoVxia---objc
@objc private extension CLCustomTransitionPresentController {
    func buttonAction() {
        dismiss(animated: true)
        bubbleDelegate.interactiveTransition.finish()
    }
}
//MARK: - JmoVxia---私有方法
private extension CLCustomTransitionPresentController {
}
//MARK: - JmoVxia---公共方法
extension CLCustomTransitionPresentController {
}
