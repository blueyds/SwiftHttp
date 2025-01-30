import Foundation

public protocol HttpEnvironment{
	var hostName: String { get }
	var pathPrefix: String { get }
	var headers: [(name: String, value: String)] { get }
	var queries: [(name: String, value: String)] { get }
	//func urlRequest(from task: any HttpTask) -> URLRequest
}

extension HttpEnvironment {
	public typealias Headers = [(name: String, value: String)]
    public typealias Queries = [(name: String, value: String)]
    public var headers: Headers { [] }
    public var queries: Queries { [] }
    
	public func urlRequest(from t: any HttpTask) -> URLRequest{
		var urlParts = URLComponents()
		urlParts.scheme = "https"
		urlParts.host = hostName
		urlParts.path = pathPrefix + t.task.path	
		urlParts.addQueries(queries)
		urlParts.addQueries(t.task.queries)
		
		if let url = urlParts.url{
			var request = URLRequest(url: url)
			request.httpMethod = t.task.method.rawValue
			request.addHeaders(headers)
			request.addHeaders(t.task.headers)
			request.httpBody = t.task.body
			print(request.url!.absoluteString)
			print(request.allHTTPHeaderFields)
			return request    
		} else {
				fatalError("urlParts did not unwrap \(urlParts)")
		}
	}
}

extension URLRequest{
	internal mutating func addHeaders(_ headers: [(name: String, value: String)]){
		for header in headers {
			self.addValue(header.value, forHTTPHeaderField: header.name)
		}
	}
}
