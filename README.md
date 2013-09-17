Vim Ultimate Test Utility
=========================

Introduction                      
------------

Ultimate-Test-Utility is the only tool you'll need for creating and running
unit tests in Vim. Unit testing has been notoriously hard for Vim-script and
the plugins that do exist often require languages, are difficult to
setup/configure/use, have bugs, or have incomplete documentation.

Ultimate-Test-Utility is maintained solely by Kevin Biskar and is constantly
expanding it's features. If you have any concerns, feature requests, or have
found any undocumented bugs, please notify him (me).


Features and Requirements          
-------------------------

- Ultimate-Test-Utility is written solely in vimscript so compilation
  requirements are minimal.

    - However, Ultimate-Test-Utility must be run in a Vim 7.0 or higher and
      some functions may require read/write access to files you may be using.
      Of course, use those functions with care, though the instances in which
      these precautions are necessary should be obvious; Ultimate-Test-Utility 
      does NOT want to harm your work, it's here to help.

    - Also, Ultimate-Test-Utility has included some example functions that
      may not work correctly on your OS. This should not be an issue when
      using this plugin to write your own vimscript code, only when trying the
      demos. In the future, these examples may be updated to be compatible with
      as many OSes and setups as possible.

- Ultimate-Test-Utility provides several levels of reporting so your reports
  are as detailed or minimal as you'd like.

- Ultimate-Test-Utility allows for easy installation through Pathogen, Vundle,
  or other compatible plugin managers. If you're reading this, it's likely
  installed correctly already, but if not consult the README.md file.

- Ultimate-Test-Utility is, like most vim plugins, open-source! Please feel
  free to distribute, contribute, modify or spread the word.


Installation
------------
Installation is quite simple does not require any other plugins or languages
to be installed.

### Pathogen

```bash
cd ~/.vim/bundle
git clone https://github.com/biskark/vim-ultimate-colorscheme-utility.git
git checkout menu_integration
```

### From archive
1. download archive
2. unzip archive into .vim


Usage                              
-----

Ultimate-Test-Utility has a straightforward API, and is not unlike the Perl
testing suite. However, Vim's lack of out-of-box OOP and our decision to
maximize compatibility (we don't use other languages or CLI testing
software) means that Ultimate-Test-Utility does have a mild
learning-curve, but should be easy to pick for both testing veterans and
first-timers alike.

- The first section, Ultimate-Test-Utility-Quick-Start, provides a quick
overview of how to use this plugin.

- The second section, Ultimate-Test-Utility-Basic-Examples, shows the most
common usage and should be enough to get you started on working on your own
projects.

- The third section, Ultimate-Test-Utility-Basic-Examples, explores more
complex usage cases and explains the interface to some of the less intuitive
functions.

The more complex examples are available in examples.vim.


Quick Start Guide                 
-----------------

Ultimate-Test-Utility breaks down tests into two categories. Individual
Assertion tests (referred to as sub-tests) which check for one specific thing,
and groupings of related sub-tests (collectively referred to as a test).
It's often natural to have sub-tests in a full test address different aspects
and edge cases of a particular function or key mapping. Thus a plugin with 4
functions and 1 keymapping may have 5 total "tests", with each "test"
consisting of up to dozens of "sub-tests."

The basic workflow is simple.

1. You MUST call UltiTestStart to tell vim that you are going into
   "test-mode".

2. You then call as many UltiAssert... sub-tests as you need.

3. You then call UltiTestStop to tell vim that a particular test is over.

4. You may then call UltiTestReport which will give a report of varying
   detail about the success and failure of your sub-tests. Additionally, this
   will report the overall success of the entire test. The degree of detail
   reported is dependent on the value of g:ulti\_test\_verbose. See
   Ultimate-Test-Utility-Config for more details.

5. If you wish to execute more tests (ie. more groupds of sub-tests), you
   should call UltiTestReset.

