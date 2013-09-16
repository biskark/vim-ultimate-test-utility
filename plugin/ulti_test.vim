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

" Global Variables {{{
if !exists('g:ulti_test_verbose')
    let g:ulti_test_verbose = 1
endif
if !exists('g:ulti_test_rethrow')
    let g:ulti_test_rethrow = 0
endif
if !exists('g:ulti_test_mode')
    let g:ulti_test_mode = 1
endif
" }}}

" Script Variables {{{
let s:test_is_running = 0
let s:test_counter = 0
let s:number_tests_passed = 0
let s:number_tests_failed = 0

" These values are reset in UltiStartTests
let s:number_expected_tests = -1
let s:number_subtests_passed = 0
let s:number_subtests_failed = 0
let s:number_subtests_skipped = 0
let s:test_name = ''

" End Script Variables }}}

" Assertion Functions {{{
" UltiAssertInString {{{
" A simple assertion of a substring match. For checks the output rather than a
" returned string.
" For checking output, use UltiAssertInOutput.
" desc is a user message that describes the test being run.
" sub is the substring being searched for, can be regex.
" string is the string being searched in.
" expectation is either 'true' or 'false' to indicate whether sub should be
" found.
" Can optionally add the string 'skip' to the end of the parameter list to
" indicate that this test should be skipped.
function! UltiAssertInString(desc, sub, string, expectation, ...)
    if g:ulti_test_mode == 0
        return
    endif
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#In_String(a:sub, a:string),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertInOutput {{{
" A simple assertion of that a given function contains the given output.
" desc is a user message that describes the test being run.
" fx is the name of the function as a string.
" arguments is a list of any arguments to be supplied to the fx.
" string is the string being searched for, can be regex.
" expectation is either 'true' or 'false' to indicate whether sub should be
" found.
" Can optionally add the string 'skip' to the end of the parameter list to
" indicate that this test should be skipped.
function! UltiAssertInOutput(desc, fx, arguments, string, expectation, ...)
    if g:ulti_test_mode == 0
        return
    endif
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#In_Output(a:fx, a:arguments, a:string),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertInBuffer {{{
" A simple assertion of a substring match in the CURRENT BUFFER.
" desc is a user message that describes the test being run.
" string is the string being searched for, can be regex.
" expectation is either 'true' or 'false' to indicate whether sub should be
" found.
" Can optionally add the string 'skip' to the end of the parameter list to
" indicate that this test should be skipped.
function! UltiAssertInBuffer(desc, string, expectation, ...)
    if g:ulti_test_mode == 0
        return
    endif
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#In_Buffer(a:string),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertInFile {{{
" A simple assertion of a substring match in the CURRENT BUFFER.
" desc is a user message that describes the test being run.
" string is the string being searched for, can be regex.
" expectation is either 'true' or 'false' to indicate whether sub should be
" found.
" Can optionally add the string 'skip' to the end of the parameter list to
" indicate that this test should be skipped.
function! UltiAssertInFile(desc, filename, string, expectation, ...)
    if g:ulti_test_mode == 0
        return
    endif
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#In_File(a:filename, a:string),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertTrue {{{
" Follows the vim definition of true which means all strings are false
" desc is a user message that describes the test being run.
" item is thing being tested
" Can optionally add the string 'skip' to the end of the parameter list to
" indicate that this test should be skipped.
function! UltiAssertTrue(desc, item, expectation, ...)
    if g:ulti_test_mode == 0
        return
    endif
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_True(a:item),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertEquals {{{
" Tests two items equivalence
" desc is a user message that describes the test being run.
" first and second are the things being tested
" Can optionally add the string 'skip' to the end of the parameter list to
" indicate that this test should be skipped.
function! UltiAssertEquals(desc, first, second, expectation, ...)
    if g:ulti_test_mode == 0
        return
    endif
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_Equals(a:first, a:second),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertEmpty {{{
" Test if string, list, or dictionary is empty
" desc is a user message that describes the test being run.
" item is thing being tested
" Can optionally add the string 'skip' to the end of the parameter list to
" indicate that this test should be skipped.
function! UltiAssertEmpty(desc, item, expectation, ...)
    if g:ulti_test_mode == 0
        return
    endif
    let skip = a:0 > 0 ? a:1 : ""
    call s:Test_Retval(ulti_test_utility#Is_Empty(a:item),
                \ a:expectation, a:desc, skip)
endfunction
" }}}
" UltiAssertException {{{
" Test if given function, submitted as a STRING, throws an exception
" desc is a user message that describes the test being run.
" error is the exception expected.
" fx is the name of the function as a string.
" arguments is a list of any arguments to be supplied to the fx.
" Can optionally add the string 'skip' to the end of the parameter list to
" indicate that this test should be skipped.
function! UltiAssertException(desc, error, fx, arguments, expectation, ...)
    if g:ulti_test_mode == 0
        return
    endif
    let skip = a:0 > 0 ? a:1 : ""
    let Fx = function(a:fx)
    let retval = 0
    let error = 0
    try
        silent call call(Fx, a:arguments)
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
" Takes two optional arguments that tells how many tests it expects to run.
" and an identifying name for that groups the following sub-tests, e.g. the
" name of the function being tested.
" The arguments can be in any order.
function! UltiTestStart(...)
    if g:ulti_test_mode == 0
        return
    endif
    if s:test_is_running
        throw "Cannot start UltiTest in the middle of another test."
    endif
    let s:test_counter += 1
    let s:test_is_running = 1
    let s:number_expected_tests = -1
    let s:number_subtests_passed = 0
    let s:number_subtests_failed = 0
    let s:number_subtests_skipped = 0

    let s:number_expected_tests = -1
    let s:test_name = ''

    if a:0 > 0 && a:0 <= 2
        for item in a:000
            if type(item) ==# type(1)
                if s:number_expected_tests >= 0
                    throw "Improper arguments: UltiTestStart() given " .
                                \ "too many integers."
                endif
                let s:number_expected_tests = item
            elseif type(item) ==# type("string")
                if s:test_name !=# ""
                    throw "Improper arguments: UltiTestStart() given " .
                                \ "too many strings."
                endif
                let s:test_name = item
            else
                throw "Improper arguments: UltiTestStart() can take only" .
                            \ " one integer and/or one string at most."
            endif
        endfor
    endif

    if g:ulti_test_verbose == 2
        if s:test_name ==# ''
            echom "Test " . s:test_counter . " Started"
        else
            echom "Test " . s:test_counter . " '" . s:test_name . "' Started"
        endif
    endif

endfunction
" }}}
" UltiTestStop {{{
" Function that locks up the testing suite
function! UltiTestStop()
    if g:ulti_test_mode == 0
        return
    endif
    if g:ulti_test_verbose == 2
        echom "Test " . s:test_counter . " Stopped"
    endif
    if s:number_subtests_failed > 0
        let s:number_tests_failed += 1
    else
        let s:number_tests_passed += 1
    endif
    let s:test_is_running = 0
endfunction
" }}}
" UltiTestReset {{{
" Function that resets variables
function! UltiTestReset()
    if g:ulti_test_mode == 0
        return
    endif
    if s:test_is_running
        throw "UltiTest: Cannot be reset while running a test."
    endif
    let s:test_counter = 0
endfunction
" }}}
" UltiTestResetAll {{{
" Function that resets variables
function! UltiTestResetAll()
    if g:ulti_test_mode == 0
        return
    endif
    call UltiTestReset()
    let s:number_tests_failed = 0
    let s:number_tests_passed = 0
endfunction
" }}}
" UltiTestReport {{{
" Function that echom's a report of all the most recently run tests
" Does not output anything except errors if g:ulti_test_verbose == 0
function! UltiTestReport()
    if g:ulti_test_mode == 0
        return
    endif
    let message = ''
    if s:test_is_running
        throw "UltiTestReport: Cannot report while tests are running."
    endif

    if s:number_expected_tests == -1
        let s:number_expected_tests = 'Not Specified'
    endif

    if g:ulti_test_verbose > 0 || s:number_subtests_failed > 0
        if s:test_name == ''
            echom "Test " . s:test_counter . " Results"
        else
            echom "Test " . s:test_counter . " '" . s:test_name . "' Results"
        endif

        echom "    Expected: " . s:number_expected_tests .
                    \ ", Passed: "  . s:number_subtests_passed .
                    \ ", Failed: "  . s:number_subtests_failed .
                    \ ", Skipped: " . s:number_subtests_skipped

        if g:ulti_test_verbose == 2
            if s:number_subtests_failed > 0
                let message = "Did not pass all sub-tests."
            else
                let message = "All sub-tests attempted passed."
            endif

            let message .= " " . s:number_subtests_skipped . " sub-test(s) skipped."

            let num_performed = (s:number_subtests_failed +
                        \ s:number_subtests_passed + s:number_subtests_skipped)

            if s:number_expected_tests >= 0 && s:number_expected_tests != num_performed
                if s:number_expected_tests > num_performed
                    let message .= " " . (s:number_expected_tests - num_performed)
                                \ . " sub-test(s) missed."
                else
                    let message .= " " . (num_performed - s:number_expected_tests)
                                \ . " extra sub-test(s) performed."
                endif
            endif
            echom "    " . message
        endif
        echom " "
    endif
endfunction
" }}}
" UltiTestFinalSummary {{{
" Function that echom's a report of all the most recently run tests
function! UltiTestFinalSummary()
    if g:ulti_test_mode == 0
        return
    endif
    if s:test_is_running
        throw "Cannot report summary if test is running."
    endif
    if s:number_tests_passed > 0 && s:number_tests_failed == 0
        echom "All " . s:number_tests_passed . " Test(s) Passed"
    elseif s:number_tests_failed > 0
        echom s:number_tests_failed . " test(s) failed."
    else
        echom "No Tests Run"
    endif
endfunction
" }}}
" UltiTestSelfUnit {{{
" Function that runs all the tests for this plugin.
function! UltiTestSelfUnit()
    call UltiTestReset()
    " Basic {{{
    call tests#test_the_tests#Test_Is_Empty()
    call tests#test_the_tests#Test_Is_Equals()
    call tests#test_the_tests#Test_Is_True()
    call tests#test_the_tests#Test_In_String()
    call tests#test_the_tests#Test_In_Buffer()
    call tests#test_the_tests#Test_In_Output()
    call tests#test_the_tests#Test_In_File()
    call tests#test_the_tests#Test_In_List()
    call tests#test_the_tests#Test_Key_In_Dict()
    call tests#test_the_tests#Test_Value_In_Dict()
    " }}}
    " " Assert Tests {{{
    " Currently not implemented as the extreme circular logic makes my head
    " hurt.
    " Instead, the basic unit tests above use the Assert Tests in total while
    " testing the core functional components that they're based off of.
    " Don't judge me too harshly for not having these.
    "
    " call tests#test_the_tests#Test_Assert_In_String()
    " call tests#test_the_tests#Test_Assert_In_Output()
    " call tests#test_the_tests#Test_Assert_In_Buffer()
    " call tests#test_the_tests#Test_Assert_True()
    " call tests#test_the_tests#Test_Assert_Equals()
    " call tests#test_the_tests#Test_Assert_Empty()
    " call tests#test_the_tests#Test_Assert_Exception()
    " " }}}
    call UltiTestFinalSummary()
    call UltiTestResetAll()
endfunction
" }}}
" UltiTestExampleUnit {{{
" Function that runs all the example tests for this plugin.
function! UltiTestExampleUnit()
    call UltiTestReset()
    
    call tests#test_the_tests#ExampleOne()
    call tests#test_the_tests#ExampleTwo()
    call tests#test_the_tests#ExampleThree()

    call UltiTestFinalSummary()
    call UltiTestResetAll()
endfunction
" }}}
" End Test Functions }}}

" Script Utility Functions {{{
" Test_Retval {{{
" Major function that checks if checks the return value of an individual
" UltiAssert, adds to the global tallies of pass, fail and skipped, and
" reports the results for each test as they happen.
" Returns 1 for pass, 0 for fail, and -1 for skip.
"
" Arguments:
" retval: (the result of an UltiAssert),
" a user given expectation (either 'true' or 'false') for the test,
" the message of the test (given by the calling UltiAssert),
" a flag that signifies if the test should be skipped, and
" an optional error message if something unexpected happened (like an 
" exception that shouldn't have been caught)
function! s:Test_Retval(retval, expectation, message, skip)
    if s:test_is_running == 0
        throw "Cannot test return value if test isn't running."
    endif
    let xval = 0
    let num_performed = s:number_subtests_passed +
                \ s:number_subtests_failed + s:number_subtests_skipped
    if a:expectation ==# 'true'
        let xval = 1
    elseif a:expectation !=# 'false'
        throw "Improper Expectation Value"
    endif

    if a:skip ==# 'skip'
        if g:ulti_test_verbose == 2
            echom "Sub-Test " . (num_performed + 1) . ': Skipped, '
                        \ . a:message
        endif
        let s:number_subtests_skipped += 1
        return -1
    else
        if a:retval != xval 
            echom "Sub-Test " . (num_performed + 1) . ': Failed, '
                        \ . a:message
            let s:number_subtests_failed += 1
            return 0
        else
            if g:ulti_test_verbose == 2
                echom "Sub-Test " . (num_performed + 1) . ': Passed, '
                            \ . a:message
            endif
            let s:number_subtests_passed += 1
            return 1
        endif
    endif
endfunction
" }}}
" End Utility Functions }}}
