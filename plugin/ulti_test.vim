" File: ulti_test.vim {{{
" Author: Kevin Biskar
" Version: 0.0.0
"
" Overview:
"     This file contains all the necessary functions for writing different
" tests for many different kinds of plugins. See the help file for a better
" overview of what is offered and how to use these.

if exists('did_ultimate_test_utility') || &cp || version < 700
    finish
endif

let did_ultimate_test_utility = 1
" }}}

" Global Mappings {{{
nnoremap <silent> <leader><space>
            \ :echo ulti_test_utility#Value_In_Dict('biskar', {'kevin': 'biskar'})<cr>
" End Global Mappings }}}

" Global Variables {{{
if !exists('g:ulti_test_verbose')
    let g:ulti_test_verbose = 0
endif
" }}}

" Script Variables {{{
let s:SUCCESS_MSG = "Ulti Test Expection Met"
let s:FAIL_MSG = "Ulti Test Expection Not Met"
let s:SKIP_MSG = "Ulti Test Skipped"
let s:LOCKED_MSG = "Must call UltiStartTests() first"
let s:locked = 1

" These values are reset in UltiStartTests
let s:test_counter = 0
let s:name_of_test = ''
let s:number_expected_tests = -1
let s:number_passed_tests = 0
let s:number_failed_tests = 0
let s:number_skipped_tests = 0

" End Script Variables }}}

" Assertion Functions {{{
" UltiAssertInString {{{
" A simple assertion of a substring match. For checks the output rather than a
" returned string.
" For checking output, use UltiAssertInOutput.
function! UltiAssertTrue(item, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_True(a:item),
                \ a:expectation, 'AssertTrue', skip)
endfunction
" }}}
" UltiAssertInOutput {{{
function! UltiAssertInOutput(fx, arguments, string, expectation, ...)
endfunction
" }}}
" UltiAssertTrue {{{
" Follows the vim definition of true which means all strings are false
function! UltiAssertTrue(item, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_True(a:item),
                \ a:expectation, 'AssertTrue', skip)
endfunction
" }}}
" UltiAssertEquals {{{
" Tests two items equivalence
function! UltiAssertEquals(first, second, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_Equals(a:first, a:second),
                \ a:expectation, 'AssertEquals', skip)
endfunction
" }}}
" UltiAssertEmpty {{{
" Test if string, list, or dictionary is empty
function! UltiAssertEmpty(item, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_Empty(a:item),
                \ a:expectation, 'AssertEmpty', skip)
