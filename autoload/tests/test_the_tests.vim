" File: autoload/tests/test_the_tests.vim {{{
" Author: Kevin Biskar

" Overview:
"     These are the testing functions that test this plugin. Some circular
" logic is needed as this plugin is used to test itself.  

if exists('did_auto_test_the_tests') || &cp || version < 700
    finish
endif
let did_auto_test_the_tests = 1
" }}}

" Unit Tests {{{
" For autoload/ulti_test_utility.vim {{{
" Test_Is_True {{{
function! tests#test_the_tests#Test_Is_True()
    call UltiTestStart("ulti_test_utility#Is_True()", 7)

    call UltiAssertEquals("Is_True(1) == 1",
                \ ulti_test_utility#Is_True(1), 1, 'true')
    call UltiAssertEquals("Is_True(0) == 0",
                \ ulti_test_utility#Is_True(0), 0, 'true')
    call UltiAssertEquals("Is_True('string') == 0",
                \ ulti_test_utility#Is_True('string'), 0, 'true')

    call UltiAssertException("Is_True(2.0) throws exception",
                \ "Improper Argument", 'ulti_test_utility#Is_True',
                \ [2.0], 'true')
    call UltiAssertException("Is_True() throws exception",
                \ "Not enough arguments", 'ulti_test_utility#Is_True',
                \ [], 'true')
    call UltiAssertException("Is_True(1) doesn't throw exception",
                \ "", 'ulti_test_utility#Is_True',
                \ [1], 'false')
    call UltiAssertException("Is_True({}) throws exception",
                \ "Improper Argument", 'ulti_test_utility#Is_True',
                \ [{}], 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Is_Empty {{{
function! tests#test_the_tests#Test_Is_Empty()
    call UltiTestStart(9, "ulti_test_utility#Is_Empty")

    " Strings
    call UltiAssertTrue("Is_Empty('T') == 0",
                \ ulti_test_utility#Is_Empty("T"), 'false')
    call UltiAssertTrue("Is_Empty('Test') == 0",
                \ ulti_test_utility#Is_Empty("Test"), 'false')
    call UltiAssertTrue("Is_Empty('') == 1",
                \ ulti_test_utility#Is_Empty(""), 'true')
    " L==ts
    call UltiAssertTrue("Is_Empty([]) == 1",
                \ ulti_test_utility#Is_Empty([]), 'true')
    call UltiAssertTrue("Is_Empty(['Test']) == 0",
                \ ulti_test_utility#Is_Empty(['Test']), 'false')
    " Dictionaries
    call UltiAssertTrue("Is_Empty({}) == 1",
                \ ulti_test_utility#Is_Empty({}), 'true')
    call UltiAssertTrue("Is_Empty({'Test': 'Case'}) == 0",
                \ ulti_test_utility#Is_Empty({'Test': 'Case'}), 'false')
    " Other
    call UltiAssertException("Is_Empty(0) throws exception",
                \ 'Improper Argument', 'ulti_test_utility#Is_Empty',
                \ [0], 'true')
    call UltiAssertException("Is_Empty() throws exception",
                \ 'Not enough arguments', 'ulti_test_utility#Is_Empty',
                \ [], 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Is_Equals {{{
function! tests#test_the_tests#Test_Is_Equals()
    call UltiTestStart(17, "ulti_test_utility#Is_Equals")

    " Strings
    call UltiAssertTrue("Is_Equals('string', 'string') == 1",
                \ ulti_test_utility#Is_Equals("string", "string"), 'true')
    call UltiAssertTrue("Is_Equals('String', 'string') == 0", 
                \ ulti_test_utility#Is_Equals("String", "string"), 'false')
    call UltiAssertTrue("Is_Equals('', '') == 1",
                \ ulti_test_utility#Is_Equals("", ""), 'true')
    " Numbers
    call UltiAssertTrue("Is_Equals(1, 1) == 1",
                \ ulti_test_utility#Is_Equals(1, 1), 'true')
    call UltiAssertTrue("Is_Equals(0, 0) == 1",
                \ ulti_test_utility#Is_Equals(0, 0), 'true')
    call UltiAssertTrue("Is_Equals(0, 1) == 1",
                \ ulti_test_utility#Is_Equals(0, 1), 'false')
    call UltiAssertTrue("Is_Equals(1.0, 1) == 1",
                \ ulti_test_utility#Is_Equals(1.0, 1), 'true')
    call UltiAssertTrue("Is_Equals(-2.1, -2.1) == 1",
                \ ulti_test_utility#Is_Equals(1.0, 1), 'true')
    " Lists
    call UltiAssertTrue("Is_Equals([], []) == 1",
                \ ulti_test_utility#Is_Equals([], []), 'true')
    call UltiAssertTrue("Is_Equals([''], []) == 0",
                \ ulti_test_utility#Is_Equals([""], []), 'false')
    call UltiAssertTrue("Is_Equals(['Test', ['Test']) == 1",
                \ ulti_test_utility#Is_Equals(['Test'], ['Test']), 'true')
    call UltiAssertTrue("Is_Equals(['test'], ['Test']) == 0",
                \ ulti_test_utility#Is_Equals(['test'], ['Test']), 'false')
    call UltiAssertTrue("Is_Equals(['Test', 'case'], ['Test', 'case']) == 1",
                \ ulti_test_utility#Is_Equals(['Test', 'case'],
                \ ['Test', 'case']), 'true')
    " Dictionaries
    call UltiAssertTrue("Is_Equals({}, {}) == 1",
                \ ulti_test_utility#Is_Equals({}, {}), 'true')
    call UltiAssertTrue("Is_Equals({'Test': 'Case'}, {'Test': 'Case'}) == 1",
                \ ulti_test_utility#Is_Equals({'Test': 'Case'},
                \ {'Test': 'Case'}), 'true')
    call UltiAssertTrue("Is_Equals({'Test': 'Case'}, {'Test': 'case'}) == 0",
                \ ulti_test_utility#Is_Equals({'Test': 'Case'},
                \ {'Test': 'case'}), 'false')
    call UltiAssertTrue("Is_Equals({'Test': 'Case'}, {'test': 'Case'}) == 0",
                \ ulti_test_utility#Is_Equals({'Test': 'Case'},
                \ {'test': 'Case'}), 'false')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_In_List {{{
function! tests#test_the_tests#Test_In_List()
    call UltiTestStart(14, "ulti_test_utility#In_List")

    " Simple
    call UltiAssertTrue("In_List('string', ['string']) == 1",
                \ ulti_test_utility#In_List('string', ['string']), 'true')
    call UltiAssertTrue("In_List('', ['string']) == 0",
                \ ulti_test_utility#In_List('', ['string']), 'false')
    call UltiAssertTrue("In_List('string', []) == 0",
                \ ulti_test_utility#In_List('string', []), 'false')
    call UltiAssertTrue("In_List('string', ['']) == 0",
                \ ulti_test_utility#In_List('string', ['']), 'false')
    call UltiAssertTrue("In_List(1, ['1']) == 0",
                \ ulti_test_utility#In_List(1, ['1']), 'false')
    call UltiAssertTrue("In_List(1, [1,
                \ 2, 3]) == 1", ulti_test_utility#In_List(1, [1, 2, 3]), 'true')
    call UltiAssertTrue("In_List(1.1, [1.1,
                \ 2, 3]) == 1", ulti_test_utility#In_List(1.1, [1.1, 2, 3]), 'true')

    " List in Lists
    call UltiAssertTrue(
                \ "In_List(['string', 'test'], [['string', 'test']]) == 1",
                \ ulti_test_utility#In_List(['string', 'test'],
                \ [['string', 'test'], 'string']), 'true')
    call UltiAssertTrue(
                \ "In_List('test', [['string', 'test']]) == 0",
                \ ulti_test_utility#In_List('test', [['string', 'test']]),
                \ 'false')

    " Dict in Lists
    call UltiAssertTrue("In_List({'test': 'case'}, [{'test': 'case'}," . 
                \ " 'string']) == 1",
                \ ulti_test_utility#In_List({'test': 'case'},
                \ [{'test': 'case'}, 'string']), 'true')
    call UltiAssertTrue("In_List({'test': 'no'}, [{'test': 'case'}," .
                \ " 'string']) == 0",
                \ ulti_test_utility#In_List({'test': 'no'},
                \ [{'test': 'case'}, 'string']), 'false')

    " Exceptions
    call UltiAssertException("In_List([1, [1]]) doesn't throw error",
                \ 'List required', "ulti_test_utility#In_List", [1, [1]],
                \ 'false')
    call UltiAssertException("In_List([1, 1]) throws error", 
                \ 'List required', "ulti_test_utility#In_List", [1, 1],
                \ 'true')
    call UltiAssertException("In_List([1]) throws 'Note enough arguments'",
                \ 'Not enough arguments', "ulti_test_utility#In_List", [1],
                \ 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_In_String {{{
function! tests#test_the_tests#Test_In_String()
    call UltiTestStart("ulti_test_utility#In_String", 8)

    " Simple
    call UltiAssertTrue("In_String('string', 'string') == 1",
                \ ulti_test_utility#In_String('string', 'string'), 'true')
    call UltiAssertTrue("In_String('', 'string') == 1",
                \ ulti_test_utility#In_String('', 'string'), 'true')
    call UltiAssertTrue("In_String('string', 'big strings') == 1",
                \ ulti_test_utility#In_String('string', 'big strings'), 'true')
    call UltiAssertTrue("In_String('strings', 'big string') == 0",
                \ ulti_test_utility#In_String('strings', 'big string'), 'false')
    call UltiAssertTrue("In_String('String', 'big string') == 0",
                \ ulti_test_utility#In_String('String', 'big string'), 'false')

    " Exceptions
    call UltiAssertException("In_String(1, [1]) throws Improper Argument",
                \ 'Improper Argument', "ulti_test_utility#In_String", [1, [1]],
                \ 'true')
    call UltiAssertException("In_String(1, 1) throws Improper Argument",
                \ 'Improper Argument', "ulti_test_utility#In_String", [1, 1],
                \ 'true')

    " Regex
    call UltiAssertTrue("In_String('\v\d{4}', 'a12b1234') == 1",
                \ ulti_test_utility#In_String('\v\d{4}', 'a12b1234'), 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_In_Output {{{
function! tests#test_the_tests#Test_In_Output()
    call UltiTestStart("ulti_test_utility#In_Output", 6)

    call UltiAssertTrue("In_Output catches echo 'Hello'",
                \ ulti_test_utility#In_Output("tests#test_the_tests#EchoHello",
                \ [], 'Hello'), 'true')
    call UltiAssertTrue("In_Output doesn't catch 'Bye' when echoing 'Hello'",
                \ ulti_test_utility#In_Output("tests#test_the_tests#EchoHello",
                \ [], 'Bye'), 'false')
    call UltiAssertTrue("In_Output catches echom 'Hello'",
                \ ulti_test_utility#In_Output("tests#test_the_tests#EchomHello",
                \ [], 'Hello'), 'true')
    call UltiAssertTrue("In_Output doesn't catch 'Bye' when echoming 'Hello'",
                \ ulti_test_utility#In_Output("tests#test_the_tests#EchomHello",
                \ [], 'Bye'), 'false')
    call UltiAssertTrue("In_Output catches echo 'Bye'",
                \ ulti_test_utility#In_Output("tests#test_the_tests#EchoBye",
                \ [], 'Bye'), 'true')
    call UltiAssertTrue("In_Output doesn't catch previous 'Hello'",
                \ ulti_test_utility#In_Output("tests#test_the_tests#EchoBye",
                \ [], 'Hello'), 'false')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_In_Buffer {{{
function! tests#test_the_tests#Test_In_Buffer()
    call UltiTestStart("ulti_test_utility#In_Buffer", 2)

    call UltiAssertTrue("In_Buffer('xxxxxxx') == 0 before writing it",
                \ ulti_test_utility#In_Buffer('xxxxxxx'), 'false')
    " Adding Text and Testing Again
    normal ixxxxxxx
    call UltiAssertTrue("In_Buffer('xxxxxxx') == 1 after writing it",
                \ ulti_test_utility#In_Buffer('xxxxxxx'), 'true')
    normal 7hd7l

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_In_File {{{
function! tests#test_the_tests#Test_In_File()
    call UltiTestStart("ulti_test_utility#In_File", 4)

    let filename = 'hello.txt'
    let error = 0
    " Check for unused file name so we don't clobber a file just for an
    " example
    if findfile(filename) == ''
        try
            call writefile([], filename)
        catch
            echom "File '" . filename .
                        \ "' cannot be written to. Skipping entire test."
            let error = 1
            if exists('g:ulti_test_rethrow') && g:ulti_test_rethrow
                throw v:exception
            endif
        endtry
            
        " Essentially an else to the try clause
        if error == 0
            call UltiAssertTrue("In_File('hello.txt', 'hello') == 0 " .
                        \ "before writing to it",
                        \ ulti_test_utility#In_File(filename, 'hello'), 'false')

            call system("echo 'hello' > " . filename)
            call UltiAssertTrue("In_File('hello.txt', 'hello') == 1 " .
                        \ "after writing to it",
                        \ ulti_test_utility#In_File(filename, 'hello'), 'true')

            call UltiAssertTrue("In_File('hello.txt', 'false') == 0",
                        \ ulti_test_utility#In_File(filename, 'bye'), 'false')
            call delete(filename)

            call UltiAssertInOutput("In_File yells when file doesn't exist",
                        \ "ulti_test_utility#In_File", [filename, 'hello'],
                        \ "Cannot open file", 'true')
        endif
        call UltiTestStop()
        call UltiTestReport()
    else
        call UltiTestStop()
        echom "Skipping example tests because file '" . filename . "' already exists."
        echom " "
    endif

endfunction
" }}}
" Test_Key_In_Dict {{{
function! tests#test_the_tests#Test_Key_In_Dict()
    call UltiTestStart("ulti_test_utility#Key_In_Dict", 5)

    call UltiAssertTrue("Key_In_Dict('string', {'string': 'test'}) == 1",
                \ ulti_test_utility#Key_In_Dict('string',
                \ {'string': 'test'}), 'true')
    call UltiAssertTrue("Key_In_Dict('string', {'test': 'string'}) == 0",
                \ ulti_test_utility#Key_In_Dict('string',
                \ {'test': 'string'}), 'false')
    call UltiAssertTrue("Key_In_Dict(1, {1: ''}) == 0",
                \ ulti_test_utility#Key_In_Dict(1,
                \ {1: ''}), 'false')
    call UltiAssertTrue("Key_In_Dict('1', {1: ''}) == 1",
                \ ulti_test_utility#Key_In_Dict('1',
                \ {1: ''}), 'true')
    call UltiAssertException("Key_In_Dict([1, 2], [2]) throws error",
                \ 'Dictionary required', 'ulti_test_utility#Key_In_Dict',
                \ [[1,2], [2]], 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Value_In_Dict {{{
function! tests#test_the_tests#Test_Value_In_Dict()
    call UltiTestStart("ulti_test_utility#Value_In_Dict", 7)

    call UltiAssertTrue("Value_In_Dict('string', {'string': 'test'}) == 0",
                \ ulti_test_utility#Value_In_Dict('string',
                \ {'string': 'test'}), 'false')
    call UltiAssertTrue("Value_In_Dict('string', {'test': 'string'}) == 1",
                \ ulti_test_utility#Value_In_Dict('string',
                \ {'test': 'string'}), 'true')
    call UltiAssertTrue("Value_In_Dict(1, {1: ''}) == 1",
                \ ulti_test_utility#Value_In_Dict(1,
                \ {1: ''}), 'false')
    call UltiAssertTrue("Value_In_Dict(1, {'key': 1}) == 1",
                \ ulti_test_utility#Value_In_Dict(1,
                \ {'key': 1}), 'true')
    call UltiAssertTrue("Value_In_Dict(1, {'key': '1'}) == 0",
                \ ulti_test_utility#Value_In_Dict(1,
                \ {'key': '1'}), 'false')
    call UltiAssertTrue("Value_In_Dict('1', {'key': 1) == 0",
                \ ulti_test_utility#Value_In_Dict('1',
                \ {'key': 1}), 'false')
    call UltiAssertException("Value_In_Dict([1,2], [2]) throws error.",
                \ "Dictionary required", 'ulti_test_utility#Value_In_Dict',
                \ [[1,2], [2]], 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" }}}

" For plugin/ulti_test.vim {{{

" Test_Assert_In_String {{{
function! tests#test_the_tests#Test_Assert_In_String()
    call UltiTestStart("UltiAssertInString()")

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Assert_In_Output {{{
function! tests#test_the_tests#Test_Assert_In_Output()
    call UltiTestStart("UltiAssertInOutput()")

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Assert_In_Buffer {{{
function! tests#test_the_tests#Test_Assert_In_Output()
    call UltiTestStart("UltiAssertInBuffer()")

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Assert_True {{{
function! tests#test_the_tests#Test_Assert_True()
    call UltiTestStart("UltiAssertTrue")

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Assert_Equals {{{
function! tests#test_the_tests#Test_Assert_Equals()
    call UltiTestStart("UltiAssertEquals()")

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Assert_Empty {{{
function! tests#test_the_tests#Test_Assert_Empty()
    call UltiTestStart("UltiAssertEmpty()")
    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Assert_Exception {{{
function! tests#test_the_tests#Test_Assert_Exception()
    call UltiTestStart("UltiAssertException")
    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" }}}
" }}}

" Sample Functions to Test With {{{
function! tests#test_the_tests#EchoHello()
    echo "Hello"
endfunction

function! tests#test_the_tests#EchomHello()
    echom "Hellom"
endfunction

function! tests#test_the_tests#EchoBye(...)
    if a:0 == 1
        echo "Bye, " a:1
    else
        echo "Bye, stranger"
    endif
endfunction

function! tests#test_the_tests#InsertHello()
    execute 'normal! iHello World'
endfunction

" Sets a new mapping then tests it
function! tests#test_the_tests#NewMapping()
    nnoremap <silent> <leader>S :call tests#test_the_tests#InsertHello()<cr>
endfunction
    
" }}}

" Example Test Functions {{{
" ExampleOne() -- AssertInBuffer for testing mapping that inserts text {{{
function! tests#test_the_tests#ExampleOne()
    call UltiTestStart('Testing Command Mapping and Text Insertion', 3)

    if exists('mapleader')
        let leader = mapleader
    else
        let leader = '\'
    endif

    call tests#test_the_tests#NewMapping()

    call UltiAssertInBuffer('Testing for "Hello World" absence before execute',
                \ 'Hello World', 'false')

    execute 'normal! ' . leader . 'S'
    call UltiAssertInBuffer('Testing for "Hello World" absence after normal!',
                \ 'Hello World', 'false')

    execute 'normal ' . leader . 'S'
    call UltiAssertInBuffer('Testing for "Hello World" presence after normal',
                \ 'Hello World', 'true')
    
    execute "s/Hello World//"

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" ExampleTwo() -- AssertInOutput for testing mapping that echos text {{{
function! tests#test_the_tests#ExampleTwo()
    call UltiTestStart('Checking for appropriate output of EchoBye()', 5)

    call UltiAssertInOutput("Doesn't output hello",
                \ 'tests#test_the_tests#EchoBye', [], 'Hello',
                \ 'false')
    call UltiAssertInOutput("Does output Bye",
                \ 'tests#test_the_tests#EchoBye', [], 'Bye',
                \ 'true')
    call UltiAssertInOutput("Does output 'stranger' if no arguments",
                \ 'tests#test_the_tests#EchoBye', [], 'stranger',
                \ 'true')
    call UltiAssertInOutput("Doesn't output 'stranger' if 1 argument",
                \ 'tests#test_the_tests#EchoBye', ['Kevin'], 'stranger',
                \ 'false')
    call UltiAssertInOutput("Does output 'Kevin' if 'Kevin' in arguments",
                \ 'tests#test_the_tests#EchoBye', ['Kevin'], 'Kevin',
                \ 'true')
    call UltiAssertInOutput("Echoes your favorite food without even asking",
                \ 'tests#test_the_tests#EchoBye', ['Kevin'],
                \ 'Bye Kevin, your favorite food is cereal',
                \ 'true',
                \ 'skip')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" ExampleThree() -- AssertInFile for testing file checks {{{
function! tests#test_the_tests#ExampleThree()
    call UltiTestStart('Checking that WriteToFile works')

    let filename = 'hello.txt'
    call UltiAssertInFile("hello.txt doesn't contain bye",
                \ filename, 'bye',
                \ 'false',
                \ 'skip')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" }}}
