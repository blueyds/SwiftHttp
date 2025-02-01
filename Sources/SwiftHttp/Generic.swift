import Foundation

/* usage 
 public typealias bookTask = SimpleTask<String,Int>
 public func bookString(_ v:[Int])->String {
     let bookID: Int = v[0]
     return "/\(bookID)/pg\(bookID).txt"
 }
 let t: bookTask = bookTask(environment: .gutenberg, 75248, pathBuilder: bookString(_:))
 */

public struct SimpleCodableTask<T: Codable>:HttpTask{
    public var task: HTTPTask
    public init(environment: HttpEnvironment, path: String){
        self.task = HTTPTask(environment: environment, path: path)
    }
}
public struct SimpleTask<T:Codable,Parameter>:HttpTask{
    public var task: HTTPTask
    public init(environment: HttpEnvironment, _ v: Parameter..., pathBuilder: (_ v: [Parameter])->String){
        let path = pathBuilder(v)
        task = HTTPTask(environment: environment, path: path)
        print(task)
    }
}
extension SimpleTask where T == String{
    public func getData() async -> T? {
        async let data: Data? = run()
        if await data == nil { return nil }
        let text = await String(decoding: data!, as: UTF8.self)
        return text
    }
}
