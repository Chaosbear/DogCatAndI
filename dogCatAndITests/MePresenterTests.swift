import XCTest
@testable import dogCatAndI

final class MePresenterTests: XCTestCase {

    var sut: MePresenter!
    var store: MeStore!

    override func setUp() {
        super.setUp()
        store = MeStore()
        sut = MePresenter(store: store)
    }

    override func tearDown() {
        sut = nil
        store = nil
        super.tearDown()
    }

    func testPresentProfile_formatsDataCorrectly() {
        let user = makeTestUser(
            gender: "male",
            title: "Mr", first: "John", last: "Doe",
            streetNumber: 456, streetName: "Oak Ave",
            city: "Portland", state: "Oregon",
            country: "United States", postcode: .string("97201"),
            dob: "1990-05-15T10:30:00.000Z", age: 35,
            cell: "(555) 987-6543",
            pictureLarge: "https://randomuser.me/api/portraits/men/1.jpg",
            nat: "US"
        )

        let response = Me.FetchProfile.Response(user: user, error: nil)
        sut.presentProfile(response: response)

        // Pump the run loop to process DispatchQueue.main.async
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))

        let profile = store.profile
        XCTAssertNotNil(profile, "Profile should not be nil after presentation")

        guard let profile = profile else { return }
        XCTAssertEqual(profile.title, "Mr")
        XCTAssertEqual(profile.firstName, "John")
        XCTAssertEqual(profile.lastName, "Doe")
        XCTAssertEqual(profile.age, "35")
        XCTAssertEqual(profile.gender, "male")
        XCTAssertEqual(profile.nationality, "US")
        XCTAssertEqual(profile.mobile, "(555) 987-6543")
        XCTAssertNotNil(profile.profileImageURL)
        XCTAssertTrue(profile.address.contains("456 Oak Ave"), "Address should contain street")
        XCTAssertTrue(profile.address.contains("Portland"), "Address should contain city")
        // Date should be formatted as dd/MM/yyyy
        XCTAssertFalse(profile.dateOfBirth.isEmpty, "Date of birth should not be empty")
    }

    func testPresentProfile_nilUser_setsError() {
        let response = Me.FetchProfile.Response(user: nil, error: "Test error")
        sut.presentProfile(response: response)

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))

        XCTAssertNil(store.profile)
        XCTAssertEqual(store.errorMessage, "Test error")
    }

    func testPresentLoading_updatesStore() {
        sut.presentLoading(true)

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))

        XCTAssertTrue(store.isLoading)

        sut.presentLoading(false)

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))

        XCTAssertFalse(store.isLoading)
    }

    func testPresentProfile_postcodeAsInt() {
        let user = makeTestUser(
            gender: "female",
            title: "Ms", first: "Jane", last: "Smith",
            streetNumber: 789, streetName: "Pine Rd",
            city: "Austin", state: "Texas",
            country: "United States", postcode: .int(78701),
            dob: "1985-12-25T08:00:00.000Z", age: 40,
            cell: "(555) 333-4444",
            pictureLarge: "https://randomuser.me/api/portraits/women/1.jpg",
            nat: "US"
        )

        let response = Me.FetchProfile.Response(user: user, error: nil)
        sut.presentProfile(response: response)

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))

        XCTAssertTrue(store.profile?.address.contains("78701") ?? false, "Address should contain int postcode")
    }

    // MARK: - Helper

    private func makeTestUser(
        gender: String,
        title: String, first: String, last: String,
        streetNumber: Int, streetName: String,
        city: String, state: String,
        country: String, postcode: PostcodeValue,
        dob: String, age: Int,
        cell: String,
        pictureLarge: String,
        nat: String
    ) -> RandomUserResult {
        RandomUserResult(
            gender: gender,
            name: RandomUserName(title: title, first: first, last: last),
            location: RandomUserLocation(
                street: RandomUserLocation.RandomUserStreet(number: streetNumber, name: streetName),
                city: city, state: state, country: country, postcode: postcode
            ),
            dob: RandomUserDob(date: dob, age: age),
            phone: "(555) 000-0000",
            cell: cell,
            picture: RandomUserPicture(
                large: pictureLarge,
                medium: pictureLarge,
                thumbnail: pictureLarge
            ),
            nat: nat
        )
    }
}
