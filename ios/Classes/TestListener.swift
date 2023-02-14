import Foundation

protocol TestListener {
    func onComplete(transferRate: Double)
    
    func onError(speedTestError: String, errorMessage: String)
    
    func onProgress(percent: Double, transferRate: Double)
}
