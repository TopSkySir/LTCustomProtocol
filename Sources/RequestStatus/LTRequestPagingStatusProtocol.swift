//
//  LTRequestPagingStatusProtocol.swift
//  LTTableViewDemo
//
//  Created by TopSky on 2018/3/19.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import Foundation

fileprivate struct LTRequestPagingStatusKey {
    /**
     当前页码Key
     */
    static var currentPage = "currentPage"
    static var isRefreshHidden = "isRefreshHidden"
    static var isLoadMoreHidden = "isLoadMoreHidden"
    static var isPagingOver = "isPagingOver"
}

// MARK: - 分页协议
public protocol LTRequestPagingStatusProtocol: LTRequestStatusProtocol where DataSourceType: ExpressibleByArrayLiteral&RangeReplaceableCollection{

    /**
     分页
     */
    func pageSize() -> Int

    /**
     请求
     */
    func startRefreshRequest()
    func startLoadMoreRequest()


    /**
     结束刷新
     */
    func endRefresh()
    func endLoadMore()

    /**
     状态
     */

    //头部刷新隐藏状态
    func shouldCheckRefreshHidden() -> Bool
    func checkRefreshHidden() -> Bool
    func startRefreshHidden()
    func endRefreshHidden()

    //尾部加载隐藏状态
    func shouldCheckLoadMoreHidden() -> Bool
    func checkLoadMoreHidden() -> Bool
    func startLoadMoreHidden()
    func endLoadMoreHidden()

    //分页结束状态
    func shouldCheckPagingOver() -> Bool
    func checkPagingOver(_ totolCount: Int, _ addCount: Int) -> Bool
    func startPagingOver()
    func endPagingOver()

}

// MARK: - 请求
public extension LTRequestPagingStatusProtocol{

    /**
     开启 刷新请求
     */
    func startRefreshRequest() {
        cleanRequestStatus()
        setInitStatus()
        setCurrentPage(1)
        request()
    }

    /**
     开启 加载更多
     */
    func startLoadMoreRequest() {
        cleanRequestStatus()
        setCurrentPage(currentPage + 1)
        request()
    }
}

// MARK: - 数据绑定
public extension LTRequestPagingStatusProtocol {
    /**
     获取数据
     */
    func fetchDataSource(_ source: DataSourceType?) {
        cleanRequestStatus()
        if currentPage == 1 {
            refreshDataSource(source)
        } else {
            appendDataSource(source)
        }
        setResponseEmptyStatus()
        setRefreshHiddenStatus()
        setLoadMoreHiddenStatus()
        setPagingOverStatus(source)
        reloadData()
    }

    /**
     获取Error
     */
    func fetchError(_ err: DataErrorType?) {
        cleanRequestStatus()
        setResponseErrorStatus(err)
        setRefreshHiddenStatus()
        setLoadMoreHiddenStatus()
    }

    /**
     刷新数据源
     */
    fileprivate func refreshDataSource(_ source: DataSourceType?) {
        dataSource = source
    }


    /**
     拼接数据源
     */
    fileprivate func appendDataSource(_ source: DataSourceType?) {
        guard let appendSource = source else {
            return
        }

        guard let originSource = dataSource else {
            dataSource = appendSource
            return
        }
        dataSource = originSource + appendSource
    }

}


// MARK: - 页码
public extension LTRequestPagingStatusProtocol {

    /**
     页码大小
     */
    func pageSize() -> Int {
        return 10
    }

    /**
     当前页码
     */
    var currentPage: Int {
        return getAssociateIntValue(&LTRequestPagingStatusKey.currentPage, defaultValue: 1)

    }

    /**
     是否 是头部刷新
     */
    fileprivate var isRefreshing: Bool {
        return currentPage == 1
    }

    /**
     设置当前页码
     */
    fileprivate func setCurrentPage(_ newValue: Int) {
        setAssociateIntValue(&LTRequestPagingStatusKey.currentPage, newValue)
    }
}

// MARK: - 状态管理
public extension LTRequestPagingStatusProtocol {
    /**
     清除其他状态
     */
    fileprivate func cleanRequestStatus() {
        cleanInitStatus()
        cleanResponseEmptyStatus()
        cleanResponseErrorStatus()
        cleanRefreshHiddenStatus()
        cleanLoadMoreHiddenStatus()
        cleanPagingOverStatus()
        cleanRefreshingOrLoading()
    }

    /**
     清除刷新或加载状态
     */
    fileprivate func cleanRefreshingOrLoading() {
        if isRefreshing {
            endRefresh()
        } else {
            endLoadMore()
        }
    }
}

// MARK: - 头部刷新隐藏状态
public extension LTRequestPagingStatusProtocol {

    /**
     是否检测 头部刷新隐藏状态
     */
    func shouldCheckRefreshHidden() -> Bool {
        return true
    }

    /**
     检测 头部刷新隐藏状态
     */
    func checkRefreshHidden() -> Bool {
        return isResponseEmpty || isResponseError
    }

