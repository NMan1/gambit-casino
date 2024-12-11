//
//  server.swift
//  node
//
//  Created by Nick Mantini on 10/30/24.
//

import Request
import Foundation

let serverIp = "http://localhost:3000"

func getRequestError(_ error: RequestError) -> (code: String, message: String) {
    if let responseData = error.error {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
            return (code: errorResponse.code, message: errorResponse.message)
        } catch {
            return (code: "FAILED_TO_DECODE", message: "An unknown error occurred, try again later")
        }
    } else {
        return (code: "FAILED_TO_DECODE", message: "An unknown error occurred, try again later")
    }
}
