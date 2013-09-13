" Testing functions that test this plugin.
" Some circular logic is needed as this plugin is used to test itself.  

" Unit Tests {{{
" Test_Is_True {{{
function! tests#test_the_tests#Test_Is_True()
    call UltiTestStart("Is True", 7)

    call UltiAssertEquals(ulti_test_utility#Is_True(1), 1, 'true')
    call UltiAssertEquals(ulti_test_utility#Is_True(0), 0, 'true')
    call UltiAssertEquals(ulti_test_utility#Is_True(2.0), -1, 'true')
    call UltiAssertEquals(ulti_test_utility#Is_True('string'), 0, 'true')
    call UltiAssertEquals(ulti_test_utility#Is_True([]), -1, 'true')
    call UltiAssertEquals(ulti_test_utility#Is_True([1]), -1, 'true')
    call UltiAssertEquals(ulti_test_utility#Is_True({}), -1, 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}

" Test_Is_Empty {{{
function! tests#test_the_tests#Test_Is_Empty()
    call UltiTestStart("Is Empty", 7)

    " Strings call UltiAssertTrue(ulti_test_utility#Is_Empty(""), 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Empty("T"), 'false')
    call UltiAssertTrue(ulti_test_utility#Is_Empty("Test"), 'false')
    " Lists
    call UltiAssertTrue(ulti_test_utility#Is_Empty([]), 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Empty(['Test']), 'false')
    " Dictionaries
    call UltiAssertTrue(ulti_test_utility#Is_Empty({}), 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Empty({'Test': 'Case'}), 'false')
    " Other
    call UltiAssertTrue(ulti_test_utility#Is_Empty(0) == -1, 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}

" Test_Is_Equals {{{
function! tests#test_the_tests#Test_Is_Equals()
    call UltiTestStart("Is Equals", 16)

    " Strings
    call UltiAssertTrue(ulti_test_utility#Is_Equals("string", "string"),
                \ 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Equals("String", "string"),
                \ 'false')
    call UltiAssertTrue(ulti_test_utility#Is_Equals("", ""),
                \ 'true')
    " Numbers
    call UltiAssertTrue(ulti_test_utility#Is_Equals(1, 1),
                \ 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Equals(0, 0),
                \ 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Equals(0, 1),
                \ 'false')
    call UltiAssertTrue(ulti_test_utility#Is_Equals(1.0, 1),
                \ 'true')
    " Lists
    call UltiAssertTrue(ulti_test_utility#Is_Equals([], []),
                \ 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Equals([""], []),
                \ 'false')
    call UltiAssertTrue(ulti_test_utility#Is_Equals(['Test'], ['Test']),
                \ 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Equals(['test'], ['Test']),
                \ 'false')
    call UltiAssertTrue(ulti_test_utility#Is_Equals(['Test', 'case'],
                \ ['Test', 'case']), 'true')
    " Dictionaries
    call UltiAssertTrue(ulti_test_utility#Is_Equals({}, {}),
                \ 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Equals({'Test': 'Case'},
                \ {'Test': 'Case'}), 'true')
    call UltiAssertTrue(ulti_test_utility#Is_Equals({'Test': 'Case'},
                \ {'Test': 'case'}), 'false')
    call UltiAssertTrue(ulti_test_utility#Is_Equals({'Test': 'Case'},
                \ {'test': 'Case'}), 'false')
    

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}

" Test_In_List {{{
function! tests#test_the_tests#Test_In_List()
    call UltiTestStart("In List")

    " Simple
    call UltiAssertTrue(ulti_test_utility#In_List('string', ['string']), 'true')
    call UltiAssertTrue(ulti_test_utility#In_List('', ['string']), 'false')
    call UltiAssertTrue(ulti_test_utility#In_List('string', []), 'false')
    call UltiAssertTrue(ulti_test_utility#In_List('string', ['']), 'false')
    call UltiAssertTrue(ulti_test_utility#In_List(1, ['1']), 'false')
    call UltiAssertTrue(ulti_test_utility#In_List(1, [1, 2, 3]), 'true')
    call UltiAssertTrue(ulti_test_utility#In_List(1.1, [1.1, 2, 3]), 'true')

    " List in Lists
    call UltiAssertTrue(ulti_test_utility#In_List(['string', 'test'],
                \ [['string', 'test'], 'string']), 'true')
    call UltiAssertTrue(ulti_test_utility#In_List('test',
                \ [['string', 'test'], 'string']), 'false')

    " Dict in Lists
    call UltiAssertTrue(ulti_test_utility#In_List({'test': 'case'},
                \ [{'test': 'case'}, 'string']), 'true')
    call UltiAssertTrue(ulti_test_utility#In_List({'test': 'no'},
                \ [{'test': 'case'}, 'string']), 'false')

    " Exceptions
    call UltiAssertException("ulti_test_utility#In_List", [1, [1]],
                \ 'false')
    call UltiAssertException("ulti_test_utility#In_List", [1, 1],
                \ 'true')
    call UltiAssertException("ulti_test_utility#In_List", [1],
                \ 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}

" Test_Key_In_Dict {{{
function! tests#test_the_tests#Test_Key_In_Dict()
    call UltiTestStart("Key In Dict", 5)

    call UltiAssertTrue(ulti_test_utility#Key_In_Dict('string',
                \ {'string': 'test'}), 'true')
    call UltiAssertTrue(ulti_test_utility#Key_In_Dict('string',
                \ {'test': 'string'}), 'false')
    call UltiAssertTrue(ulti_test_utility#Key_In_Dict(1,
                \ {1: ''}), 'false')
    call UltiAssertTrue(ulti_test_utility#Key_In_Dict('1',
                \ {1: ''}), 'true')
    call UltiAssertException('ulti_test_utility#Key_In_Dict', [[1,2], [2]],
                \ 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}

" Test_Value_In_Dict {{{
function! tests#test_the_tests#Test_Value_In_Dict()
    call UltiTestStart('Value In Dict', 7)

    call UltiAssertTrue(ulti_test_utility#Value_In_Dict('string',
                \ {'string': 'test'}), 'false')
    call UltiAssertTrue(ulti_test_utility#Value_In_Dict('string',
                \ {'test': 'string'}), 'true')
    call UltiAssertTrue(ulti_test_utility#Value_In_Dict(1,
                \ {1: ''}), 'false')
    call UltiAssertTrue(ulti_test_utility#Value_In_Dict(1,
                \ {'key': 1}), 'true')
    call UltiAssertTrue(ulti_test_utility#Value_In_Dict(1,
                \ {'key': '1'}), 'false')
    call UltiAssertTrue(ulti_test_utility#Value_In_Dict('1',
                \ {'key': 1}), 'false')
    call UltiAssertException('ulti_test_utility#Value_In_Dict', [[1,2], [2]],
                \ 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction
" }}}
" }}}
