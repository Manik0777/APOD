//
//  DashboardViewModelTests.swift
//  Dashboard
//
//  Created by Manik on 09/10/2025.
//

import XCTest
@testable import Model
@testable import Repository
@testable import CoreUtils
@testable import Dashboard

@MainActor
final class DashboardViewModelTests: XCTestCase {

    func testLoadTodaySetsAPODAndLoadingFlags() async {
        let myTestAPOD = APOD(
            date: APODDateFormatter.shared.string(from: Date()),
            title: "Today’s APOD",
            explanation: "Sample explanation",
            mediaType: .image,
            url: nil,
            hdurl: nil,
            copyright: nil
        )

        let mockRepo = MockAPODRepository(apodToReturn: myTestAPOD)

        let vm = DashboardViewModel(repository: mockRepo)

        XCTAssertNil(vm.apod)
        XCTAssertFalse(vm.isLoading)

        await vm.loadToday()

        XCTAssertEqual(vm.apod?.title, "Today’s APOD")
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isFallback)
    }

    func testFallbackIsTrueWhenReturnedDateIsNotToday() async {
        
        let myTestAPOD = APOD(
            date: "2021-10-11", // not today
            title: "Old APOD",
            explanation: "Fallback test",
            mediaType: .image,
            url: nil,
            hdurl: nil,
            copyright: nil
        )

        let mockRepo = MockAPODRepository(apodToReturn: myTestAPOD)

        let vm = DashboardViewModel(repository: mockRepo)

        await vm.loadToday()

        XCTAssertEqual(vm.apod?.title, "Old APOD")
        XCTAssertTrue(vm.isFallback)
    }

    func testFallbackIsFalseWhenReturnedDateIsToday() async {
        
        let today = APODDateFormatter.shared.string(from: Date())
        let myTestAPOD = APOD(
            date: today,
            title: "Exact Match",
            explanation: "No fallback",
            mediaType: .image,
            url: nil,
            hdurl: nil,
            copyright: nil
        )

        let mockRepo = MockAPODRepository(apodToReturn: myTestAPOD)

        let vm = DashboardViewModel(repository: mockRepo)

        await vm.loadToday()

        XCTAssertFalse(vm.isFallback)
    }
}
