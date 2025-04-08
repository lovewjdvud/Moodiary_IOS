//
//  NetworkManager.swift
//  tcadatalayers
//
//  Created by Songjeongpyeong on 9/1/24.
//

import Foundation

/// HTTP 요청 메서드를 정의하는 열거형
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// 네트워크 요청을 관리하는 구조체
struct NetworkManager {
    private let baseURL: String
    private let session: URLSession
    
    /// NetworkManager 초기화
    /// - Parameters:
    ///   - baseURL: API의 기본 URL
    ///   - session: 사용할 URLSession (기본값: .shared)
    init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    /// 제네릭 네트워크 요청 메서드
    /// - Parameters:
    ///   - endpoint: API 엔드포인트
    ///   - method: HTTP 메서드 (기본값: .get)
    ///   - queryItems: URL 쿼리 파라미터
    ///   - body: 요청 본문 데이터
    ///   - requiresAuth: 인증 필요 여부 (기본값: true)
    /// - Returns: 디코딩된 응답 데이터
    /// - Throws: NetworkError
    func request<T: Decodable>(_ endpoint: String,
                                method: HTTPMethod = .get,
                                queryItems: [URLQueryItem] = [],
                                body: Encodable? = nil,
                                requiresAuth: Bool = true) async throws -> T {
        // URL 구성
        guard var components = URLComponents(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL(message: "발생 : NetworkManager request - URL 구성, Error Type : invalidURL")
        }
      
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL(message: "발생 : NetworkManager request - URL components , Error Type : invalidURL")
        }
        
        // URLRequest 생성 및 설정
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let jsonEncoder = JSONEncoder()
        if let httpBodyData = body,
           let jsonData = try? jsonEncoder.encode(httpBodyData){
            request.httpBody = jsonData
        }
        
        
        // 공통 헤더 설정
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증이 필요한 경우 JWT 토큰을 헤더에 추가
        if requiresAuth {
            guard let token = AuthManager.shared.getToken() else {
                throw NetworkError.unauthorized(message: "발생 : NetworkManager request - JWT 토큰을 헤더에 추가 , Error Type : unauthorized")
            }
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            // 네트워크 요청 실행
            let (data, response) = try await session.data(for: request)

            // HTTP 응답 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse(message: "발생 : NetworkManager request - HTTP 응답 확인, Error Type : invalidResponse")
            }
            
