//
//  Flickr_Photo_SearchTests.swift
//  Flickr Photo SearchTests
//
//  Created by Tewodros Mengesha on 21.3.2021.
//

import XCTest
@testable import Flickr_Photo_Search

let apiKey = "b59eaa142fbb03d0ba6c93882fd62e30"

class Flickr_Photo_SearchTests: XCTestCase {
    
    var apiURL = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=car&per_page=20&format=json&nojsoncallback=1")
    
    func testValidCallToAPIGetsHTTPStatusCode200() throws {
         
         let promise = expectation(description: "Status code: 200")
         let urlSession = URLSession(configuration: .default)
         
         let dataTask = urlSession.dataTask(with: apiURL!) { data, response, error in
             
             if let error = error {
               XCTFail("Error: \(error.localizedDescription)")
               return
             } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
               if statusCode == 200 {
                 promise.fulfill()
               } else {
                 XCTFail("Status code: \(statusCode)")
               }
             }
           }
           dataTask.resume()
           wait(for: [promise], timeout: 5)
     }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
