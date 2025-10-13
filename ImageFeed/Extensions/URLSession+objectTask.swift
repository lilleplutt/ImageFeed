import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Get JSON: \(jsonString)")
                }
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    if let decodingError = error as? DecodingError {
                        print("[objectTask] Decoding Error: \(decodingError), Data: \(String(data: data, encoding: .utf8) ?? "")")
                    } else {
                        print("[objectTask] Decoding Error: \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print("[objectTask] Request Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        return task
    }
}
