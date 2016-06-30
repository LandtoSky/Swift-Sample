//
//  MultiColorProgessViewTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/18/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
@testable import SweepBright

class MultiColorProgessViewTests: XCTestCase {
    var progressView: MultiColorProgressView!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        self.progressView = MultiColorProgressView(frame:CGRect.zero)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCornerRadius() {
        XCTAssertEqual(progressView.layer.cornerRadius, 5)
        XCTAssert(progressView.layer.masksToBounds)
    }

    func testSetProgress() {
        progressView.setProgress(1.0, animated: false)

        XCTAssertEqual(progressView.progressTintColor, UIColor.greenProgressBar())


        progressView.setProgress(0.0, animated: false)
        XCTAssertEqual(progressView.progressTintColor, UIColor.blueProgressBar())
    }


}
