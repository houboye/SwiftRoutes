//
//  RoutesParsingUtilities.swift
//  SwiftRoutes
//
//  Created by boye on 2021/9/18.
//

import UIKit

public class RoutesParsingUtilities {
    public static func variableValueFrom(value: String, decodePlusSymbols: Bool) -> String {
        if decodePlusSymbols == false {
            return value
        }
        return value.replacingOccurrences(of: "+", with: " ", options: .literal, range: Range(NSRange(location: 0, length: value.count), in: value))
    }
    
    public static func queryParams(_ queryParams: [String: Any], decodePlusSymbols: Bool) -> [String: Any] {
        if decodePlusSymbols == false {
            return queryParams
        }
        var updatedQueryParams = [String: Any]()
        
        for (key, value) in queryParams {
            if let value = value as? Array<Any> {
                var variables = [Any]()
                for arrayValue in value {
                    if let arrayValue = arrayValue as? String {
                        variables.append(variableValueFrom(value: arrayValue, decodePlusSymbols: true))
                    }
                }
                updatedQueryParams[key] = variables
            } else if let value = value as? String {
                let variable = variableValueFrom(value: value, decodePlusSymbols: true)
                updatedQueryParams[key] = variable
            } else {
                assert(false, "Unexpected query parameter type: \(value.self)")
            }
        }
        
        return updatedQueryParams
    }
    
    static func expandOptionalRoutePatternsForPattern(_ pattern: String) -> [String] {
        
        /* this method exists to take a route pattern that is known to contain optional params, such as:
         
         /path/:thing/(/a)(/b)(/c)
         
         and create the following paths:
         
         /path/:thing/a/b/c
         /path/:thing/a/b
         /path/:thing/a/c
         /path/:thing/b/c
         /path/:thing/a
         /path/:thing/b
         /path/:thing/c
         
         */
        
        if pattern.range(of: "(") == nil {
            return [String]()
        }
        
        // First, parse the route pattern into subpath objects.
        let subpaths = routeSubpathsForPattern(pattern)
        if subpaths.count == 0 {
            return [String]()
        }
        
        // Next, etract out the required subpaths.
        let tmpSubpaths = subpaths.filter { subpath in
            return !subpath.isOptionalSubpath
        }
        
        let requiredSubpaths = Set<ParsingUtilities_RouteSubpath>(tmpSubpaths)
        
        // Then, expand the subpath permutations into possible route patterns.
        let allSubpathCombinations = subpaths.routes_allOrderedCombinations()
        
        // Finally, we need to filter out any possible route patterns that don't actually satisfy the rules of the route.
        // What this means in practice is throwing out any that do not contain all required subpaths (since those are explicitly not optional).
        let validSubpathCombinations = allSubpathCombinations.filter { possibleRouteSubpaths in
            return requiredSubpaths.isSubset(of: Set<ParsingUtilities_RouteSubpath>(possibleRouteSubpaths))
        }
        
        // Once we have a filtered list of valid subpaths, we just need to convert them back into string routes that can we registered.
        var validSubpathRouteStrings = validSubpathCombinations.map { subpaths -> String in
            var routePattern = "/"
            for subpath in subpaths {
                let subpathString = subpath.subpathComponents.joined(separator: "/")
                routePattern = routePattern.appending(subpathString)
            }
            return routePattern
        }
        
        // Before returning, sort them by length so that the longest and most specific routes are registered first before the less specific shorter ones.
        validSubpathRouteStrings.sort { str1, str2 in
            return str1.count > str2.count
        }
        
        return validSubpathRouteStrings
    }
    
    // TODO
    fileprivate static func routeSubpathsForPattern(_ pattern: String) -> [ParsingUtilities_RouteSubpath] {
        let subpaths = [ParsingUtilities_RouteSubpath]()
        let scanner = Scanner(string: pattern)
        
        while !scanner.isAtEnd {
            var preOptionalSubpath: String?
            guard let didScan = scanner.scanUpToString("(") else {
                fatalError("Unexpected character!")
            }
            
            if scanner.isAtEnd == false {
                // otherwise, advance past the ( character
                
            }
        }
        
        return [ParsingUtilities_RouteSubpath]()
    }
}

fileprivate class ParsingUtilities_RouteSubpath: NSObject {
    var subpathComponents = [String]()
    var isOptionalSubpath = false
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherSubpath = object as? ParsingUtilities_RouteSubpath else {
            return false
        }
        
        if subpathComponents != otherSubpath.subpathComponents {
            return false
        }
        
        if isOptionalSubpath != otherSubpath.isOptionalSubpath {
            return false
        }
        return true
    }
    
    override var hash: Int {
        return subpathComponents.hashValue ^ (isOptionalSubpath ? 1 : 0)
    }
}

fileprivate extension Array {
    func routes_allOrderedCombinations() -> [[Element]] {
        guard let lastObject = last else {
            return [[Element]]()
        }
        let subArray = Array(self[0..<count])
        let subarrayCombinations = subArray.routes_allOrderedCombinations()
        var combinations = subarrayCombinations
        
        for subarrayCombos in subarrayCombinations {
            var tmpSubarrayCombos = subarrayCombos
            tmpSubarrayCombos.append(lastObject)
            combinations.append(tmpSubarrayCombos)
        }
        return combinations
    }
    
    func routes_filter(_ filterBlock: ((Element)->Bool)) -> [Element] {
        var filteredArray = [Element]()
        for object in self {
            if filterBlock(object) {
                filteredArray.append(object)
            }
        }
        return filteredArray
    }
    
    func routes_map(_ mapBlock: ((Element)->Element)) -> [Element] {
        var mappedArray = [Element]()
        for object in self {
            let mappedObject = mapBlock(object)
            mappedArray.append(mappedObject)
        }
        return mappedArray
    }
}

fileprivate extension String {
    func routes_trimmedPathComponents() -> [String] {
        return trimmingCharacters(in: CharacterSet(charactersIn: "/")).components(separatedBy: "/")
    }
}
