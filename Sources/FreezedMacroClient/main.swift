import FreezedMacro
import Foundation

@Freezed
final class User: Hashable {
    let id: Int
    let name: String
    let url: URL
    let optionalUrl: URL?
    let optionalName:String?
    let optionalId: Int?
    // マクロが依存する全プロパティを受け取るイニシャライザ
    // ※ 実際のマクロを使うにはこれが必須です。
    init(
        id: Int = 1,
        name: String = "",
        url: URL,
        optionalUrl: URL? = nil,
        optionalName: String?,
        optionalId: Int?
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.optionalUrl = optionalUrl
        self.optionalName = optionalName
        self.optionalId = optionalId
    }    
    
}

func main() {
    let user = User(id: 0,
                    name: "",
                    url: URL(string: "")!,
                    optionalUrl: nil,
                    optionalName: nil,
                    optionalId: nil)
    
    let userB = user.copyWith(name: "Kaito Kitaya")
    print(userB.name)
}

print("HELLO, WORLD!\n")
