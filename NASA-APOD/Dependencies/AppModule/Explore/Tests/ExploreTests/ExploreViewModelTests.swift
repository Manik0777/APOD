//
//  ExploreViewModelTests.swift
//  Explore
//
//  Created by Manik on 09/10/2025.
//

import XCTest
@testable import Model
@testable import Repository
@testable import Explore
@testable import CoreUtils

@MainActor
final class ExploreViewModelTests: XCTestCase {

    func testLoadSetsAPODAndLoadingFlags() async {
        
        let myTestAPOD = APOD(
            date: "2021-10-11",
            title: "Test Title",
            explanation: "Sample explanation",
            mediaType: .image,
            url: URL(string: "https://apod.nasa.gov/sample.jpg"),
            hdurl: nil,
            copyright: nil
        )

        let mockRepo = MockAPODRepository(apodToReturn: myTestAPOD)

        let vm = ExploreViewModel(repository: mockRepo)
        XCTAssertNil(vm.apod)
        XCTAssertFalse(vm.isLoading)

        await vm.load(date: nil)

        XCTAssertEqual(vm.apod?.title, "Test Title")
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isFallback)
    }

    func testFallbackIsTrueWhenDatesMismatch() async {
        
        let myTestAPOD = APOD(
            date: "2021-10-10", // mismatch
            title: "Mismatch Title",
            explanation: "Fallback test",
            mediaType: .image,
            url: nil,
            hdurl: nil,
            copyright: nil
        )

        let mockRepo = MockAPODRepository(apodToReturn: myTestAPOD)

        let vm = ExploreViewModel(repository: mockRepo)
        let requestedDate = APODDateFormatter.shared.date(from: "2021-10-11")!

        await vm.load(date: requestedDate)

        XCTAssertEqual(vm.apod?.title, "Mismatch Title")
        XCTAssertTrue(vm.isFallback)
    }

    func testFallbackIsFalseWhenDatesMatch() async {
        
        let myTestAPOD = APOD(
            date: "2021-10-11",
            title: "Exact Match",
            explanation: "No fallback",
            mediaType: .image,
            url: nil,
            hdurl: nil,
            copyright: nil
            )

        let mockRepo = MockAPODRepository(apodToReturn: myTestAPOD)


        let vm = ExploreViewModel(repository: mockRepo)
        let requestedDate = APODDateFormatter.shared.date(from: "2021-10-11")!

        await vm.load(date: requestedDate)

        XCTAssertFalse(vm.isFallback)
    }
}
