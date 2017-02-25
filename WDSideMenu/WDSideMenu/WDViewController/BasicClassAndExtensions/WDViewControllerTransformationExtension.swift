//
//  WDViewControllerTransformationExtension.swift
//  WDSideMenu
//
//  Created by Vladimir Dinic on 2/25/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import Foundation
import UIKit

extension WDViewController
{
    final internal func transformMainContentView()
    {
        if !resizeMainContentView
        {
            return
        }
        if let mainContentView = self.mainView
        {
            var currentScaleFactor:CGFloat = 1.0
            var translationFactor:CGFloat = 0.0
            var t = CGAffineTransform.identity
            switch menuSide
            {
            case .LeftMenu:
                currentScaleFactor = 1.0 - fabs(self.sideMenuHorizontalOffset.constant)/self.sizeMenuWidth * scaleFactor
                translationFactor = (1.0 - currentScaleFactor) * Constants.SCREEN_WIDTH * 0.5
                t = t.translatedBy(x: -translationFactor, y: 0)
            case .RightMenu:
                currentScaleFactor = 1.0 - fabs(self.sideMenuHorizontalOffset.constant)/self.sizeMenuWidth * scaleFactor
                translationFactor = (1.0 - currentScaleFactor) * Constants.SCREEN_WIDTH * 0.5
                t = t.translatedBy(x: translationFactor, y: 0)
            }
            
            t = t.scaledBy(x: currentScaleFactor, y: currentScaleFactor)
            mainContentView.transform = t
        }
    }
    
    final func toggleSideMenu()
    {
        if !self.sideMenuVisible
        {
            switch menuSide
            {
            case .LeftMenu:
                self.sideMenuHorizontalOffset.constant = sizeMenuWidth
            case .RightMenu:
                self.sideMenuHorizontalOffset.constant = -sizeMenuWidth
            }
        }
        else
        {
            if let sideLeftOffset = self.sideMenuHorizontalOffset
            {
                sideLeftOffset.constant = 0
            }
            if let sideTopOffset = self.sideMenuVerticalOffset
            {
                sideTopOffset.constant = 0
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.transformMainContentView()
        }, completion: { finished in
            if finished
            {
                if let sideMenuDelegate = self.sideMenuDelegate, let mainContentDelegate = self.mainContentDelegate
                {
                    if !self.sideMenuVisible
                    {
                        mainContentDelegate.sideViewDidShow!()
                        sideMenuDelegate.sideViewDidShow!()
                    }
                    else
                    {
                        sideMenuDelegate.sideViewDidHide!()
                        mainContentDelegate.sideViewDidHide!()
                    }
                }
                switch self.menuSide
                {
                case .LeftMenu:
                    self.sideMenuVisible = self.sideMenuHorizontalOffset.constant != 0
                case .RightMenu:
                    self.sideMenuVisible = self.sideMenuHorizontalOffset.constant != 0
                }
                self.mainView?.isUserInteractionEnabled = !(self.resizeMainContentView && self.sideMenuVisible)
            }
        })
    }
}
