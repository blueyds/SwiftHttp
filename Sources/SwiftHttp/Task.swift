import Foundation
public typealias nameValueTuple = (name: String, value: String)
public struct HTTPTask{
	var environment: HttpEnvironment
	var method: HttpMethod = .get
	var path: String
	var headers: [nameValueTuple] = []
	var queries: [nameValueTuple] = []
	var body: Data? = nil
	public init(environment: HttpEnvironment, method: HttpMethod, path: String, headers: [nameValueTuple], queries: [nameValueTuple], body: Data?){
		self.environment = environment
		self.method = method
		self.path = path
		self.headers = headers
		self.queries = queries
		self.body = body
	}
	public init(environment: HttpEnvironment, path: String){
		self.environment = environment
		self.path = path
	}
}
public protocol HttpTask{
	associatedtype T:Codable
	var task: HTTPTask { get set }
	func getData() async -> T 	
}

extension HttpTask{
    public func run() async -> Data? {
        let session = URLSession.shared
        let request = task.environment.urlRequest(from: self)
        do {
            let result = try await session.download(for: request)
            print("got download \(result.0)")
            // let text = try String(contentsOf: result.0)
            // print(text)
            let data = try Data(contentsOf: result.0)
            return data
        }
        catch {
            fatalError("HTtpTask threw")
        }
    }
    public func getData() async -> T?{
    	let data:Data? = await run()
    	if data == nil { return nil }
    	return decode(from: data!)
    }
	 
	 /// helper functions
	 public mutating func addQuery(name: String, valueAsInt: Int) {
		 let v = String(valueAsInt)
		 let query = (name: name, value: v)
		 task.queries.append(query)
	 }
	 public mutating func addQuery(name: String, value: String) {
		 let query = (name: name, value: value)
		 task.queries.append(query)
	 }
	 public mutating func addHeader(name: String, value: String){
		 let header = (name: name, value: value)
		 task.headers.append(header)
	 }
	 
	 public mutating func request(json: Codable){
	 	let encoder = JSONEncoder()
	 	if let data = try? encoder.encode(json){
	 		addHeader(name: "Content-Type", value: "application/json")
	 		task.method = .post
	 		task.body = data
	 	}
	 }
}
