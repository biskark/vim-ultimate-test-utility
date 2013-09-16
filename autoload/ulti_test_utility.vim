" File: autoload/ulti_test_utility.vim {{{
" Author: Kevin Biskar
"
" Overview:
"     File that provides several utility functions used by the main plugin
" file. This is autoloaded so that they are only called when needed.

if exists('did_auto_ultimate_test_utility') || &cp || version < 700
    finish
endif
let did_auto_ultimate_test_utility = 1
" }}}

" Utility Functions {{{
" Is_True() {{{
" Returns 1 if the string or number is 'true', 0 if not.
" Note that all strings are considered false.
function! ulti_test_utility#Is_True(item)
    if type(a:item) !=# type(1) && type(a:item) !=# type('string')
        throw "Improper Argument"
    endif
    return a:item ? 1 : 0
endfunction
" }}}
" Is_Empty() {{{
" Returns 1 if the string, list or dictionary is empty, 0 if not.
function! ulti_test_utility#Is_Empty(item)
    if type(a:item) ==# type("item")
        return a:item ==# '' ? 1 : 0
    elseif type(a:item) ==# type([])
        return a:item == []
    elseif type(a:item) ==# type({})
        return a:item == {}
    else
        throw "Improper Argument"
    endif
endfunction
" }}}
" Is_Equals() {{{
" Returns 1 if both items are equivalent, 0 if not
function! ulti_test_utility#Is_Equals(first, second)
    return a:first ==# a:second ? 1 : 0
endfunction
" }}}
" In_List() {{{
" Returns 1 if item in collection of type list or dict, 0 if not
function! ulti_test_utility#In_List(item, list)
    return index(a:list, a:item) != -1 ? 1 : 0
endfunction
" }}}
" In_File() {{{
" Returns 1 if item in file specified by filename, 0 if not.
" filename is 'string' path to file.
" string is what you're looking for, can be regex.
function! ulti_test_utility#In_File(filename, string)
    let grepstring = "lvimgrep /" . a:string . "/j" . " " . a:filename
    let retval = 1
    try
        execute grepstring
    catch /E480/
        let retval = 0
    endtry
    return retval
endfunction
" }}}
" Key_In_Dict() {{{
" Returns 1 if item in collection of type list or dict, 0 if not
function! ulti_test_utility#Key_In_Dict(item, dict)
    return ulti_test_utility#In_List(a:item, keys(a:dict))
endfunction
" }}}
" Value_In_Dict() {{{
" Returns 1 if item in collection of type list or dict, 0 if not
function! ulti_test_utility#Value_In_Dict(item, dict)
    return ulti_test_utility#In_List(a:item, values(a:dict))
endfunction
" }}}
" In_String() {{{
" Takes a substring and returns a boolean value for its presence in string
" Note that substring, if it's a properly formatted regex, will work, but will
" be dependent on personal/system settings.
function! ulti_test_utility#In_String(sub, string)
    for item in [a:sub, a:string]
        if type(item) !=# type("string")
            throw "Improper Argument"
        endif
    endfor
    if match(a:string, a:sub) >= 0
        return 1
    endif
    return 0
endfunction
" }}}
" In_Output() {{{
" Takes a function and a list of arguments (must supply an empty list if no
" arguments), and an expected string and returns 1 if the string is in the
" output or 0 otherwise. Throws exceptions if incorrect parameters passed in.
function! ulti_test_utility#In_Output(fx, arguments, string)
    let retval = 0

    " Creates a variable, output, and redir's output into it
    redir => output
    silent call call(a:fx, a:arguments, {})
    redir END
    if ulti_test_utility#In_String(a:string, output)
        let retval = 1
    endif
    return retval
endfunction
" }}}
" In_Buffer() {{{
" Takes a function and a list of arguments (must supply an empty list if no
" arguments), and an expected string and returns 1 if the string is in the
" buffer or 0 otherwise. Throws exceptions if incorrect parameters passed in.
function! ulti_test_utility#In_Buffer(string)
    " Get the current buffer's text into a variable
    let buffer = ''
    for line in getbufline("%", 0, '$')
        let buffer .= line
    endfor
    return ulti_test_utility#In_String(a:string, buffer)
endfunction
" }}}
" End Utility Functions }}}
