//
//  LTRequestStatusProtocol.swift
//  LTTableViewDemo
//
//  Created by TopSky on 2018/3/19.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import Foundation


fileprivate struct LTRequestStatusKey {
    /**
     初始化请求Key
     */
    static var isInitRequest = "isInitRequest"
    static var isResponseEmpty = "isResponseEmpty"
    static var isResponseError = "isResponseError"
}

public protocol LTRequestStatusProtocol: class {

    associatedtype DataSourceType
    associatedtype DataErrorType
    var dataSource: DataSourceType? {set get}

    /**
     开始请求
     */
    func startRequest()
    func request()

    /**
     获取数据
     */
    func fetchDataSource(_ source: DataSourceType?)
    func fetchError(_ err: DataErrorType?)
    func reloadData()

    /**
     状态判断
     */

    //初始化
    func shouldCheckInitRequest() -> Bool
    func checkInitRequest() -> Bool
    func startInitRequest()
    func endInitRequest()

    //空状态
    func shouldCheckResponseEmpty() -> Bool
    func checkResponseEmpty() -> Bool
    func startResponseEmpty()
    func endResponseEmpty()

    //错误状态
    func shouldCheckResponseError() -> Bool
    func checkResponseError(_ err: DataErrorType?) -> Bool
    func startResponseError(_ err: DataErrorType?)
    func endResponseError()
}

// MARK: - 请求
public extension LTRequestStatusProtocol {

    /**
     开始请求
     */
    func startRequest() {
        cleanRequestStatus()
        setInitStatus()
        request()
    }
}

// MARK: - 数据绑定
public extension LTRequestStatusProtocol {

    /**
     获取数据
     */
    func fetchDataSource(_ source: DataSourceType?) {
        cleanRequestStatus()
        dataSource = source
        setResponseEmptyStatus()
        reloadData()
    }

    /**
     获取Error
     */
    func fetchError(_ err: DataErrorType?) {
        cleanRequestStatus()
        setResponseErrorStatus(err)
    }

}


// MARK: - 状态管理
public extension LTRequestStatusProtocol {
    /**
     清除其他状态
     */
    fileprivate func cleanRequestStatus() {
        cleanInitStatus()
        cleanResponseEmptyStatus()
        cleanResponseErrorStatus()
    }
}


// MARK: - 初始化状态
public extension LTRequestStatusProtocol {



    /**
     是否检查 初始化状态
     */
    func shouldCheckInitRequest() -> Bool {
        return true
    }

    /**
     检查 初始化状态
     */
    func checkInitRequest() -> Bool {
        return isInitRequest || dataSource == nil
    }

    /**
     开启 初始化状态
     */
    func startInitRequest() {

    }

    /**
     结束 初始化状态
     */
    func endInitRequest() {

    }

    /**
     设置 初始化状态
     */
    internal func setInitStatus() {
        if shouldCheckInitRequest() && checkInitRequest() {
            setIsInitRequest(true)
            startInitRequest()
        }
    }

    /**
     清除 初始化状态
     */
    internal func cleanInitStatus() {
        if isRealInitRequest {
            endInitRequest()
            setIsInitRequest(false)
        }
    }

    /**
     存储
     */

    /**
     是否是初始化请求
     */
    var isInitRequest: Bool {
        guard shouldCheckInitRequest() else {
            return false
        }

        return getAssociateBoolValue(&LTRequestStatusKey.isInitRequest, defaultValue: true)
    }

    /**
     是否是初始化请求 未添加默认值的
     */
    fileprivate var isRealInitRequest: Bool {
        return getAssociateBoolValue(&LTRequestStatusKey.isInitRequest, defaultValue: false)
    }

    /**
     设置 是否是初始化请求
     */
    fileprivate func setIsInitRequest(_ newValue: Bool) {
        setAssociateBoolValue(&LTRequestStatusKey.isInitRequest, newValue)
    }
}


// MARK: - 空状态
public extension LTRequestStatusProtocol {

    /**
     是否检查 空状态
     */
    func shouldCheckResponseEmpty() -> Bool {
        return true
    }

    /**
     检查 空状态
     */
    func checkResponseEmpty() -> Bool {
        return dataSource == nil
    }

    /**
     开启 空状态
     */
    func startResponseEmpty() {

    }

    /**
     结束 空状态
     */
    func endResponseEmpty() {

    }

    /**
     设置 是否是空状态
     */
    internal func setResponseEmptyStatus() {
        if shouldCheckResponseEmpty() && checkResponseEmpty() {
            setIsResponseEmpty(true)
            startResponseEmpty()
        }
    }


    /**
     清除 空状态
     */
    internal func cleanResponseEmptyStatus() {
        if isResponseEmpty {
            endResponseEmpty()
            setIsResponseEmpty(false)
        }
    }


    /**
     存储
     */
    var isResponseEmpty: Bool {
        guard shouldCheckResponseEmpty() else {
            return false
        }
        return getAssociateBoolValue(&LTRequestStatusKey.isResponseEmpty)
    }

    fileprivate func setIsResponseEmpty(_ newValue: Bool) {
        setAssociateBoolValue(&LTRequestStatusKey.isResponseEmpty, newValue)
    }

}


// MARK: - 错误状态
public extension LTRequestStatusProtocol {

    /**
     是否检测 错误状态
     */
    func shouldCheckResponseError() -> Bool {
        return true
    }

    /**
     检测 错误状态
     */
    func checkResponseError(_ err: DataErrorType?) -> Bool {
        return true
    }

    /**
     开启 错误状态
     */
    func startResponseError(_ err: DataErrorType?) {

    }

    /**
     关闭 错误状态
     */
    func endResponseError() {

    }

    /**
     设置 错误状态
     */
    internal func setResponseErrorStatus(_ err: DataErrorType?) {
        if shouldCheckResponseError() && checkResponseError(err) {
            setIsResponseError(true)
            startResponseError(err)
        }
    }

    /**
     清除 错误状态
     */
    internal func cleanResponseErrorStatus() {
        if isResponseError {
            endResponseError()
            setIsResponseError(false)
        }
    }

    /**
     存储
     */
    var isResponseError: Bool {
        guard shouldCheckResponseError() else {
            return false
        }
        return getAssociateBoolValue(&LTRequestStatusKey.isResponseError)

    }

    fileprivate func setIsResponseError(_ newValue: Bool) {
        setAssociateBoolValue(&LTRequestStatusKey.isResponseError, newValue)
    }
}


// MARK: - 关联属性
public extension LTRequestStatusProtocol {

    /**
     set Bool 关联属性
     */
    func setAssociateBoolValue(_ key: UnsafeRawPointer, _ newValue: Bool) {
        objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_ASSIGN)
    }



    /**
     get Bool 关联属性
     */
    func getAssociateBoolValue(_ key: UnsafeRawPointer, defaultValue: Bool = false) -> Bool {
        return objc_getAssociatedObject(self, key) as? Bool ?? defaultValue
    }

}

