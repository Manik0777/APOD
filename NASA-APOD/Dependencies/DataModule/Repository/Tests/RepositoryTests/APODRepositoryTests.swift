import XCTest
import CoreData
@testable import Repository
@testable import Model
@testable import APIClient
@testable import CoreUtils

final class APODRepositoryTests: XCTestCase {
    func testLoadCachedFallback_whenNetworkFails() async throws {
        // Provide a mock API that throws
        class FailingAPI: APODAPI {
            override init(apiKey: String? = nil) { super.init(apiKey: apiKey) }
            override func fetchAPOD(for date: Date?) async throws -> APOD {
                throw URLError(.notConnectedToInternet)
            }
        }
        // Use the real CoreDataStack but it expects a model; in tests it's typical to load an in-memory stack
        let stack = CoreDataStack(modelName: "NASA_APOD")
        let repo = DefaultAPODRepository(api: FailingAPI(), coreDataStack: stack)
        // Ensure no crash when fetching
        let apod = await repo.getAPOD(for: nil)
        XCTAssertNil(apod)
    }
}
