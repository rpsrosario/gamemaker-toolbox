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

 Simple mechanism to extend a structure with aspects from another structure.

*/

// Extends the target structure with all of the fields and methods in the source structure.
// Methods that use the source structure as self are copied over with self redirected to the
// target structure to keep the method's semantics intact.
function extend_with(target, source) {
  var names = variable_struct_get_names(source);
  var count = array_length(names);
  for (var i = 0; i < count; i++) {
    var value = variable_struct_get(source, names[i]);
    if (is_method(value) && method_get_self(value) == source) {
      variable_struct_set(target, names[i], method(target, value));
    } else {
      variable_struct_set(target, names[i], value);
    }
  }
}
