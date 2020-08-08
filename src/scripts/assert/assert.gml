/*************************************************************************************************

Copyright 2020 Rui Rosário

Permission to use, copy, modify, and/or distribute this software for any purpose with or without
fee is hereby granted, provided that the above copyright notice and this permission notice appear
in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
OF THIS SOFTWARE.

*************************************************************************************************/

/*

 Assertions are predicates that must hold true at any given point in time. They help establish the
 correctness of a running piece of software. As such, they must be versatile in their nature while
 providing enough contextual information to allow reasoning over any potential failure condition.
 This file provides the building blocks on which arbitrarily complex assertion systems can be
 built upon.

 Unlike classical assertions the assert function provided by this framework does not operate
 directly on boolean conditions. Instead, it operates on an Assertion structure that is meant to
 enclose all of the information pertaining to the evaluation of said assertion (and reporting of
 its failure). This means that usage of assert needs to go through a few extra steps, however it
 should allow for a much more versatile framework that can also be extended and plugged into any
 other libraries that might require it.

*/

// Type for assertions that perform no validation. By itself it does not provide any added value,
// with its use being mostly for default initialization of an assertion's type.
#macro ASSERTION_NONE "none"
assertion_validator(ASSERTION_NONE, function(assertion) {
  return assertion.type == ASSERTION_NONE;
});

function Assertion() constructor {
  // Assertions are meant to always be instances of this structure. Therefore, a dynamic typing
  // approach is taken with the explicit type of assertion being stored in this field. Frameworks
  // that deal with or extend this assertion framework should always check for the correct types
  // before handling any assertion.
  type = ASSERTION_NONE;

  // The entire callstack of when this assertion was generated. This ensures that the origins of
  // any assertion can be tracked throughout the entire codebase, regardless of how much the
  // assertion might be passed around.
  callstack = debug_get_callstack();
}

function assert(assertion) {
  var validator = global.assertionValidators[? assertion.type];
  if (!validator(assertion))
    throw assertion;
}

function assertion_validator(type, validator) {
  if (!variable_global_exists("assertionValidators"))
    global.assertionValidators = ds_map_create();
  if (ds_map_exists(global.assertionValidators, type))
    throw "Validator for type '" + string(type) + "' is already registered";
  global.assertionValidators[? type] = validator;
}
