Lisp In Small Pieces for Modern Schemes
=======================================

This repository contains source code from the book
[Lisp In Small Pieces][LiSP] by Christian Queinnec, updated to work
with modern versions of Bigloo, Gambit, Mit-scheme, and
Guile. Specifically, the following versions are known to pass the
included test suite, with one exception
[noted below][failing-test.reflisp].

- [bigloo][] 4.2c
- [gambit][] 4.8.2
- [mit-scheme][] 9.2
- [guile][] 2.0.11

Running the code
----------------

1. Install one of the above mentioned schemes

2. Clone this repo.
    `git clone http://github.com/appleby/Lisp-In-Small-Pieces.git`

3. Edit the Makefile and set the `SCHEME` variable to the scheme
   interpreter you want. The supported values for `SCHEME` are

        o/${HOSTTYPE}/book.bigloo
        o/${HOSTTYPE}/book.gsi
        o/${HOSTTYPE}/book.mit
        o/${HOSTTYPE}/book.guile

   So, e.g., to build the Gambit interpreter, set `SCHEME =
   o/${HOSTTYPE}/book.gsi`.

4. Run `make grand.test` to run the test suite. Running the tests will
   take a while, but at the end you should see a message that says
   "All tests passed."

Failing test.reflisp
--------------------

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

1. I suspect it'll take more time than I want to spend to get it
   working (and it may not even be possible for all Schemes).
2. There is already a working test of the reflective interpreter in
   `test.chap8j`. The `test.chap8j` target runs exactly the same
   reflisp code, but runs it in the byte-code interpreter of chapter 7
   rather than on the native scheme.

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

In addition to bigloo, gambit, and mit-scheme the
[original sources][LiSP-2ndEdition] also supported elk, scheme2c, and
scm.  I'm not planning to get those working myself, but pull requests
are welcome.

Guile was not supported in the original sources.

More Info
---------

For (a lot) more info, see the [original README][README] file.

[README]: https://raw.githubusercontent.com/appleby/Lisp-In-Small-Pieces/master/README.orig
[failing-test.reflisp]: https://github.com/appleby/Lisp-In-Small-Pieces#failing-testreflisp

[LiSP]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/WWW/LiSP.html
[LiSP-2ndEdition]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/Books/LiSP-2ndEdition-2006Dec11.tgz

[bigloo]: http://www-sop.inria.fr/indes/fp/Bigloo
[gambit]: http://dynamo.iro.umontreal.ca/wiki/index.php/Main_Page
[mit-scheme]: http://www.gnu.org/software/mit-scheme/
[guile]: http://www.gnu.org/software/guile/
