import Foundation

public protocol HttpTask{
	associatedtype T:Codable
	var defaults: HttpEnvironment { get }
	var method: HttpMethod { get set }
	var headers: [(name: String, value: String)] { get set }
	var path: String { get }
	var queries: [(name: String, value: String)] { get set }
	var body: Data? { get set }
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
	 
	 /// helper functions
	 public mutating func addQuery(name: String, valueAsInt: Int) {
		 let v = String(valueAsInt)
		 let query = (name: name, value: v)
		 queries.append(query)
	 }
	 public mutating func addQuery(name: String, value: String) {
		 let query = (name: name, value: value)
		 queries.append(query)
	 }
	 public mutating func addHeader(name: String, value: String){
		 let header = (name: name, value: value)
		 headers.append(header)
	 }
	 
	 public mutating func request(json: Codable){
	 	let encoder = JSONEncoder()
	 	if let data = try? encoder.encode(json){
	 		addHeader(name: "Content-Type", value: "application/json")
	 		method = .post
	 		body = data
	 	}
	 }
}
