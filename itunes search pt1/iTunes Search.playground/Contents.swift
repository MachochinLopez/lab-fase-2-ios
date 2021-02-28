import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


let searchParams = [
    "term": "enjambre+sabado+perpetuo",
    "media": "music"
]
let url = "https://itunes.apple.com/search"
var urlComponents = URLComponents(string: url)!

urlComponents.queryItems = searchParams.map { URLQueryItem(name: $0.key, value: $0.value) }
print(urlComponents.url!)

let task = URLSession.shared.dataTask(with: urlComponents.url!) {
    (data, response, error) in
    
    if let data = data, let string = String(data: data, encoding: .utf8) {
        print(string)
    }
    PlaygroundPage.current.finishExecution()
}

task.resume()
