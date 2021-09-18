//
//  SwiftRoutes.swift
//  SwiftRoutes
//
//  Created by boye on 2021/9/18.
//

import UIKit

public class SwiftRoutes: NSObject {
    public typealias UnmatchedURLHandler = (SwiftRoutes, URL?, [String: Any]?)->Void
    
    /// Controls whether or not this router will try to match a URL with global routes if it can't be matched in the current namespace. Default is NO.
    public var shouldFallbackToGlobalRoutes = false
    
    /// Called any time routeURL returns NO. Respects shouldFallbackToGlobalRoutes.
    public var unmatchedURLHandler: UnmatchedURLHandler?
    
    ///-------------------------------
    /// @name Routing Schemes
    ///-------------------------------
    
    /// Returns the global routing scheme
    /// - Returns: global Routes
    public static func globalRoutes() -> SwiftRoutes {
        return SwiftRoutes()
    }
    
    /// Returns a routing namespace for the given scheme
    public static func routesForScheme(_ scheme: String) -> SwiftRoutes {
        return SwiftRoutes()
    }
    
    /// Unregister and delete an entire scheme namespace
    public static func unregisterRouteScheme(_ scheme: String) {
        
    }
    
    /// Unregister all routes
    public static func unregisterAllRouteSchemes() {
        
    }
    
    ///-------------------------------
    /// @name Managing Routes
    ///-------------------------------
    
    /// Add a route by directly inserted the route definition. This may be a subclass of JLRRouteDefinition to provide customized routing logic.
    public func addRoute(_ routeDefinition: SwiftRoutesDefinition) {
        
    }
    
    /// Registers multiple routePatterns for one handler with default priority (0) in the receiving scheme.
    public func addRoute(routePatterns: String, handler: (([String: Any]?)->Bool)) {
        
    }
    
    /// Removes the route from the receiving scheme.
    public func removeRoute(_ routeDefinition: SwiftRoutesDefinition) {
        
    }
    
    /// Removes the first route matching routePattern from the receiving scheme.
    public func removeRouteWithPattern(_ pattern: String) {
        
    }
    
    /// Removes all routes from the receiving scheme.
    public func removeAllRoutes() {
        
    }
    
    /// Registers a routePattern with default priority (0) using dictionary-style subscripting.
    public func setObject(_ patten: String, handler block: Any?) {
        
    }
    
    /// @see allRoutes
    /// - Returns: all registered routes in the receiving scheme.
    public func routes() -> [SwiftRoutesDefinition] {
        return [SwiftRoutesDefinition]()
    }
    
    /// @see routes
    /// - Returns: all registered routes across all schemes, keyed by scheme
    public func allRoutes() -> [String: [SwiftRoutesDefinition]] {
        return [String: [SwiftRoutesDefinition]]()
    }
    
    ///-------------------------------
    /// @name Routing URLs
    ///-------------------------------
    
    /// Returns YES if the provided URL will successfully match against any registered route, NO if not.
    public static func canRoute(_ url: URL) -> Bool {
        return false
    }
    
    /// Returns YES if the provided URL will successfully match against any registered route for the current scheme, NO if not.
    public func canRoute(_ url: URL) -> Bool {
        return false
    }
    
    /// Routes a URL, calling handler blocks for patterns that match the URL until one returns YES.
    /// If no matching route is found, the unmatchedURLHandler will be called (if set).
    public static func route(_ url: URL) -> Bool {
        return false
    }
    
    /// Routes a URL within a particular scheme, calling handler blocks for patterns that match the URL until one returns YES.
    /// If no matching route is found, the unmatchedURLHandler will be called (if set).
    public func route(_ url: URL) -> Bool {
        return false
    }
    
    /// Routes a URL in any routes scheme, calling handler blocks (for patterns that match URL) until one returns YES.
    /// Additional parameters get passed through to the matched route block.
    public static func route(_ url: URL, with parameters: [String: Any]?) -> Bool {
        return false
    }
    
    /// Routes a URL in a specific scheme, calling handler blocks (for patterns that match URL) until one returns YES.
    /// Additional parameters get passed through to the matched route block.
    public func route(_ url: URL, with parameters: [String: Any]?) -> Bool {
        return false
    }
}

// GlobalOptions
extension SwiftRoutes {
    /// Configures verbose logging. Defaults to NO.
    public static func setVerbose(_ loggingEnabled: Bool) {
        
    }
    
    /// Returns current verbose logging enabled state. Defaults to NO.
    public static func isVerboseLoggingEnabled() -> Bool {
        return false
    }
    
    /// Configures if '+' should be replaced with spaces in parsed values. Defaults to YES.
    public static func setShouldDecodePlusSymbols(_ shouldDecode: Bool) {
        
    }
    
    /// Returns if '+' should be replaced with spaces in parsed values. Defaults to YES.
    public static func shouldDecodePlusSymbols() -> Bool {
        return true
    }
    
    /// Configures if URL host is always considered to be a path component. Defaults to NO.
    public static func setAlwaysTreatsHostAsPathComponent(_ treatsHostAsPathComponent: Bool) {
        
    }
    
    /// Returns if URL host is always considered to be a path component. Defaults to NO.
    public static func alwaysTreatsHostAsPathComponent() -> Bool {
        return false
    }
    
    /// Configures the default class to use when creating route definitions. Defaults to JLRRouteDefinition.
    public static func setDefaultRouteDefinitionClass(_ clazz: AnyClass) {
        
    }
    
    /// Returns the default class to use when creating route definitions. Defaults to JLRRouteDefinition.
    public static func defaultRouteDefinitionClass() -> AnyClass {
        return SwiftRoutes.self
    }
}
