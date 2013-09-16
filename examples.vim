" Functions {{{
function! Multiply(numerator, denominator)
    return a:numerator * a:denominator
endfunction

function! Divide(numerator, denominator)
    if a:denominator == 0
        throw "Divide by zero"
    endif
    echo (a:numerator / a:denominator)
endfunction

function! InsertHello()
    execute 'normal! iHello'
endfunction

function! NewMapping()
    nnoremap <silent> <leader>S :call InsertHello()<cr>
endfunction
" }}}

" Tests {{{
function! MultiplyTest()
    call UltiTestStart('Testing the Multiply Function', 4)

    call UltiAssertTrue('', Multiply(2, 2) == 4, 'true')
    call UltiAssertTrue("Testing 1 times 1 isn't 6",
                \ Multiply(1, 1) == 6,
                \ 'false')
    call UltiAssertTrue("Testing 5 times -2 isn't -10",
                \ Multiply(5, -2) == -10,
                \ 'false')
    call UltiAssertEquals('Testing Multiply(2.0, 3) == Multiply(3.0, 2)',
                \ Multiply(2.0, 3),
                \ Multiply(3.0, 2),
                \ 'true',
                \ 'skip')

    call UltiTestStop()             " Mandatory
    call UltiTestReport()           " Optional, but useful
endfunction

function! TestDivide()
    call UltiTestStart("Divide Tests", 5)
    
    " Output tests
    call UltiAssertInOutput('6 / 2 == 3', 'Divide', [6, 2], '3', 'true')
    call UltiAssertInOutput("1 / 3 == 0 ('Testing Int Division')",
                \ 'Divide', [1, 3], '6', 'false')

    " Exception tests
    call UltiAssertException("Throws divide by zero error",
                \ 'Divide by zero', 'Divide', [4, 0], 'true')
    call UltiAssertException("Doesn't throw divide by zero error",
                \ 'Divide by zero', 'Divide', [4, 2], 'false')
    " For variety, use a variable for the function name
    let l:fx = 'Divide'
    call UltiAssertException("Complains about arguments",
                \ 'Not enough arguments', l:fx, [], 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction

function! TestInsertHello()
    call UltiTestStart('Testing Command Mapping and Text Insertion', 3)

    if exists('mapleader')
        let leader = mapleader
    else
        let leader = '\'
    endif

    " Make the new mapping
    call NewMapping()

    call UltiAssertInBuffer('Testing for "Hello" absence before execute',
                \ 'Hello', 'false')

    execute 'normal! ' . leader . 'S'
    call UltiAssertInBuffer('Testing for "Hello" absence after normal!',
                \ 'Hello', 'false')

    execute 'normal ' . leader . 'S'
    call UltiAssertInBuffer('Testing for "Hello" presence after normal',
                \ 'Hello', 'true')
    
    " Clean up the text that was just inserted. Not necessary for the
    " test though.
    execute "s/Hello//"

    call UltiTestStop()
    call UltiTestReport()
endfunction

function! AllTests()
    call UltiTestReset()         " Clears residual junk

    call MultiplyTest()
    call TestDivide()
    call TestInsertHello()

    call UltiTestFinalSummary()  " Brief summary of all three tests
    call UltiTestResetAll()      " Clears everything
endfunction
" }}}
