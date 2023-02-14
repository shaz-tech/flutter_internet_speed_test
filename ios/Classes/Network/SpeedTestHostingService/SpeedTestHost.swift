import Foundation

/*
 "url": "http://test.byfly.by/speedtest/upload.php",
 "lat": "53.9000",
 "lon": "27.5667",
 "distance": 0,
 "name": "Minsk",
 "country": "Belarus",
 "cc": "BY",
 "sponsor": "MGTS",
 "id": "1119",
 "preferred": 0,
 "host": "test.byfly.by:8080"
*/

public struct SpeedTestHost: Codable {
    public let url: URL
    public let name: String
    public let country: String
    public let cc: String
    public let host: String
    public let sponsor: String
}