            print("NetworkManager \(httpResponse.statusCode)")
            // 상태 코드에 따른 처리
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    // 성공적인 응답 디코딩
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingFailed(error)
                }
            case 401:
                print("NetworkManager statusCode \(httpResponse.statusCode) ")
                print("requestrequest statusCode = 400 description \(httpResponse.description) ")
                throw NetworkError.unauthorized(message: "발생 : NetworkManager request - 네트워크 요청 실행 실행 후 401 결과 , Error Type : unauthorized")
            default:
                print("NetworkManager default statusCode \(httpResponse.statusCode) ")
                print("requestrequest default statusCode = 400 description \(httpResponse.description) ")
                throw NetworkError.invalidResponse(message: "발생 : NetworkManager request - 네트워크 요청 실행 실행 후 default 결과, Error Type : invalidResponse ")
            }
        } catch {
            print("NetworkManager catch \(error) ")
            throw NetworkError.requestFailed(error)
        }
    }
    
    
    /// 응답 본문 없이 네트워크 요청을 수행하는 메서드
       /// - Parameters:
       ///   - endpoint: API 엔드포인트
       ///   - method: HTTP 메서드 (기본값: .get)
       ///   - queryItems: URL 쿼리 파라미터
       ///   - body: 요청 본문 데이터
       ///   - requiresAuth: 인증 필요 여부 (기본값: true)
       /// - Throws: NetworkError
       func requestWithoutResponse(_ endpoint: String,
                                   method: HTTPMethod = .get,
                                   queryItems: [URLQueryItem] = [],
                                   body: Data? = nil,
                                   requiresAuth: Bool = true) async throws {
           
           guard var components = URLComponents(string: baseURL + endpoint) else {
               throw NetworkError.invalidURL(message: "발생 : NetworkManager requestWithoutResponse - URLComponents , Error Type : invalidURL ")
           }
           
           components.queryItems = queryItems.isEmpty ? nil : queryItems
           
           guard let url = components.url else {
               throw NetworkError.invalidURL(message: "발생 : NetworkManager requestWithoutResponse - components url  , Error Type : invalidURL ")
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = method.rawValue
           request.httpBody = body
           
           // 공통 헤더 설정
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.setValue("application/json", forHTTPHeaderField: "Accept")
           
           // 인증이 필요한 경우 JWT 토큰을 헤더에 추가
           if requiresAuth {
               guard let token = AuthManager.shared.getToken() else {
                   throw NetworkError.unauthorized(message: "발생 : NetworkManager requestWithoutResponse - JWT 토큰을 헤더에 추가  , Error Type : unauthorized ")
               }
               request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           }
           
           let (_, response) = try await session.data(for: request)
           
           guard let httpResponse = response as? HTTPURLResponse else {
               throw NetworkError.invalidResponse(message: "발생 : NetworkManager requestWithoutResponse - HTTPURLResponse  , Error Type : invalidResponse ")
           }
           
           switch httpResponse.statusCode {
           case 200...299:
               return // 성공적인 응답, 아무 것도 반환하지 않음
           case 401:
               throw NetworkError.unauthorized(message: "발생 : NetworkManager requestWithoutResponse - httpResponse statusCode 401  , Error Type : unauthorized ")
           default:
               throw NetworkError.invalidResponse(message: "발생 : NetworkManager requestWithoutResponse - httpResponse statusCode default  , Error Type : invalidResponse ")
           }
       }
    
    func uploadMultipartFormData<T: Decodable>(_ endpoint: String,
                                                   parameters: [String: String],
                                                   fileData: [String: (data: Data, fileName: String, mimeType: String)],
                                                   requiresAuth: Bool = true) async throws -> T {
            guard let url = URL(string: baseURL + endpoint) else {
                throw NetworkError.invalidURL(message: "발생 : NetworkManager uploadMultipartFormData - Url 설정 , Error Type : invalidURL ")
            }

            let boundary = "Boundary-\(UUID().uuidString)"
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            if requiresAuth {
                guard let token = AuthManager.shared.getToken() else {
                    throw NetworkError.unauthorized(message: "발생 : NetworkManager uploadMultipartFormData - requiresAuth  , Error Type : unauthorized ")
                }
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            let httpBody = NSMutableData()

             // 텍스트 파라미터 추가
             for (key, value) in parameters {
                 httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
                 httpBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                 httpBody.append("\(value)\r\n".data(using: .utf8)!)
             }

             // 파일 데이터 추가
             for (key, (data, fileName, mimeType)) in fileData {
                 httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
                 httpBody.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                 httpBody.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                 httpBody.append(data)
                 httpBody.append("\r\n".data(using: .utf8)!)
             }

             httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = httpBody as Data

            do {
                let (data, response) = try await session.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse(message: "발생 : NetworkManager uploadMultipartFormData - httpResponse , Error Type : invalidResponse ")
                }

                switch httpResponse.statusCode {
                case 200...299:
                    do {
                        return try JSONDecoder().decode(T.self, from: data)
                    } catch {
                        throw NetworkError.decodingFailed(error)
                    }
                case 401:
                    throw NetworkError.unauthorized(message: "발생 : NetworkManager uploadMultipartFormData - httpResponse 401, Error Type : unauthorized ")
                default:
                    throw NetworkError.invalidResponse(message: "발생 : NetworkManager uploadMultipartFormData - httpResponse default , Error Type : invalidResponse ")
                }
            } catch {
                throw NetworkError.requestFailed(error)
            }
        }
}

