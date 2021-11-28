//  ModalPresentationController.swift
//  Journey
//
//  Created by 윤예지 on 2021/07/07.
//

import UIKit

final class ModalPresentationController: UIPresentationController {
    let backgroundView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var check: Bool = false

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        backgroundView = UIView()
        backgroundView.backgroundColor = .darkGray
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0,
                               y: containerView!.frame.height*0.08),
               size: CGSize(width: containerView!.frame.width,
                            height: containerView!.frame.height * 0.92))
    }

    override func presentationTransitionWillBegin() {
        backgroundView.alpha = 0
        containerView!.addSubview(backgroundView)
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in self.backgroundView.alpha = 0.7},
            completion: nil
        )
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in self.backgroundView.alpha = 0},
            completion: { _ in self.backgroundView.removeFromSuperview()}
        )
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        if check {
            presentedView?.frame = frameOfPresentedViewInContainerView
            check.toggle()
        } else {
            presentedView?.frame = CGRect(
                origin: CGPoint(x: 0, y: containerView!.frame.height * 0.55),
                size: CGSize(width: containerView!.frame.width, height: containerView!.frame.height * 0.45)
            )
            check.toggle()
        }
        backgroundView.frame = containerView!.bounds
    }

    @objc func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
