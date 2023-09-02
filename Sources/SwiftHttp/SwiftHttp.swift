import Foundation

public enum HttpMethod: String{
	case get = "GET"
	case post = "POST"
}

extension URLComponents{
	// extension to URLComponents to make it easier to add queryItems
	// to UrlComponents by checking for nil first
	internal mutating func addQueryItem(name: String, value: String){
		if queryItems == nil { queryItems = [] }
		self.queryItems!.append(URLQueryItem(name: name, value: value))
	}
	internal mutating func addQueries(_ queries: [(name: name, value: value)]){
		for query in queries {
			self.addQueryItem(name: query.name, value: query.value)
		}
	}
}
