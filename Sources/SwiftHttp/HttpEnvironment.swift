import Foundation

public struct HttpEnvironment{
	var hostName: String
	var pathPrefix: String
	var headers: [(name: String, value: String)] = []
	var queries: [(name: String, value: String)] = []
	//func urlRequest(from task: any HttpTask) -> URLRequest
}

extension HttpEnvironment {    
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
			//print(request.url!.absoluteString)
			//print(request.allHTTPHeaderFields)
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
