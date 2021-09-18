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
    func routes_allOrderedCombinations() -> [[Any]] {
        guard let lastObject = last else {
            return [[Any]]()
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
    
    func routes_filter(_ filterBlock: ((Any)->Bool)) -> [Any] {
        var filteredArray = [Any]()
        for object in self {
            if filterBlock(object) {
                filteredArray.append(object)
            }
        }
        return filteredArray
    }
    
    func routes_map(_ mapBlock: ((Any)->Any)) -> [Any] {
        var mappedArray = [Any]()
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
