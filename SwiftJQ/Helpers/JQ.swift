//
//  JQ.swift
//  SwiftJQ
//
//  Created by Eric Hyche on 11/29/17.
//  Copyright © 2017 HeirPlay Software. All rights reserved.
//

import Foundation
import jq

public class JQ {

    public class func filter(_ string: String, withFilter program: String = ".", textValueArguments: [String:String]? = nil, jsonValueArguments: [String: String]? = nil, debugTrace: Bool = false, sortKeys: Bool = false, appendLineFeed: Bool = true) -> String? {
        guard var data = string.data(using: .utf8) else {
            return nil
        }

        var program_arguments = jv_array()

        // Copy the name/value pairs (if provided)
        if let textValueArguments = textValueArguments, !textValueArguments.isEmpty {
            for (name, value) in textValueArguments {
                var arg = jv_object()
                arg = jv_object_set(arg, jv_string("name"), jv_string(name))
                arg = jv_object_set(arg, jv_string("value"), jv_string(value))
                program_arguments = jv_array_append(program_arguments, arg)
            }
        }

        // Copy the name/jsonValue pairs (if provided)
        if let jsonValueArguments = jsonValueArguments, !jsonValueArguments.isEmpty {
            for (name, value) in jsonValueArguments {
                let jsonValue = jv_parse(value)
                if jv_is_valid(jsonValue) != 0 {
                    var arg = jv_object()
                    arg = jv_object_set(arg, jv_string("name"), jv_string(name))
                    arg = jv_object_set(arg, jv_string("value"), jsonValue)
                    program_arguments = jv_array_append(program_arguments, arg)
                }
            }
        }

        // Initialize the library
        var jq = jq_init()

        // Initialize the input state object
        var input_state = jq_util_input_init(nil, nil)

        // Convert the string buffer to UTF8 and pass into the input state
        _ = data.withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<UInt8>) -> Int in
            jq_util_input_add_buffer(input_state, pointer, Int32(data.count))
            return data.count
        }

        // Set the library version
        jq_set_attr(jq, jv_string("VERSION_DIR"), jv_string("1.5"))

        // Compile the program
        let compiled = jq_compile_args(jq, program, jv_copy(program_arguments))
        guard compiled != 0 else {
            jv_free(program_arguments)
            jq_util_input_free(&input_state)
            jq_teardown(&jq)
            return nil
        }

        jq_util_input_set_parser(input_state, jv_parser_new(0), 0)

        // Let jq program read from inputs
//        jq_set_input_cb(jq, jq_util_input_next_input_cb, input_state)

        // Let jq program call `debug` builtin and have that go somewhere
//        jq_set_debug_cb(jq, debug_cb, &dumpopts)

        let jqFlags = (debugTrace ? 1 : 0)

        // Set up the output options
        var dumpOpts = JV_PRINT_SPACE2 | JV_PRINT_PRETTY
        dumpOpts &= ~JV_PRINT_COLOUR
        if sortKeys {
            dumpOpts |= JV_PRINT_SORTED
        }

        var outputStr = ""
        while jq_util_input_errors(input_state) == 0 {
            let value = jq_util_input_next_input(input_state)
            if jv_is_valid(value) != 0 {
                jq_start(jq, value, Int32(jqFlags))
                var result = jq_next(jq)
                while jv_is_valid(result) != 0 {
                    // Dump the result into a string
                    let dump_str = jv_dump_string(result, dumpOpts)
                    let dumpedStr = String(cString: jv_string_value(dump_str))
                    outputStr += dumpedStr
                    jv_free(dump_str)
                    // Append the trailing linefeed if specified
                    if appendLineFeed {
                        outputStr += "\n"
                    }

                    result = jq_next(jq)
                }
                if jv_invalid_has_msg(jv_copy(result)) != 0 {
                    // Uncaught jq exception
                    var msg = jv_invalid_get_msg(jv_copy(result))
                    let input_pos = jq_util_input_get_position(jq)
                    if jv_get_kind(msg) == JV_KIND_STRING {
                        let inputPosStr = String(cString: jv_string_value(input_pos))
                        let msgStr = String(cString: jv_string_value(msg))
                        outputStr += "jq: error (at \(inputPosStr)): \(msgStr)\n"
                    } else {
                        msg = jv_dump_string(msg, 0)
                        let inputPosStr = String(cString: jv_string_value(input_pos))
                        let msgStr = String(cString: jv_string_value(msg))
                        outputStr += "jq: error (at \(inputPosStr)): (not a string): \(msgStr)\n"
                    }
                    jv_free(input_pos)
                    jv_free(msg)
                }
                jv_free(result)
            } else if jv_invalid_has_msg(value) != 0 {
                // Parse error
                let msg = jv_invalid_get_msg(value)
                let msgStr = String(cString: jv_string_value(msg))
                outputStr += "parse error: \(msgStr)\n"
                jv_free(msg)
                break
            } else {
                break
            }
        }

        jv_free(program_arguments);
        jq_util_input_free(&input_state);
        jq_teardown(&jq);

        return outputStr
    }

}
