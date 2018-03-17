//
//  LTScrollViewRefreshProtocol.swift
//  LTTableViewDemo
//
//  Created by TopSky on 2018/3/16.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh

public protocol LTScrollViewRefreshProtocol where Self: UIScrollView {

    /**
     顶部刷新组件type
     */
    var refreshHeaderType: MJRefreshHeader.Type {get}

    /**
     底部刷新组件type
     */
    var refreshFooterType: MJRefreshFooter.Type {get}

    /**
     刷新代理
     */
    weak var refreshDelegate: LTRefreshDelegate? {set get}

    /**
     顶部刷新Closure
     */
    var refreshHeaderClosure: ((_ tableView: LTScrollViewRefreshProtocol?) -> Void)? {set get}

    /**
     底部刷新Closure
     */
    var refreshFooterClosure: ((_ tableView: LTScrollViewRefreshProtocol?) -> Void)? {set get}

}

public extension LTScrollViewRefreshProtocol {

    /**
     协议检测
     */
    func checkProtocol(_ target: Any?){
        guard let resultTarget = target  else {
            return
        }

        if let result = self as? UITableView {
            result.delegate = resultTarget as? UITableViewDelegate
            result.dataSource = resultTarget as? UITableViewDataSource
        }

        if let result = self as? UICollectionView {
            result.delegate = resultTarget as? UICollectionViewDelegate
            result.dataSource = resultTarget as? UICollectionViewDataSource
        }
        var resultSelf = self
        resultSelf.refreshDelegate = resultTarget as? LTRefreshDelegate
    }


    /**
     顶部底部刷新 是否隐藏
     */
    func setRefreshHidden(_ isHidden: Bool) {
        setRefreshHeaderHidden(isHidden)
        setRefreshFooterHidden(isHidden)
    }

    /**
     顶部刷新 是否隐藏
     */
    func setRefreshHeaderHidden(_ isHidden: Bool) {
        mj_header.isHidden = isHidden
    }

    /**
     底部刷新 是否隐藏
     */
    func setRefreshFooterHidden(_ isHidden: Bool) {
        mj_footer.isHidden = isHidden
    }
}


// MARK: - Header Footer
public extension LTScrollViewRefreshProtocol {

    /**
     获取RefreshFooter
     */
    func getRrefreshFooter() -> MJRefreshFooter? {
        let footer = refreshFooterType.init { [weak self] () -> Void in
            if let resultDelegate = self?.refreshDelegate {
                resultDelegate.footerRefresh(scrollView: self)
            } else if let resultClosure = self?.refreshFooterClosure {
                resultClosure(self)
            }
        }
        footer?.isAutomaticallyChangeAlpha = true
        return footer
    }


    /**
     获取RefreshHeader
     */
    func getRefreshHeader() -> MJRefreshHeader? {
        let header = refreshHeaderType.init { [weak self] () -> Void in
            if let resultDelegate = self?.refreshDelegate {
                resultDelegate.headerRefresh(scrollView: self)
            } else if let resultClosure = self?.refreshHeaderClosure {
                resultClosure(self)
            }
        }
        header?.isAutomaticallyChangeAlpha = true
        return header
    }

    /**
     添加Refresh
     */
    func addRefresh() {
        mj_header = getRefreshHeader()
        mj_footer = getRrefreshFooter()
    }

    /**
     移除Refresh
     */
    func removeRefresh() {
        mj_header = nil
        mj_footer = nil
    }
}


// MARK: - Refresh Status
public extension LTScrollViewRefreshProtocol {

    /**
     开始刷新头部
     */
    func startRefreshHeader() {
        mj_header.beginRefreshing()
    }

    /**
     停止刷新头部
     */
    func endRefreshHeader() {
        mj_header.endRefreshing()
    }

    /**
     开始刷新底部
     */
    func startRefreshFooter() {
        mj_footer.beginRefreshing()
    }

    /**
     停止刷新底部
     */
    func endRefreshFooter(isEnd: Bool = false) -> Void {
        if isEnd {
            mj_footer.endRefreshingWithNoMoreData()
        } else {
            mj_footer.endRefreshing()
        }
    }

    /**
     重置底部
     */
    func resetRefreshFooter() {
        mj_footer.resetNoMoreData()
        mj_footer.isHidden = false
    }


    /**
     停止刷新头部和底部
     */
    func endRefresh() {
        endRefreshHeader()
        endRefreshFooter()
    }

}


