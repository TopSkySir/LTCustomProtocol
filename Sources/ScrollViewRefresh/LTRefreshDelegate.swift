//
//  LTRefreshDelegate.swift
//  LTTableViewDemo
//
//  Created by TopSky on 2018/3/16.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import Foundation

public protocol LTRefreshDelegate: NSObjectProtocol {
    func headerRefresh(scrollView: LTScrollViewRefreshProtocol?) -> Void
    func footerRefresh(scrollView: LTScrollViewRefreshProtocol?) -> Void
}
