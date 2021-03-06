//
//  AlertDetailCellView.swift
//  iSEPTA
//
//  Created by Mark Broski on 10/5/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit
import SeptaRest

class AlertDetailCellView: UIView, AlertState_GenericAlertDetailsWatcherDelegate {
    var openState: Bool = false

    var sectionNumber: Int!
    weak var delegate: AlertDetailCellDelegate?

    @IBOutlet weak var shadowView: UIView! {
        didSet {
            styleWhiteViews([shadowView])
            shadowView.layer.cornerRadius = 4
        }
    }

    var pinkAlertHeaderView: PinkAlertHeaderView!
    @IBOutlet weak var pinkWrapperView: UIView! {
        didSet {
            pinkAlertHeaderView = pinkWrapperView.awakeInsertAndPinSubview(nibName: "PinkAlertHeaderView")
            pinkAlertHeaderView.actionButton.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        }
    }

    var alertImage: UIImageView { return pinkAlertHeaderView.alertImageView }

    var disabledAdvisoryLabel: UILabel { return pinkAlertHeaderView.disabledAdvisoryLabel }

    var advisoryLabel: UILabel { return pinkAlertHeaderView.advisoryLabel }

    var genericAlertDetailsWatcher: AlertState_GenericAlertDetailsWatcher?

    @IBOutlet weak var content: UIView! {
        didSet {
            styleWhiteViews([content])
            content.layer.cornerRadius = 4
            content.layer.masksToBounds = true
        }
    }

    var isGenericAlert: Bool = false {

        didSet {
            pinkAlertHeaderView.isGenericAlert = isGenericAlert

            textView.isScrollEnabled = isGenericAlert
            if isGenericAlert {
                genericAlertDetailsWatcher = AlertState_GenericAlertDetailsWatcher()
                genericAlertDetailsWatcher?.delegate = self
            }
        }
    }

    func alertState_GenericAlertDetailsUpdated(alertDetails: [AlertDetails_Alert]) {
        let message = AlertDetailsViewModel.renderMessage(alertDetails: alertDetails) { return $0.message }
        textView.attributedText = message
    }

    @IBOutlet weak var textViewHeightContraints: NSLayoutConstraint! {
        didSet {
            textViewHeightContraints.constant = 0
        }
    }

    @IBOutlet weak var textView: UITextView!

    @objc @IBAction func actionButtonTapped(_: Any) {
        delegate?.didTapButton(sectionNumber: sectionNumber)
        calculateFittingSize()
        delegate?.constraintsChanged(sectionNumber: sectionNumber)
    }

    func calculateFittingSize() {

        if !openState {
            let windowWidth = UIScreen.main.bounds.width - 30
            let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: windowWidth, height: CGFloat(MAXFLOAT)))
            let heightOfText = sizeThatFitsTextView.height

            textViewHeightContraints.constant = heightOfText
            pinkAlertHeaderView.actionButton.isOpen = true
            openState = true
        } else {
            textViewHeightContraints.constant = 0
            pinkAlertHeaderView.actionButton.isOpen = false
            openState = false
        }
        setNeedsLayout()
    }

    var fittingHeight: CGFloat {
        if pinkAlertHeaderView.actionButton.isOpen {
            let windowWidth = UIScreen.main.bounds.width - 50
            let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: windowWidth, height: CGFloat(MAXFLOAT)))
            let heightOfText = sizeThatFitsTextView.height
            return heightOfText + 75
        } else {
            return 75
        }
    }

    func setEnabled(_ enabled: Bool) {
        pinkAlertHeaderView.enabled = enabled
    }

    func styleWhiteViews(_ views: [UIView]) {
        for view in views {
            view.backgroundColor = UIColor.white
        }
    }

    func styleClearViews(_ views: [UIView]) {
        for view in views {
            view.backgroundColor = UIColor.clear
        }
    }
}
