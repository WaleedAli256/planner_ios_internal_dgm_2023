////
////  CustomViewWithGesture.swift
////  ToDoApp
////
////  Created by mac on 26/06/2023.
////
//
//import Foundation
//
//import UIKit
//
//class BottomView: UIView {
//    private var defaultHeight: CGFloat = 400.0
//    private var expandedHeight: CGFloat = UIScreen.main.bounds.height
//
//    private var isExpanded = false {
//        didSet {
//            updateViewHeight()
//        }
//    }
//
//    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        return gestureRecognizer
//    }()
//
//    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        return gestureRecognizer
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupGestureRecognizers()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupGestureRecognizers()
//    }
//
//    private func setupGestureRecognizers() {
//        addGestureRecognizer(tapGestureRecognizer)
//        addGestureRecognizer(panGestureRecognizer)
//    }
//
//    private func updateViewHeight() {
//        let newHeight = isExpanded ? expandedHeight : defaultHeight
//        frame.size.height = newHeight
//        superview?.layoutIfNeeded()
//    }
//
//    @objc private func handleTap() {
//        isExpanded = !isExpanded
//    }
//
//    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//        let translation = gestureRecognizer.translation(in: self)
//
//        switch gestureRecognizer.state {
//        case .changed:
//            let newHeight = max(defaultHeight + translation.y, defaultHeight)
//            frame.size.height = newHeight
//            superview?.layoutIfNeeded()
//        case .ended:
//            let shouldExpand = translation.y < -50.0 // Adjust the threshold as per your preference
//            isExpanded = shouldExpand
//        default:
//            break
//        }
//    }
//}
