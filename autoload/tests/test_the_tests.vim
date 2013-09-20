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

    let l:fx = 'ulti_test_utility#Is_True'
    call UltiAssertEquals("Is_True(1) == 1",
                \ ulti_test_utility#Is_True(1), 1, 'true')
    call UltiAssertEquals("Is_True(0) == 0",
                \ ulti_test_utility#Is_True(0), 0, 'true')
    call UltiAssertEquals("Is_True('string') == 0",
                \ ulti_test_utility#Is_True('string'), 0, 'true')

    call UltiAssertException("Is_True(2.0) throws exception",
                \ l:fx, [2.0], "Improper Argument", 'true')
    call UltiAssertException("Is_True() throws exception",
                \ l:fx, [], "Not enough arguments", 'true')
    call UltiAssertException("Is_True(1) doesn't throw exception",
                \ l:fx, [1], "", 'false')
    call UltiAssertException("Is_True({}) throws exception",
                \ l:fx, [{}], "Improper Argument", 'true')

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
    " Exceptions
    let l:fx = 'ulti_test_utility#Is_Empty'
    call UltiAssertException("Is_Empty(0) throws exception",
                \ l:fx, [0], 'Improper Argument', 'true')
    call UltiAssertException("Is_Empty() throws exception",
                \ l:fx, [], 'Not enough arguments', 'true')

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
    let l:fx = 'ulti_test_utility#In_List'
    call UltiAssertException("In_List([1, [1]]) doesn't throw error",
                \ l:fx, [1, [1]], 'List required', 'false')
    call UltiAssertException("In_List([1, 1]) throws error", 
                \ l:fx, [1, 1], 'List required', 'true')
    call UltiAssertException("In_List([1]) throws 'Note enough arguments'",
                \ l:fx, [1],'Not enough arguments', 'true')

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
    let l:fx = 'ulti_test_utility#In_String'
    call UltiAssertException("In_String(1, [1]) throws Improper Argument",
                \ l:fx, [1, [1]], 'Improper Argument', 'true')
    call UltiAssertException("In_String(1, 1) throws Improper Argument",
                \ l:fx, [1, 1], 'Improper Argument', 'true')

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
                \ 'ulti_test_utility#Key_In_Dict',
                \ [[1,2], [2]], 'Dictionary required', 'true')

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
                \ 'ulti_test_utility#Value_In_Dict', [[1,2], [2]],
                \ "Dictionary required", 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" }}}

" For plugin/ulti_test.vim {{{
" Test_Ulti_Test_StoreRestore {{{
function! tests#test_the_tests#Test_Ulti_Test_StoreRestore()
    call UltiTestStart("Tests for interaction between Store and Restore", 49)
    " Single variable tests {{{
    " Test a provided global variable
    let l:var1 = g:ulti_test_rethrow
    call UltiTestStore('g:ulti_test_rethrow')
    call UltiAssertEquals("UltiTestStore doesn't change the passed in variable",
                \ l:var1, g:ulti_test_rethrow, 'true')
    let g:ulti_test_rethrow = g:ulti_test_rethrow ? 0 : 1
    call UltiAssertEquals("Variable has been changed",
                \ l:var1, g:ulti_test_rethrow, 'false')
    call UltiTestRestore('g:ulti_test_rethrow')
    call UltiAssertEquals("Variable has been changed back",
                \ l:var1, g:ulti_test_rethrow, 'true')
    let g:ulti_test_rethrow = l:var1  " Isn't necessary if the last test passed

    " Same test but with different calling technique
    call UltiTestStore(['g:ulti_test_rethrow'])
    call UltiAssertEquals("UltiTestStore doesn't change the passed in " .
                \ "variable in a List", l:var1, g:ulti_test_rethrow, 'true')
    let g:ulti_test_rethrow = g:ulti_test_rethrow ? 0 : 1
    call UltiAssertEquals("Variable has been changed, again",
                \ l:var1, g:ulti_test_rethrow, 'false')
    call UltiTestRestore()
    call UltiAssertEquals("Variable has been changed back, using no arguments",
                \ l:var1, g:ulti_test_rethrow, 'true')
    " }}}
    " Multiple variable tests {{{
    " As raw arguments
    let l:var2 = g:ulti_test_rethrow
    let l:var3 = g:syntax_on
    let l:var4 = 'g:UltiTestForNonExistentPurposesPleaseDontNameAVariableThis'
    call UltiTestStore('g:ulti_test_rethrow', 'g:syntax_on', l:var4)
    let g:ulti_test_rethrow = g:ulti_test_rethrow ? 0 : 1
    call UltiAssertEquals('rethrow changed', l:var2, g:ulti_test_rethrow,
                \ 'false')
    let g:syntax_on = g:syntax_on ? 0 : 1
    call UltiAssertEquals('syntax_on changed', l:var3, g:syntax_on, 'false')
    call UltiAssertTrue("Var with long name doesn't exist", exists(l:var4),
                \ 'false')
    execute "let " . l:var4 . " = 1"
    call UltiAssertTrue("Var with long name now exists", exists(l:var4),
                \ 'true')
    call UltiTestRestore('g:ulti_test_rethrow', l:var4)
    call UltiAssertEquals('rethrow restored in first call to Restore', l:var2,
                \ g:ulti_test_rethrow, 'true')
    call UltiAssertTrue("Var with long name no longer exists again after " .
                \ "first call to Restore", exists(l:var4), 'false')
    call UltiAssertEquals('syntax_on not restored in first call to Restore',
                \ l:var3, g:syntax_on, 'false')
    call UltiTestRestore('g:syntax_on')
    call UltiAssertEquals('syntax_on restored in second call to Restore',
                \ l:var3, g:syntax_on, 'true')
    let g:ulti_test_rethrow = l:var2
    let g:syntax_on = l:var3
    " }}}
    " As a list of arguments {{{
    call UltiTestStore(['g:ulti_test_rethrow', 'g:syntax_on', l:var4])
    let g:ulti_test_rethrow = g:ulti_test_rethrow ? 0 : 1
    call UltiAssertEquals('rethrow changed after stored with List', l:var2, g:ulti_test_rethrow,
                \ 'false')
    let g:syntax_on = g:syntax_on ? 0 : 1
    call UltiAssertEquals('syntax_on changed after stored with List', l:var3, g:syntax_on, 'false')
    call UltiAssertTrue("Var with long name doesn't exist after stored " .
                \ "with List", exists(l:var4), 'false')
    execute "let " . l:var4 . " = 1"
    call UltiAssertTrue("Var with long name now exists after stored with " .
                \ " List", exists(l:var4), 'true')
    call UltiTestRestore(['g:ulti_test_rethrow', 'g:syntax_on', l:var4])
    call UltiAssertEquals('rethrow restored after stored with List', l:var2,
                \ g:ulti_test_rethrow, 'true')
    call UltiAssertEquals('syntax_on restored after stored with List', l:var3,
                \ g:syntax_on, 'true')
    call UltiAssertTrue("Var with long name no longer exists again after " .
                \ "stored with List", exists(l:var4), 'false')
    let g:ulti_test_rethrow = l:var2
    let g:syntax_on = l:var3
    " }}}
    " As a list of lists of arguments for Store and no specifics for Stop {{{
    call UltiTestStore(['g:ulti_test_rethrow', ['g:syntax_on', l:var4]])
    let g:ulti_test_rethrow = g:ulti_test_rethrow ? 0 : 1
    call UltiAssertEquals('rethrow changed after stored with List in List',
                \ l:var2, g:ulti_test_rethrow, 'false')
    let g:syntax_on = g:syntax_on ? 0 : 1
    call UltiAssertEquals('syntax_on changed after stored with List in List',
                \ l:var3, g:syntax_on, 'false')
    call UltiAssertTrue("Var with long name doesn't exist after stored " .
                \ "with List in List", exists(l:var4), 'false')
    execute "let " . l:var4 . " = 1"
    call UltiAssertTrue("Var with long name now exists after stored with " .
                \ "List in List", exists(l:var4), 'true')
    call UltiTestRestore()
    call UltiAssertEquals('rethrow restored after no argument Restore', l:var2,
                \ g:ulti_test_rethrow, 'true')
    call UltiAssertEquals('syntax_on restored after no argument Restore',
                \ l:var3, g:syntax_on, 'true')
    call UltiAssertTrue("Var with long name no longer exists after no " .
                \ "argument Restore" , exists(l:var4), 'false')
    let g:ulti_test_rethrow = l:var2
    let g:syntax_on = l:var3
    " }}}
    " Nested datastructures {{{
    let l:dict1_name = 'g:UltiTestForDictOnePleaseDontUseThisVariable'
    let l:dict2_name = 'g:UltiTestForDictTwoPleaseDontUseThisVariable'
    let l:dict3_name = 'g:UltiTestForDictThreePleaseDontUseThisVariable'
    execute "let " . l:dict1_name . " = {'test1': 'case1'}"
    execute "let " . l:dict2_name . " = {'test2': 'case2', 'dict1': " .
                \ "deepcopy(" . l:dict1_name . ")}"
    execute "call UltiAssertEquals('Dict1 and Dict2[Dict1] are equal'," .
                \ l:dict1_name . ", " . l:dict2_name . "['dict1'], 'true')"
    call UltiAssertTrue('Dict1 exists', exists(l:dict1_name), 'true')
    call UltiAssertTrue('Dict2 exists', exists(l:dict2_name), 'true')
    call UltiAssertTrue("Dict3 doesn't exist", exists(l:dict3_name), 'false')
    execute "let l:dict1 = deepcopy(" . l:dict1_name . ")"
    execute "let l:dict2 = deepcopy(" . l:dict2_name . ")"
    execute "call UltiAssertEquals('Dict1 saved', " . l:dict1_name .
                \ ", l:dict1, 'true')"
    execute "call UltiAssertEquals('Dict2 saved', " . l:dict2_name .
                \ ", l:dict2, 'true')"
    call UltiTestStore([l:dict1_name, l:dict2_name], l:dict3_name)
    execute "let " . l:dict1_name . "['new'] = 'item'"
    execute "call UltiAssertEquals('Dict1 changed', " . l:dict1_name .
                \ ", l:dict1, 'false')"
    execute "let " . l:dict2_name . "['dict1']['new2'] = 'item2'"
    execute "call UltiAssertEquals('Dict2 changed', " . l:dict2_name .
                \ ", l:dict2, 'false')"
    execute "call UltiAssertEquals('Dict1 and Dict2[Dict1] are not equal'," .
                \ l:dict1_name . ", " . l:dict2_name . "['dict1'], 'false')"
    execute "let " . l:dict3_name . " = {'test3': 'case3'}"
    call UltiAssertTrue("Dict3 now exists", exists(l:dict3_name), 'true')
    call UltiTestRestore()
    execute "call UltiAssertEquals('Dict1 back', " . l:dict1_name .
                \ ", l:dict1, 'true')"
    execute "call UltiAssertEquals('Dict2 back', " . l:dict2_name .
                \ ", l:dict2, 'true')"
    execute "call UltiAssertEquals('Dict1 and Dict2[Dict1] are equal again'," .
                \ l:dict1_name . ", " . l:dict2_name . "['dict1'], 'true')"
    call UltiAssertTrue("Dict3 doesn't exist, again", exists(l:dict3_name),
                \ 'false')
    " }}}
    " Exceptions {{{
    let restore = 'UltiTestRestore'
    let store = 'UltiTestStore'
    call UltiAssertException('Extraneous general call to Restore does not ' .
                \ ' throw', restore, [], '', 'false')
    call UltiAssertException('Extraneous specific call to Restore does throw'
                \ , restore, ['g:syntax_on'],
                \ 'Cannot restore unstored variable', 'true')
    call UltiAssertException('Store complains when no arguments given',
                \ store, [], "Not enough arguments", 'true')
    call UltiAssertException('Store complains about numbers', store, [1], 
                \ "Argument must be a variable name as a string, or a List " .
                \ "of Strings", 'true')
    call UltiAssertException('Store complains about dicts', store,
                \ [{'test': 'dict'}], 
                \ "Argument must be a variable name as a string, or a List " .
                \ "of Strings", 'true')
    call UltiAssertException('Restore complains about non-existent variable',
                \ restore, [l:dict3_name], "Variable in argument must exist",
                \ 'true')
    call UltiAssertException('Restore complains about numbers', restore,
                \ [2.34], 'Argument must be a String or a List of Strings',
                \ 'true')
    " }}}
    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Assert_In_String {{{
function! tests#test_the_tests#Test_Assert_In_String()
    call UltiTestStart("UltiAssertInString tests")

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
function! tests#test_the_tests#Test_Assert_In_Buffer()
    call UltiTestStart("UltiAssertInBuffer()")

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" Test_Assert_In_File {{{
function! tests#test_the_tests#Test_Assert_In_File()
    call UltiTestStart("UltiAssertInFile")

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

    let l:echobye = 'tests#test_the_tests#EchoBye'
    call UltiAssertInOutput("Doesn't output hello",
                \ l:echobye, [], 'Hello', 'false')
    call UltiAssertInOutput("Does output Bye",
                \ l:echobye, [], 'Bye', 'true')
    call UltiAssertInOutput("Does output 'stranger' if no arguments",
                \ l:echobye, [], 'stranger', 'true')
    call UltiAssertInOutput("Doesn't output 'stranger' if 1 argument",
                \ l:echobye, ['Kevin'], 'stranger', 'false')
    call UltiAssertInOutput("Does output 'Kevin' if 'Kevin' in arguments",
                \ l:echobye, ['Kevin'], 'Kevin', 'true')
    call UltiAssertInOutput("Echoes your favorite food without even asking",
                \ l:echobye, ['Kevin'],
                \ 'Bye Kevin, your favorite food is cereal', 'true', 'skip')

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
