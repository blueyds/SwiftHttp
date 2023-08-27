import Foundation



public protocol HttpUrlRequestor{
	var hostName: String { get }
	var pathPrefix: String { get }
	var defaultHeaders: [String:String] { get }
	var defaultQueries: [(name: String, value: String)] { get }
	//func urlRequest(from task: any HttpTask) -> URLRequest
}

extension HttpUrlRequestor {
	public func urlRequest(from task: any HttpTask) -> URLRequest{
		var urlParts = task.url
		urlParts.scheme = "https"
		if urlParts.host == nil {
			urlParts.host = hostName
		}
		if urlParts.path == "" {
			urlParts.path = pathPrefix
		} else {
			urlParts.path = pathPrefix + urlParts.path
		}
		for query in defaultQueries {
			urlParts.addQueryItem(name: query.name, value: query.value)
		}
		if let url = urlParts.url{
			var result = URLRequest(url: url)
			result.httpMethod = task.method.rawValue
			for header in defaultHeaders {
				result.addValue(header.value, forHTTPHeaderField: header.key)
			}
			for header in task.headers {
				result.addValue(header.value, forHTTPHeaderField: header.key)
			}
			print(result.url!.absoluteString)
			return result    
			} else {
				fatalError("urlParts did not unwrap \(urlParts)")
		}
	}
}
