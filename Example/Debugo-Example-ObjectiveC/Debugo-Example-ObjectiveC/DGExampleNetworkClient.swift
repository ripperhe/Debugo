//
//  DGExampleNetworkClient.swift
//  Debugo-Example-ObjectiveC
//
//  用 Alamofire 请求 DummyJSON，并把 Session 交给 Debugo 的 Alamofire 插件监听。
//

import Foundation
import Alamofire
import Debugo

@objc(DGExampleNetworkClient)
public final class DGExampleNetworkClient: NSObject {
    private static let productsURL = "https://dummyjson.com/products"

    private static let session: Session = {
        let session = Session()
        DGAlamofirePlugin.monitorSession(session)
        return session
    }()

    @objc(requestProductsWithCompletion:)
    public static func requestProducts(completion: @escaping (String) -> Void) {
        session.request(productsURL).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(summary(from: data))
            case .failure(let error):
                completion("Alamofire 失败：\(error.localizedDescription)")
            }
        }
    }

    private static func summary(from data: Data) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return "Alamofire 成功，但返回数据格式不符合预期"
        }
        let count = (json["products"] as? [Any])?.count ?? 0
        if let total = json["total"] {
            return "Alamofire 成功，本页 \(count) 个商品，共 \(total) 个"
        }
        return "Alamofire 成功，商品数 \(count)"
    }
}
