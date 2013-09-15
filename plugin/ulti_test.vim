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
if !exists('g:ulti_test_rethrow')
    let g:ulti_test_rethrow = 0
endif
" }}}

" Script Variables {{{
let s:locked = 1
let s:test_counter = 0

" These values are reset in UltiStartTests
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
" desc is a user message that describes the test being run.
function! UltiAssertTrue(desc, item, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_True(a:item),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertInOutput {{{
function! UltiAssertInOutput(desc, fx, arguments, string, expectation, ...)
endfunction
" }}}
" UltiAssertTrue {{{
" Follows the vim definition of true which means all strings are false
function! UltiAssertTrue(desc, item, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_True(a:item),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertEquals {{{
" Tests two items equivalence
function! UltiAssertEquals(desc, first, second, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_Equals(a:first, a:second),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertEmpty {{{
" Test if string, list, or dictionary is empty
function! UltiAssertEmpty(desc, item, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_Empty(a:item),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertException {{{
" Test if given function, submitted as a STRING, throws an exception
" The execption expected is the error argument.
" Needs Arguments as a List, not individually
function! UltiAssertException(desc, error, fx, arguments, expectation, ...)
    let skip = a:0 > 0 ? a:1 : ""
    let Fx = function(a:fx)
    let retval = 0
    let error = 0
    try
        call call(Fx, a:arguments)
    catch
        if ulti_test_utility#In_String(a:error, v:exception)
            let retval = 1
        else
            error = 1
            if g:ulti_test_rethrow
                throw v:exception
            endif
        endif
    endtry
    call s:Test_Retval(retval, a:expectation, a:desc, skip)
    if error
        echom "    Unexpected Exception thrown: " . v:exception
    endif
endfunction
" }}}
" End Assertion Functions }}}

" Test Functions {{{
" UltiTestStart {{{
" Function that resets counter variables and allows Ulti Asserts to be run.
" Takes an optional argument that tells how many tests it expects to run.
function! UltiTestStart(...)
    let s:test_counter += 1
    let s:locked = 0
    let s:number_expected_tests = -1
    let s:number_passed_tests = 0
    let s:number_failed_tests = 0
    let s:number_skipped_tests = 0
    echom " "
    echom "Test " . s:test_counter . " Started"
    if a:0 == 0
        let s:number_expected_tests = -1
    elseif a:0 == 1 && type(a:1) == type(1) && a:1 >= 0
        let s:number_expected_tests = a:1
    else
        throw "UltiTestStart Error: If plan given, must be an integer >= 0."
    endif
endfunction
" }}}
" UltiTestStop {{{
" Function that locks up the testing suite
function! UltiTestStop()
    echom "Test " . s:test_counter . " Stopped"
    let s:locked = 1
endfunction
" }}}
" UltiTestReset {{{
" Function that resets variables
function! UltiTestReset()
    if s:locked != 1
        throw "UltiTest: Cannot reset while running a test."
    endif
    let s:test_counter = 0
    echom "UltiTestUtility Reset"
endfunction
" }}}
" UltiTestReport {{{
" Function that echom's a report of all the most recently run tests
function! UltiTestReport()
    let message = ''
    if s:locked != 1
        throw "UltiTestReport: Cannot report while tests are open."
    endif

    if s:number_expected_tests == -1
        let s:number_expected_tests = 'Not Specified'
    endif

    echom "Test " . s:test_counter . " Results"
    echom "    Expected: " . s:number_expected_tests .
                \ ", Passed: "  . s:number_passed_tests .
                \ ", Failed: "  . s:number_failed_tests .
                \ ", Skipped: " . s:number_skipped_tests

    if s:number_failed_tests > 0
        let message = "Did not pass all sub-tests."
    else
        let message = "All sub-tests attempted passed."
    endif

    let message .= " " . s:number_skipped_tests . " sub-test(s) skipped."

    let num_performed = (s:number_failed_tests +
                \ s:number_passed_tests + s:number_skipped_tests)

    if s:number_expected_tests >= 0 && s:number_expected_tests != num_performed
        if s:number_expected_tests > num_performed
            let message .= " " . (s:number_expected_tests - num_performed)
                        \ . " sub-test(s) missed."
        else
            let message .= " " . (num_performed - s:number_expected_tests)
                        \ . " extra sub-test(s) performed."
        endif
    endif
    echom message
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

    call UltiTestReset()
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
" the message of the test (given by the calling UltiAssert),
" a flag that signifies if the test should be skipped, and
" an optional error message if something unexpected happened (like an 
" exception that shouldn't have been caught)
function! s:Test_Retval(retval, expectation, message, skip)
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

    if a:skip ==# 'skip'
        if g:ulti_test_verbose
            echom "Sub-Test " . (num_performed + 1) . ': ' . a:message .
                        \ ', skipped.'
        endif
        let s:number_skipped_tests += 1
    else
        if a:retval != xval 
            echom "Sub-Test " . (num_performed + 1) . ': ' . a:message .
                        \ ', failed.'
            let s:number_failed_tests += 1
        else
            if g:ulti_test_verbose
                echom "Sub-Test " . (num_performed + 1) . ': ' . a:message .
                            \ ', passed.'
            endif
            let s:number_passed_tests += 1
        endif
    endif
endfunction
" }}}
" End Utility Functions }}}
