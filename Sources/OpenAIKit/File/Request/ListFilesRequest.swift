import NIOHTTP1
import Foundation

struct ListFilesRequest: Request {
    let method: HTTPMethod = .GET
    let path = "/files"
}

