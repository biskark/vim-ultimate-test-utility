" File: ulti_test_utility.vim
" Author: Kevin Biskar
" Version: 0.0.0
"
" DO NOT MODIFY THIS FILE DIRECTLY.

if exists('did_ultimate_test_utility') || &cp || version < 700
    finish
endif
let did_ultimate_test_utility = 1

function! ulti_test_utility#Hello()
    echom 'Hello'
endfunction

" Utility Function {{{

" Is_True() {{{
" Returns 1 if the given number or string is 'true', 0 otherwise, -1 if
" incorrect argument passed
function! ulti_test_utility#Is_True(first)
    if type(a:first) !=# type(1) && type(a:first) !=# type("string")
        return -1
    endif
    return a:first ? 1 : 0
endfunction
" }}}

" Is_Empty() {{{
" Returns 1 if the string, list or dictionary is empty,
" 0 if not, -1 if not string
function! ulti_test_utility#Is_Empty(item)
    if type(a:item) ==# type("item")
        return a:item ==# '' ? 1 : 0
    elseif type(a:item) ==# type([])
        return a:item == []
    elseif type(a:item) ==# type({})
        return a:item == {}
    else
        return -1
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
" Returns 1 if item in collection of type list or dict, 0 if not, or -1 if
" second argument isn't a list
function! ulti_test_utility#In_List(item, list)
    return index(a:list, a:item) != -1 ? 1 : 0
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

" End Utility Functions }}}
