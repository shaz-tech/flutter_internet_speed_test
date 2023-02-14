import Foundation

public enum Result<T, E: Error> {
    case value(T)
    case error(E)
}