6. Repeat steps 1-6 as needed.

7. You may then call UltiTestFinalSummary to give a simple summary of all
   the "tests" you have run (since you either loaded the plugin or called
   UltiTestResetAll, see next step for details).

8. If you wish to run another suite of "tests", say for a different plugin or
   file, call UltiTestResetAll.

9. Repeat steps 1-8 as needed.

The next section shows how to setup and run one full "test" on an example
function.

Basic Examples                    
--------------

Special Note: It's good practice to write your tests before you write the code
you're testing, but for the purpose of this tutorial, we'll ignore that.

Example Multiply function, takes two arguments and returns the quotient.

```vim
function! Multiply(numerator, denominator)
    return a:numerator * a:denominator
endfunction
```

Example test function that examines some basic-use cases and possible edge
cases. Comments have been sprinkled in to explain a little of the API.
    
```vim
function! MultiplyTestOne()
    call UltiTestStart()

    call UltiAssertTrue('', Multiply(2, 2) == 4, 'true')

    call UltiAssertTrue("Testing 1 times 1 isn't 6",
                \ Multiply(1, 1) == 6,
                \ 'false')

    " We're deliberately making an incorrect test here to see what happens
    call UltiAssertTrue("Testing 5 times -2 isn't -10",
                \ Multiply(5, -2) == -10,
                \ 'false')

    call UltiAssertEquals('Testing Multiply(2.0, 3) == Multiply(3.0, 2)',
                \ Multiply(2.0, 3),
                \ Multiply(3.0, 2),
                \ 'true')

    call UltiTestStop()
    call UltiTestReport()
endfunction

" Now to run the test
call MultiplyTestOne()
```

This should give something like the following as output:

```vim
    Sub-test 3: Failed, Testing 5 times -2 isn't -10
    Test 1 Results:
        Expected: Not specified, Passed: 3, Failed: 1, Skipped: 0
```

Yay, it works, let's review what we did.

The calls to UltiTestStart, UltiTestStop, and UltiTestReport were covered in
the previous section and are straightforward. However, we then called the
actual sub-tests themselves.

Each sub-test available starts with 'UltiAssert'.
Each UltiAssert function has a slightly different argument signature but there
are some similarities in usage.

1. The first argument is a string describing the purpose of the test. Notice
   this message was displayed when sub-test 3 failed. Descriptive messages
   make pin-pointing problems quick, but you may provide an empty string like
   we did for the first sub-test.

2. Next are the arguments unique to the assertion test being run.

3. The last argument is optional, and can only be the string 'skip' to
   indicate that you don't want to run the test at this time. Notice that we
   did not use this feature in any of the tests we just ran.

4. The argument before 'skip' (aka the last argument if you don't
   provide 'skip'), must be either 'true' or 'false', indicating if
   the Assertion is expected to be true or false.

Essentially, each simple UltiAssert... looks like this...

```vim
    call UltiAssertSimple(description, ..., expected_outcome)  " or
    call UltiAssertSimple(description, ..., expected_outcome, 'skip')
```

where the '...' is unique to whatever test you're using.

Note: there is no test called UltiAssertSimple or UltiAssert.... These are
place holder names.

Notice that in MultiplyTestOne we used UltiAssertTrue, which took one unique
argument (the result of the Multiply function call) and UltiAssertEquals which
took two unique arguments (the results of two Multiply function calls). As you
may have guessed, UltiAssertTrue simply evaluates the truthiness of its one
unique argument, and UltiAssertEquals compares its two unique arguments to
eachother.  Most sub-tests can be written with either one of these. The
presence of both of them, and the more specific assertions explained in the
next section, is merely a convenience. You should use whichever sub-tests feel
the most natural.

Next Steps:
Yay, it works ... but it could be better. Ignoring that our function is
trivial, we deliberately made a mistake, and the usefulness of these tests is
questionable, we can still improve our test function.

