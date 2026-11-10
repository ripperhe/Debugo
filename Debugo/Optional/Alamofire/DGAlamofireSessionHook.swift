//
//  DGAlamofireSessionHook.swift
//  Debugo
//
//  把本文件加入 App Target（不要编进 Debugo Pod）。
//  在已集成 Alamofire 的工程中，它会监听官方 EventMonitor 发出的通知，
//  并把已通过 `DGAlamofirePlugin.monitorSession(_:)` 注册的 Session 的请求写入 Alamofire 插件列表。
//  默认创建的 Session 已包含 AlamofireNotifications，无需替换现有 Session。
//

#if canImport(Alamofire) && canImport(Debugo)

import Foundation
import Alamofire
import Debugo

@objc(DGAlamofireSessionHook)
public final class DGAlamofireSessionHook: NSObject {
    @objc public static func startObserving() {
        shared.start()
    }

    private static let shared = DGAlamofireSessionHook()
    private var started = false
    private let lock = NSLock()

    private func start() {
        lock.lock()
        defer { lock.unlock() }
        guard !started else { return }
        started = true
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(requestDidResume(_:)), name: Request.didResumeNotification, object: nil)
        center.addObserver(self, selector: #selector(requestDidFinish(_:)), name: Request.didFinishNotification, object: nil)
    }

    private func monitoredRequest(from notification: Notification) -> Request? {
        guard let request = notification.request else { return nil }
        guard let session = request.delegate as AnyObject? else { return nil }
        guard DGAlamofireCenter.shared().isMonitoringSession(session) else { return nil }
        return request
    }

    @objc private func requestDidResume(_ notification: Notification) {
        guard let request = monitoredRequest(from: notification) else { return }
        DGAlamofireCenter.shared().upsertRecord(DGAlamofireRecordBuilder.makeRecord(from: request, finished: false))
    }

    @objc private func requestDidFinish(_ notification: Notification) {
        guard let request = monitoredRequest(from: notification) else { return }
        DGAlamofireCenter.shared().upsertRecord(DGAlamofireRecordBuilder.makeRecord(from: request, finished: true))
    }
}

/// 可选：在创建 `Session` 时加入，例如
/// `Session(eventMonitors: [AlamofireNotifications(), DGAlamofireEventMonitor()])`。
/// 加入后会自动把该 Session 注册到「Alamofire请求」页。
/// 已有 Session 仍优先用 `DGAlamofirePlugin.monitorSession(_:)`，不必重建 Session。
public final class DGAlamofireEventMonitor: EventMonitor {
    public let queue = DispatchQueue(label: "com.ripperhe.debugo.alamofire", qos: .utility)

    public init() {}

    public func requestDidResume(_ request: Request) {
        if let session = request.delegate as AnyObject? {
            DGAlamofirePlugin.monitorSession(session)
        }
        DGAlamofireCenter.shared().upsertRecord(DGAlamofireRecordBuilder.makeRecord(from: request, finished: false))
    }

    public func requestDidFinish(_ request: Request) {
        if let session = request.delegate as AnyObject? {
            DGAlamofirePlugin.monitorSession(session)
        }
        DGAlamofireCenter.shared().upsertRecord(DGAlamofireRecordBuilder.makeRecord(from: request, finished: true))
    }
}

private enum DGAlamofireRecordBuilder {
    static func makeRecord(from request: Request, finished: Bool) -> DGAFNetworkingRecord {
        let urlRequest = request.request ?? request.firstRequest
        let record = DGAFNetworkingRecord()
        record.recordID = request.id.uuidString
        record.startDate = Date()
        record.method = urlRequest?.httpMethod?.uppercased() ?? ""
        record.urlString = urlRequest?.url?.absoluteString ?? ""
        if let headers = urlRequest?.allHTTPHeaderFields {
            record.requestHeaders = DGAFNetworkingHeaderText(headers)
        } else {
            record.requestHeaders = ""
        }
        record.requestBody = requestBodyText(from: urlRequest)

        if let response = request.response {
            record.statusCode = response.statusCode
            record.responseHeaders = DGAFNetworkingHeaderText(response.allHeaderFields)
        }
        if let metrics = request.metrics, metrics.taskInterval.duration > 0 {
            record.duration = metrics.taskInterval.duration
            record.startDate = metrics.taskInterval.start
        }
        record.responseBody = responseBodyText(from: request)
        if let error = request.error {
            record.errorText = error.localizedDescription
        }
        record.isFinished = finished
        return record
    }

    static func requestBodyText(from urlRequest: URLRequest?) -> String {
        guard let urlRequest else { return "" }
        if let body = urlRequest.httpBody, body.isEmpty == false {
            return DGAFNetworkingPrettyText(body as NSData)
        }
        if urlRequest.httpBodyStream != nil {
            return "(body stream，未读取以免消费请求体)"
        }
        return ""
    }

    static func responseBodyText(from request: Request) -> String {
        if let dataRequest = request as? DataRequest, let data = dataRequest.data {
            return DGAFNetworkingPrettyText(data as NSData)
        }
        if let downloadRequest = request as? DownloadRequest, let fileURL = downloadRequest.fileURL {
            return DGAFNetworkingPrettyText(fileURL.path)
        }
        return ""
    }
}

#endif
