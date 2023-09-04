import Foundation

internal func decode<T: Decodable>(
	from data: Data,
	dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
	keyDecodingStrategy : JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
	) -> T{
	
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = dateDecodingStrategy
		decoder.keyDecodingStrategy = keyDecodingStrategy
	do {
		return try decoder.decode(T.self, from: data)
	} catch DecodingError.keyNotFound(let key, let context){
		printKeyPath(context.codingPath)
		fatalError("Failed to decode due to missing key '\(key.stringValue)' not found \(context.debugDescription)")
	} catch DecodingError.typeMismatch(_, let context){
		printData(data)
		printKeyPath(context.codingPath)
		fatalError("Failed to decode due to type mismatch - \(context.debugDescription)")
	} catch DecodingError.valueNotFound(let type, let context){
		printData(data)
		printKeyPath(context.codingPath)
		fatalError("Failed to decode due to missing \(type) value - \(context.debugDescription)")
	} catch DecodingError.dataCorrupted(_){
		printData(data)
		fatalError("Failed to decode because it appears to be invalid JSON")
	} catch {
		print(data)
		fatalError("Failed to decode: \(error.localizedDescription)")
	}
}
fileprivate func printKeyPath(_ keys: [CodingKey]){
	print("*****KEY PATH to FAILURE******")
	print("keys total \(keys.count)")
	for key in keys {
		print(key.debugDescription)
	}
}

fileprivate func printData(_ data: Data){
	print("***** Data attempting to decode *****")
	var str = String(decoding: data, as: UTF8.self)
	if str.len > 0 {
		print(str)
	}
}