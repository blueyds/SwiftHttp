import Foundation

public protocol HttpTask{
	associatedtype T:Codable
	var api: HttpUrlRequestor { get }
	var url: URLComponents { get }
	var headers: [String:String] { get }
	var method: HttpMethod { get }
}

extension HttpTask{
    public func run() async -> T {
        let session = URLSession.shared
        let request = api.urlRequest(from: self)
        do {
            let result = try await session.download(for: request)
            print("got download \(result.0)")
            let text = try String(contentsOf: result.0)
            print(text)
            let data = try Data(contentsOf: result.0)
            return decode(from: data)
        }
        catch {
            fatalError("HTtpTask threw")
        }
    }
}
