//
//  ApiHandler.swift
//  TaskWeboconnect
//
//  Created by Sandeep Srivastava on 26/07/24.
//

import Foundation


class ProfileService {
    static func uploadProfile(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://httpbin.org/post")! // Dummy URL
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        appendField(name: "first_name", value: profile.firstName, boundary: boundary, to: &body)
        appendField(name: "last_name", value: profile.lastName, boundary: boundary, to: &body)
        appendField(name: "phone_number", value: profile.phoneNumber, boundary: boundary, to: &body)
        appendField(name: "post_code", value: profile.postCode, boundary: boundary, to: &body)
        
        if let imageData = profile.imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading data: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private static func appendField(name: String, value: String, boundary: String, to body: inout Data) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
}


