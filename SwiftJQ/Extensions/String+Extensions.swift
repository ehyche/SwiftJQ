import Foundation

extension String {

    public func jqFilter(_ program: String, textValueArguments: [String:String]? = nil, jsonValueArguments: [String: String]? = nil, debugTrace: Bool = false, sortKeys: Bool = false, appendLineFeed: Bool = true) -> String? {
        return JQ.filter(self, withFilter: program, textValueArguments: textValueArguments, jsonValueArguments: jsonValueArguments, debugTrace: debugTrace, sortKeys: sortKeys, appendLineFeed: appendLineFeed)
    }

}