endfunction
" }}}
" UltiAssertException {{{
" Test if given function, submitted as a STRING, throws an exception
" Needs Arguments as a List, not individually
function! UltiAssertException(fx, arguments, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    let Fx = function(a:fx)
    let retval = 0
    try
        call call(Fx, a:arguments)
    catch
        let retval = 1
    endtry
    call s:Test_Retval(retval, a:expectation, 'AssertException', skip)
endfunction
" }}}
" End Assertion Functions }}}

" Test Functions {{{
" UltiTestStart {{{
" Function that resets counter variables and allows Ulti Asserts to be run.
" Takes an optional argument that tells how many tests it expects to run.
function! UltiTestStart(name, ...)
    let s:test_counter += 1
    let s:locked = 0
    let s:number_expected_tests = -1
    let s:number_passed_tests = 0
    let s:number_failed_tests = 0
    let s:number_skipped_tests = 0
    let s:name_of_test = a:name
    if a:0 == 0
        let s:number_expected_tests = -1
    elseif a:0 == 1 && type(a:1) == type(1)
        let s:number_expected_tests = a:1
    else
        throw "Improper Test Specification"
    endif
endfunction
" }}}
" UltiTestStop {{{
" Function that locks up the testing suite
function! UltiTestStop()
    let s:locked = 1
endfunction
" }}}
" UltiTestReport {{{
" Function that echom's a report of all the most recently run tests
function! UltiTestReport()
    if s:locked != 1
        throw "Cannot report while tests are open."
    endif

    if s:number_expected_tests == -1
        let s:number_expected_tests = 'Not Specified'
    endif

    echom " "
    echom " "
    echom "Ultimate Unit Test Results"
    echom "--------------------------"
    echom " "
    echom "Test " . s:test_counter . ": " . '"' . s:name_of_test . '"' 
    echom " "
    if ((s:number_passed_tests + s:number_failed_tests)
                \ != s:number_expected_tests)
                \ && s:number_expected_tests != -1
        echom "Test Expectations Not Met!"
        echom "Sub-Tests Performed: " .
                    \ (s:number_passed_tests + s:number_failed_tests)
    endif
    echom "Sub-Tests Expected:  " . s:number_expected_tests
    echom " "

    echom "Sub-Tests Passed:   " . s:number_passed_tests
    echom "Sub-Tests Failed:   " . s:number_failed_tests
    echom "Sub-Tests Skipped:  " . s:number_skipped_tests

    if s:number_failed_tests == 0
        echom " "
        echom "All Sub-Tests Passed"
    endif
endfunction
" }}}
" UltiTestSelfUnit {{{
" Function that runs all the tests for this plugin.
function! UltiTestSelfUnit()
    " Basic {{{
    call tests#test_the_tests#Test_Is_Empty()
    call tests#test_the_tests#Test_Is_Equals()
    call tests#test_the_tests#Test_Is_True()
    call tests#test_the_tests#Test_In_String()
    call tests#test_the_tests#Test_In_Buffer()
    call tests#test_the_tests#Test_In_Output()
    call tests#test_the_tests#Test_In_List()
    call tests#test_the_tests#Test_Key_In_Dict()
    call tests#test_the_tests#Test_Value_In_Dict()
    " }}}
    " Assert Tests {{{
    call tests#test_the_tests#Test_Assert_In_String()
    call tests#test_the_tests#Test_Assert_In_Output()
    call tests#test_the_tests#Test_Assert_True()
    call tests#test_the_tests#Test_Assert_Equals()
    call tests#test_the_tests#Test_Assert_Empty()
    call tests#test_the_tests#Test_Assert_Exception()
    " }}}
endfunction
" }}}
" End Test Functions }}}

" Script Utility Functions {{{
" Test_Retval {{{
" Major function that checks if checks the return value of an individual
" UltiAssert, adds to the global tallies of pass, fail and skipped, and
" reports the results for each test as they happen.
"
" Arguments:
" retval: (the result of an UltiAssert),
" a user given expectation (either 'true' or 'false') for the test,
" the name of the test (given by the calling UltiAssert),
" and an optional flag that signifies if the test should be skipped.
function! s:Test_Retval(retval, expectation, name, ...)
    if s:locked
        throw s:LOCKED_MSG
    endif
    let xval = 0
    let num_performed = s:number_passed_tests +
                \ s:number_failed_tests + s:number_skipped_tests
    if a:expectation ==# 'true'
        let xval = 1
    elseif a:expectation !=# 'false'
        throw "Improper Expectation Value"
    endif

    if a:0 == 1 && a:1 ==# 'skip'
        if g:ulti_test_verbose
            echom " "
            echom 'Test "' . s:name_of_test . '" -- Sub-Test ' . (num_performed) + 1 . ' "' . a:name . '" was skipped.'
            echom " "
        endif
        let s:number_skipped_tests += 1
    else
        if a:retval == xval
            if g:ulti_test_verbose
                echom " "
                echom 'Test "' . s:name_of_test . '" -- Sub-Test ' . (num_performed + 1) . ":"
                echom s:SUCCESS_MSG . ": " . a:name . " was " . a:expectation . "."
                echom " "
            endif
            let s:number_passed_tests += 1
        else
            echom " "
            echom 'Test "' . s:name_of_test . '" -- Sub-Test ' . (num_performed + 1) . ":"
            echom s:FAIL_MSG . ": " . a:name . " was not " . a:expectation . "."
            echom " "
            let s:number_failed_tests += 1
        endif
    endif
endfunction
" }}}
" End Utility Functions }}}
