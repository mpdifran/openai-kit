import NIOHTTP1
import Foundation

struct ListModelsRequest: Request {
    let method: HTTPMethod = .GET
    let path = "/models"
}

