Lisp In Small Pieces for Modern Schemes
=======================================

This repository contains source code from the book
[Lisp In Small Pieces][LiSP] by Christian Queinnec, updated to work
with modern versions of Bigloo, Gambit, Mit-scheme, and
Guile. Specifically, the following versions are known to pass the
included test suite, with one exception
[noted below][failing-grand.tests].

- [bigloo][] 4.1a
- [gambit][] 4.7.2
- [mit-scheme][] 9.2
- [guile][] 2.0.11

Running the code
----------------

1. Install one of the above mentioned schemes

2. Clone this repo.
    `git clone https://github.com/appleby/Lisp-In-Small-Pieces.git`

3. Edit the Makefile and set the `SCHEME` variable to the scheme
   interpreter you want. The supported values for `SCHEME` are

        o/${HOSTTYPE}/book.bigloo
        o/${HOSTTYPE}/book.gsi
        o/${HOSTTYPE}/book.mit
        o/${HOSTTYPE}/book.guile

   So, e.g., to build the Gambit interpreter, set `SCHEME =
   o/${HOSTTYPE}/book.gsi`.

4. Run `make` to build the interpreter. If everything goes well, you
   should have an executable in `o/${HOSTTYPE}/book.<whatever>`. Note
   that most of these are just shell scripts that must be run from the
   toplevel directory.

5. Run `make grand.test` to run the test suite. This will take several minutes,
   but at the end you should see a message that says "All tests passed."

Failing grand.tests
-------------------

The `grand.test` Make target is a wrapper that runs the tests for all
the code that actually appears in the book. There are 54 total
sub-targets included in the `grand.test` target, of which one target
is failing, namely `test.reflisp`.

The `test.reflisp` target is a test of the reflective interpreter from
chapter 8 of the book, and comes with the following disclaimer/warning
at the top of src/chap8k.scm:

    ;;; Adaptation of the reflective interpreter to Scheme->C, Bigloo or
    ;;; SCM.  This is very messy, very hacky and poses a lot of problems
    ;;; with hygienic macros so expansion is done by hand.

Most of the hacks are related to the fact that the reflective
interpreter redefines (and allows modification of) special forms like
`quote`, `if`, `set!`, and `lambda`.

I'm not planning to fix the `test.reflisp` target since:

1. While it is an interesting oddity, I suspect it'll take more time
   than I want to spend to figure out the correct hoops to jump
   through to get it working (and it may not even be possible for all
   Schemes).
2. There is already a working test of the reflective interpreter in
   `test.chap8j`. That target runs exactly the same reflisp code, but
   runs it in the byte-code interpreter of chapter 7 rather than on
   the native scheme.

Other Known Failing Tests
-------------------------

The Makefile also includes a few tests which aren't run by the
`grand.test` target. Mostly these are tests for code variants that
were not included in the book. Here are some that I know are failing;
there may be others:

- `test.chap10i`
- `test.chap10e.c`

Note that for `test.chap10i`, a comment in the Makefile warns that
it's an untested variant. Not sure if it's worth trying to get it
working...

    # chap10i.scm : *Untested* variants for function invokation since
    # it requires a change in SCM_invoke (in scheme.c).

Unknown Failing Tests?
----------------------

![Works On My Machine](http://blog.codinghorror.com/content/images/uploads/2007/03/6a0120a85dcdae970b0128776ff992970c-pi.png)

I've only tested the changes in this repo on my personal laptop
(Archlinux / x86_64), and only with the scheme versions mentioned in
the first section of this README. If you're using a recent-ish version
of any of any of those schemes and you notice failures not mentioned
above, please open a GitHub issue, or (even better) send a pull
request.

I'd also happily accept pull requests adding support for other schemes.

Other Schemes
-------------

In addition to [bigloo][], [gambit][], and [mit-scheme][] the [original
sources][LiSP-2ndEdition] also supported [elk][], [scheme2c][], and [scm][].
I'm not planning to get those working myself, but pull requests are welcome.

[Guile][guile] was not supported in the original sources.

More Info
---------

For more info, see the [original README][README] file.

TODO
----

* ~~Maybe: Remove unused code, like the included syntax-case files.~~
* ~~Maybe: Move common code out of `<interpreter>/book.scm`.~~
* ~~Maybe: Clean up formatting of the Makefile~~
* Maybe: Remove unused/unsupported/deprecated targets from the Makefile.
* Maybe: Get C files to compile without warnings


[README]: https://raw.githubusercontent.com/appleby/Lisp-In-Small-Pieces/master/README.orig
[failing-grandtests]: https://github.com/appleby/Lisp-In-Small-Pieces#failing-grand.tests

[LiSP]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/WWW/LiSP.html
[LiSP-2ndEdition]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/Books/LiSP-2ndEdition-2006Dec11.tgz

[bigloo]: http://www-sop.inria.fr/indes/fp/Bigloo
[elk]: http://sam.zoy.org/elk/
[gambit]: http://dynamo.iro.umontreal.ca/wiki/index.php/Main_Page
[mit-scheme]: http://www.gnu.org/software/mit-scheme/
[scheme2c]: https://github.com/barak/scheme2c
[scm]: http://people.csail.mit.edu/jaffer/SCM
[guile]: http://www.gnu.org/software/guile/
