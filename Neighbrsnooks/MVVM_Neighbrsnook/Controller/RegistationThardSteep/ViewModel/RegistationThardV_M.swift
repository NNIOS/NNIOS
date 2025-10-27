//
//  RegistationThardV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 23/09/25.
//

import Foundation
import UIKit

class RegistationThardV_M: NSObject {
    static let shared = RegistationThardV_M()
    func RegistationThard(
        parameters: Parameters,
        documents: [String: UIImage],   // All image fields
        completion: @escaping (_ result: RegistationThardModel?) -> Void)
    {
        let apiUrl = API.RegistationThardSteep
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let httpUtility = HttpUtility()
        httpUtility.upload_Reimburse_WithDocuments(
            url: apiUrl,
            parameters: parameters,
            mediaFiles: documents as! [String : MediaTypeImageVid],
            authToken: "Bearer \(token)",
            httpMethod: "POST",
            resultType: RegistationThardModel.self
        ) { result in
            completion(result)
        }
    }
}

