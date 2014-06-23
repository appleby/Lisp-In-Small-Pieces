Programs of Lisp In Small Pieces
================================

This repository contains source code from the book [Lisp In Small Pieces][LiSP]
by Christian Queinnec, updated to work with modern versions of Bigloo, Gambit,
and Mit-scheme. Specifically, the following versions are known to mostly work,
with a few exceptions noted below.

- [bigloo][bigloo] 4.1a
- [gambit][gambit] 4.7.2
- [mit-scheme][mitscheme] 9.2

Running the code
----------------

1. Install one of the above mentioned schemes

2. Clone this repo.
    `git clone https://github.com/appleby/LiSP-2ndEdition.git`

3. Build the interpreter for the book. Edit the Makefile and set the `SCHEME`
   variable to the version of scheme you want. The supported values for
   `SCHEME` are `o/${HOSTTYPE}/book.{bigloo,gsi,mit}`. So, e.g., to build the
   Gambit interpreter, set `SCHEME = o/${HOSTTYPE}/book.gsi`. Then run `make` to
   build the interpreter. If everything goes well, should have an executable in
   `o/${HOSTTYPE}/book.gsi`.

4. Run `make grand.test` to run the test suite. This will take several minutes,
   but at the end you should see message that says "All tests passed."

In addition to [bigloo][bigloo], [gambit][gambit], and [mitscheme][mitscheme]
the [original sources][LiSP-2ndEdition] also supported [elk][elk],
[scheme2c][scheme2c], and [scm][scm]. I'm not planning to 


[LiSP]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/WWW/LiSP.html
[LiSP-2ndEdition]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/Books/LiSP-2ndEdition-2006Dec11.tgz

[bigloo]: http://www-sop.inria.fr/indes/fp/Bigloo
[elk]: http://sam.zoy.org/elk/
[gambit]: http://dynamo.iro.umontreal.ca/wiki/index.php/Main_Page
[mitscheme]: http://www.gnu.org/software/mit-scheme/
[scheme2c]: https://github.com/barak/scheme2c
[scm]: http://people.csail.mit.edu/jaffer/SCM
