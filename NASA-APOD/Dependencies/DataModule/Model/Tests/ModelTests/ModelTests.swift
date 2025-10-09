import XCTest
@testable import Model

final class APODTests: XCTestCase {
    func testAPODDecoding() throws {
        let json = """
        {
            "date":"2021-10-11",
            "explanation":"Sample",
            "media_type":"image",
            "title":"Test Title",
            "url":"https://apod.nasa.gov/sample.jpg"
        }
        """.data(using: .utf8)!
        let apod = try JSONDecoder().decode(APOD.self, from: json)
        XCTAssertEqual(apod.title, "Test Title")
        XCTAssertEqual(apod.mediaType, .image)
    }
}