1. If we run our test again, it now says we're on Test 2 even though this
   is the same test we just ran.

2. 'Test 1' isn't a horribly informative name in the first place.

3. Though moot in this case, how do we know we tested everything we
   intended? Though careful coding can eliminate this problem, in tests with
   many sub-tests, especially in more complicated plugins, we may want an
   extra level of confidence.

It turns out we can fix all of these problems with minimal effort.

```vim
function! MultiplyTestTwo()
    call UltiTestReset()
    call UltiTestStart('Testing the Multiply Function', 4)

    call UltiAssertTrue('', Multiply(2, 2) == 4, 'true')

    call UltiAssertTrue("Testing 1 times 1 isn't 6",
                \ Multiply(1, 1) == 6,
                \ 'false')

    " We're deliberately making an incorrect test here to see what happens
    call UltiAssertTrue("Testing 5 times -2 isn't -10",
                \ Multiply(5, -2) == -10,
                \ 'false')

    call UltiAssertEquals('Testing Multiply(2.0, 3) == Multiply(3.0, 2)',
                \ Multiply(2.0, 3),
                \ Multiply(3.0, 2),
                \ 'true',
                \ 'skip')

    call UltiTestStop()
    call UltiTestReport()
endfunction

" Now to run the test
call MultiplyTestOne()
```

This should give something like the following as output:

```vim
Sub-test 3: Failed, Testing 5 times -2 isn't -10
Test 1 'Testing the Multiply Function' Results:
    Expected: 4, Passed: 2, Failed: 1, Skipped: 1
```

Two quick points, and we can move on to more advanced usage.

1. The call to UltiTestReset tells vim to reset our sub-test counters so
   that we could have been placed at the end of the function instead of the
   beginning. However, as we'll see, this call should usually be made outside
   of any one test, and rather after or before running a suite of tests.

2. The call to UltiTestStart can take two optional arguments in any order.
   It can take a string that should describe how the sub-tests are related,
   and an integer that tells the test how many sub-tests to expect.

3. The last sub-test has the 'skip' argument added, just to show how to use
   it. Note that adding 'skip' only prevents the result from being factored in
   the testing facility, it won't prevent any errors in the other arguments
   from causing problems.


Extended Examples                
-----------------

Let's broaden our look at this plugin be testing some more complicated
plugins/functions and integrating several tests into one suite. Assume all
references to MultiplyTest() refer to the MultiplyTestTwo() function from the
previous section.

Special Note: It's good practice to write your tests before you write the code
you're testing, but for the purpose of this tutorial, we'll ignore that.

First let's write two more functions and add a keymapping for one of them.

The first is a slightly trickier function that echos the quotient of two
numbers rather than merely returns them. Also, divide by zero exceptions may
be thrown and we'll show how to deal with that.

```vim
function! Divide(numerator, denominator)
    if a:denominator == 0
        throw "Divide by zero"
    endif
    echo (a:numerator / a:denominator)
endfunction
```

The next is a vim function that inserts the word "Hello" into the current
buffer. For convenience, we'll also add a helper function that adds a
keymapping for this function.

```vim
function! InsertHello()
    execute 'normal! iHello'
endfunction

function! NewMapping()
    nnoremap <silent> <leader>S :call InsertHello()<cr>
endfunction
```


Ok, now let's write those tests.

```vim
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
```

Notes:
UltiAssertInOuput and UltiAssertException both have more complicated
interfaces but share similarities with the previous UltiAssert functions
and with each other.

1. Like the others, the first argument is a descriptive name, and the last
   two arguments are the expection (either "true" or "false") and an
   optional "skip" string to indicate the test is skipped.
2. The second argument is a variable or raw string with the name of the
   function to be tested. The name should NOT have parentheses or any
   arguments.
3. The third argument is a List of all arguments you would like to be
   passed to the function you're testing. If no arguments are to be passed,
   you must provide an empty list '[]'.
