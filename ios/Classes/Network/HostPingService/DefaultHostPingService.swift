import Foundation

class DefaultHostPingService: HostPingService {
    func ping(url: URL, timeout: TimeInterval, closure: @escaping (Result<Int, NetworkError>) -> ()) {
        url.ping(timeout: timeout, closure: closure)
    }
}