    /**
     开启 头部刷新隐藏状态
     */
    func startRefreshHidden() {

    }

    /**
     关闭 头部刷新隐藏状态
     */
    func endRefreshHidden() {

    }

    /**
     设置 头部刷新隐藏状态
     */
    fileprivate func setRefreshHiddenStatus() {
        if shouldCheckRefreshHidden() && checkRefreshHidden() {
            setIsRefreshHidden(true)
            startRefreshHidden()
        }
    }

    /**
     清除 头部刷新隐藏状态
     */
    fileprivate func cleanRefreshHiddenStatus() {
        if isRefreshHidden {
            endRefreshHidden()
            setIsRefreshHidden(false)
        }
    }

    /**
     存储
     */
    var isRefreshHidden: Bool {
        guard shouldCheckRefreshHidden() else {
            return false
        }
        return getAssociateBoolValue(&LTRequestPagingStatusKey.isRefreshHidden)
    }

    fileprivate func setIsRefreshHidden(_ newValue: Bool) {
        setAssociateBoolValue(&LTRequestPagingStatusKey.isRefreshHidden, newValue)
    }
}

// MARK: - 尾部加载隐藏状态
public extension LTRequestPagingStatusProtocol {

    /**
     是否检测 尾部加载隐藏状态
     */
    func shouldCheckLoadMoreHidden() -> Bool {
        return true
    }

    /**
     检测 尾部加载隐藏状态
     */
    func checkLoadMoreHidden() -> Bool {
        return isResponseEmpty || isResponseError
    }

    /**
     开启 尾部加载隐藏状态
     */
    func startLoadMoreHidden() {

    }

    /**
     关闭 尾部加载隐藏状态
     */
    func endLoadMoreHidden() {

    }

    /**
     设置 尾部加载隐藏状态
     */
    fileprivate func setLoadMoreHiddenStatus() {
        if shouldCheckLoadMoreHidden() && checkLoadMoreHidden() {
            setIsLoadMoreHidden(true)
            startLoadMoreHidden()
        }
    }

    /**
     清除 尾部加载隐藏状态
     */
    fileprivate func cleanLoadMoreHiddenStatus() {
        if isLoadMoreHidden {
            endLoadMoreHidden()
            setIsLoadMoreHidden(false)
        }
    }

    /**
     存储
     */
    var isLoadMoreHidden: Bool {
        guard shouldCheckLoadMoreHidden() else {
            return false
        }
        return getAssociateBoolValue(&LTRequestPagingStatusKey.isLoadMoreHidden)
    }

    fileprivate func setIsLoadMoreHidden(_ newValue: Bool) {
        setAssociateBoolValue(&LTRequestPagingStatusKey.isLoadMoreHidden, newValue)
    }

}

// MARK: - 页尾状态
public extension LTRequestPagingStatusProtocol {

    /**
     是否检测 页尾状态
     */
    func shouldCheckPagingOver() -> Bool {
        return true
    }

    /**
     检测 页尾状态
     */
    func checkPagingOver(_ totolCount: Int, _ addCount: Int) -> Bool {
        return addCount < pageSize()
    }


    /**
     开启 页尾状态
     */
    func startPagingOver() {

    }

    /**
     关闭 页尾状态
     */
    func endPagingOver() {

    }

    /**
     设置 页尾状态
     */
    fileprivate func setPagingOverStatus(_ source: DataSourceType?) {
        guard shouldCheckPagingOver() else {
            return
        }
        let totalCount = dataSource?.count ?? 0
        let addCount = source?.count ?? 0
        guard checkPagingOver(Int(totalCount), Int(addCount)) else {
            return
        }
        setIsPagingOverKey(true)
        startPagingOver()
    }

    /**
     清除 页尾状态
     */
    fileprivate func cleanPagingOverStatus() {
        if isPagingOver {
            endPagingOver()
            setIsPagingOverKey(false)
        }
    }

    /**
     存储
     */
    var isPagingOver: Bool {
        guard shouldCheckPagingOver() else {
            return false
        }
        return getAssociateBoolValue(&LTRequestPagingStatusKey.isPagingOver)
    }

    fileprivate func setIsPagingOverKey(_ newValue: Bool) {
        setAssociateBoolValue(&LTRequestPagingStatusKey.isPagingOver, newValue)
    }

}


// MARK: - 关联属性
public extension LTRequestPagingStatusProtocol {
    /**
     set Int 关联属性
     */
    fileprivate func setAssociateIntValue(_ key: UnsafeRawPointer, _ newValue: Int) {
        objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_ASSIGN)
    }

    /**
     get Int 关联属性
     */
    fileprivate func getAssociateIntValue(_ key: UnsafeRawPointer, defaultValue: Int = 0) -> Int {
        return objc_getAssociatedObject(self, key) as? Int ?? defaultValue
    }
}