4. The fourth argument is a string or regex specific to the UltiAssert test
   you're using. For UltiAsserException, it should be the exception you
   expect to be thrown. For UltiAssertInOutput it should be the string
   you expect to be in the output.

In summary, each simple UltiAssert... looks like this...

```vim
call UltiAssertSimple(desc, ..., expected_outcome)  " or
call UltiAssertSimple(desc, ..., expected_outcome, 'skip')
```
where the '...' is unique to whatever test you're using.

Each complex UltiAssert... looks like this.

```vim
call UltiAssertComplex(desc, fx, arguments, string, expected_outcome)  " or
call UltiAssertComplex(desc, fx, arguments, string, expected_outcome, 'skip')
```

Note: there is no test called UltiAssertSimple or UltiAssert... or
UltiAssertComplex. These are place holder names only.


This next test is a bit of a cheat in that it tests the InsertHello() function
via the keymapping where these tests should probably be separate. Also, the
use of the mapleader variable can be troublesome because the mapping is always
whatever the value of the leader key at the time it was set. If this doesn't
make sense to you, just know to be careful if you use it.

```vim
function! TestInsertHello()
    call UltiTestStart('Testing Command Mapping and Text Insertion', 3)

    if exists('mapleader')
        let leader = mapleader
    else
        let leader = '\'
    endif

    " Make the new mapping
    call NewMapping()

    let l:fx = 'Hello'
    call UltiAssertInBuffer('Testing for "Hello" absence before execute',
                \ 'Hello', 'false')

    execute 'normal! ' . leader . 'S'
    call UltiAssertInBuffer('Testing for "Hello" absence after normal!',
                \ 'Hello', 'false')

    execute 'normal ' . leader . 'S'
    call UltiAssertInBuffer('Testing for "Hello World" presence after normal',
                \ 'Hello', 'true')
    
    " Clean up the text that was just inserted. Not necessary for the
    " test though.
    execute "s/Hello//"

    call UltiTestStop()
    call UltiTestReport()
endfunction
```

Notes
1. We specified there should be 3 sub-tests run and given the test a
   description.

2. We have not called UltiTestReset yet.

3. Now that we're executing more complicated functions, we need
   to be careful that we're not polluting the current buffer with side-effects
   from our testing. In particular beware of testing UltiAssertInBuffer
   sub-tests in the buffer where you wrote the test. See if you can figure out
   why.

4. UltiAssertInBuffer has an almost identical interface to UltiAssertTrue.


Finally, let's organize these two tests into a full suite with the
MultiplyTest from before. Take out the call to UltiTestReset in the
MultiplyTest.

```vim
function! AllTests()
    call UltiTestReset()         " Clears residual junk

    call MultiplyTest()
    call TestDivide()
    call TestInsertHello()

    call UltiTestFinalSummary()  " Brief summary of all three tests
    call UltiTestResetAll()      " Clears everything
endfunction
```

Now to call the whole thing...

```vim
call AllTests()
```

Remember that because our TestInsertHello() tests for the presence and absence
of the string 'Hello' in the buffer it's executed in, it's best to run these
tests in an empty buffer. So it's probably best to source these functions,
switch to a new buffer, and then call AllTests().

You can change the output by setting one of these three values before you call
the function.

```vim
let g:ulti_test_verbose = 0    " or
let g:ulti_test_verbose = 1    " or
let g:ulti_test_verbose = 2
```

Assuming you left it at 1, you should get ...

```vim
Sub-test 3: Failed, Testing 5 times -2 isn't -10
Test 1 Results:
    Expected: 4, Passed: 3, Failed: 1, Skipped: 0

Test 2 'Divide Test' Results
    Expected: 5, Passed: 5, Failed: 0, Skipped: 0

Test 3 'Testing Command Mapping and Text Insertion' Results
    Expected: 3, Passed: 3, Failed: 0, Skipped: 0

1 test(s) failed.
```
