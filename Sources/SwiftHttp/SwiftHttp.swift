import Foundation

public enum HttpMethod: String{
	case get = "GET"
	case post = "POST"
}

extension URLComponents{
	// extension to URLComponents to make it easier to add queryItems
	// to UrlComponents by checking for nil first
	public mutating func addQueryItem(name: String, value: String){
		if queryItems == nil { queryItems = [] }
		self.queryItems!.append(URLQueryItem(name: name, value: value))
	}
}
