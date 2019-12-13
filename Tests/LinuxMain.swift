import XCTest

import HttpConnectionTests

var tests = [XCTestCaseEntry]()
tests += HttpConnectionTests.allTests()
XCTMain(tests)
