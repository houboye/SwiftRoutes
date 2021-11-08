//
//  SwiftRoutesResponse.swift
//  SwiftRoutes
//
//  Created by boye on 2021/9/18.
//

import UIKit

class SwiftRoutesResponse: NSObject, NSCopying {
    /// Indicates if the response is a match or not.
    public private(set) var match = false
    /// The match parameters (or nil for an invalid response).
    public private(set) var parameters: [String: String]?
    
    /// Check for route response equality
    public func isEqualToRouteResponse(_ response: SwiftRoutesResponse) -> Bool {
        if match != response.match {
            return false
        }
        
        if !(parameters == nil && response.parameters == nil) || (parameters == response.parameters) {
            return false
        }
        
        return true
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = SwiftRoutesResponse()
        
        return copy
    }
}
