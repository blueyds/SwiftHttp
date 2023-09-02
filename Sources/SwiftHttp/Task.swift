import Foundation

public protocol HttpTask{
	associatedtype T:Codable
	var defaults: HttpEnvironment { get }
	var method: HttpMethod { get }
	var headers: [(name: String, value: String)] { get }
	var path: String { get }
	var queries: [(name: String, value: String)] { get }
	
}

extension HttpTask{
    public func run() async -> T {
        let session = URLSession.shared
        let request = defaults.urlRequest(from: self)
        do {
            let result = try await session.download(for: request)
            print("got download \(result.0)")
            // let text = try String(contentsOf: result.0)
            // print(text)
            let data = try Data(contentsOf: result.0)
            return decode(from: data)
        }
        catch {
            fatalError("HTtpTask threw")
        }
    }
}
