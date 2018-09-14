//
//  URLSessionExtension.swift
//  SwiftExtensions
//
//  Created by Klemen Kosir on 15. 06. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import Foundation

public extension URLSession {
	
	func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
		var data: Data?
		var response: URLResponse?
		var error: Error?
		
		let semaphore = DispatchSemaphore(value: 0)
		
		let dataTask = self.dataTask(with: url) {
			data = $0
			response = $1
			error = $2
			
			semaphore.signal()
		}
		dataTask.resume()
		
		_ = semaphore.wait(timeout: .distantFuture)
		
		return (data, response, error)
	}
	
	func synchronousDataTask(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
		var data: Data?
		var response: URLResponse?
		var error: Error?
		
		let semaphore = DispatchSemaphore(value: 0)
		
		let dataTask = self.dataTask(with: request) { (d, r, e) in
			data = d
			response = r
			error = e
			
			semaphore.signal()
		}
		dataTask.resume()
		
		_ = semaphore.wait(timeout: .distantFuture)
		
		return (data, response, error)
	}
	
}
