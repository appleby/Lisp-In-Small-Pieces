Lisp In Small Pieces for Modern Schemes
=======================================

This repository contains source code from the book
[Lisp In Small Pieces][LiSP] by Christian Queinnec, updated to work
with modern versions of [Bigloo][bigloo], [Gambit][gambit],
[MIT Scheme][mit-scheme], and [Guile][guile].


Setting up an environment
-------------------------

If you want to run the code in this repo, you have the following
options:

1. [Use Virtualbox with Vagrant](#using-virtualbox-with-vagrant)
2. [Use Virtualbox without Vagrant](#using-virtualbox-without-vagrant)
3. [Use Docker](#using-docker)
4. [Install dependencies yourself without using the provided virtual
   machines](#installing-dependencies-yourself)

If you have a reasonable internet connection and don't mind
downloading ~500MB of virtual machine / docker images, then options
1-3 are the easiest, and provide the only tested and known-working
environments. The virtual machines are Arch Linux x86_64 systems with
all required dependencies pre-installed.


### Using Virtualbox with Vagrant

Using [Vagrant][vagrant] is an easy way to get up and running with an
environment suitable for running the code in this repo. Assuming you
already have vagrant and virtualbox installed, just do the following:

``` shell
mkdir lisp-in-small-pieces
cd lisp-in-small-pieces
vagrant init appleby/lisp-in-small-pieces-vm
vagrant up # Wait for vagrant to download the box and run it.
vagrant ssh
```

You should be logged in to the virtual machine as the `vagrant` user.

You can now skip to the section [Running the Code](#running-the-code).


### Using Virtualbox without Vagrant

If you want to use a known-working Virtualbox VM but don't want to
install Vagrant, you can download a tarball that contains an ovf and
the associated virtual disk [here][latest-release].

Download the virtualbox tarball, extract it, and import the resulting
ovf into Virtualbox. You can login to the VM either via the console or
ssh with user `vagrant` and password `vagrant`.

You can now skip to the section [Running the Code](#running-the-code).


### Using Docker

``` shell
docker pull appleby/lisp-in-small-pieces
docker run -it --rm appleby/lisp-in-small-pieces
```

Docker should start the container and drop you into a bash shell.

You can now skip to the section [Running the Code](#running-the-code).

### Installing Dependencies Yourself

This method is not recommended, but is provided for curmudgeons like
myself who resent being told to download a 500MB virtual machine just
to run some scheme code. Of course if you go this route, figuring out
why everything is broken and fixing it will likely take 10x as long as
downloading the virtual machine image in the first place, but at least
you'll sleep secure knowing you didn't take the easy way out.

Here are the dependencies required to run the `grand.test` target,
including the version numbers that are installed in the above
mentioned virtual machines. The exact version numbers are not a hard
requirement, nor a guarantee of a working build. They are included
only for reference.

- GCC 8.2.1
- GNU Make 4.2.1
- GNU Binutils 2.31.1 (ar, ranlib, size, ...)
- GNU coreutils 8.30 (uname, time, chmod, tee, nice, ...)
- GNU bash 4.4.23 (invoked as `sh`, so any Bourne shell likely OK)
- GNU grep 3.1
- Perl 5.28.0
- One or more of the following schemes
  - bigloo 4.3a
  - gambit 4.9.0
  - guile 2.2.4
  - mit-scheme 9.2

In addition to the above required dependencies, the following optional
dependencies are needed by certain tests which are not included in the
`grand.test` target, but which may be run individually.

- GNU indent 2.2.12
- Caml Light 0.82

Once you have the dependencies installed, you can keep your fingers
crossed and skip to [Running the Code](#running-the-code).


Running the Code
----------------

1. Clone this repo.
    `git clone https://github.com/appleby/lisp-in-small-pieces.git && cd lisp-in-small-pieces`

2. Edit the `Makefile` and set the `MYSCHEME` variable to the scheme
   interpreter you want. The supported values for `MYSCHEME` are:
   `bigloo`, `gsi`, `guile`, and `mit`.

3. Run `make grand.test` or `make grand.test.quietly` to run the test
   suite. Running the tests will take a while, but at the end you
   should see a message that says "All tests passed."

If you want to temporarily try running the tests with a different
scheme interpreter, you can set the `MYSCHEME` variable when invoking
make, like so: `make MYSCHEME=guile grand.test.quietly`.  Of course,
you can replace `guile` in the previous examples with any valid value
for `MYSCHEME`.

If you don't want to run the full test suite, but only the tests for a
particular chapter of the book, you can specify the targets you want
individually. For example, `make test.chap5f`. See the Makefile for a
list of available targets.

If you want to run all tests for all schemes, run `make all.test`. You
probably don't want to run this target though, as it takes quite a
while to complete. The `all.test` target is mostly useful for testing
changes to this repo.

What happened to the VMware images?
-----------------------------------

The VMware images were produced by a HashiCorp Atlas build. Atlas is
no longer free, so I don't produce the VMware builds anymore. If you
want, you can run the v0.3 VMware [vagrant box][vagrant]
or [ovf][releases] and use it with the v0.3 tag in this repo. For
example, to use the vmware vagrant box, assuming you have a vmware
vagrant license, etc.

``` shell
mkdir lisp-in-small-pieces
cd lisp-in-small-pieces
vagrant init --box-version 0.3 appleby/lisp-in-small-pieces-vm
vagrant up --provider vmware
vagrant ssh
```

Once you're logged in to the vm:

``` shell
git clone https://github.com/appleby/lisp-in-small-pieces.git
cd lisp-in-small-pieces
git checkout v0.3
```

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


Other Schemes
-------------

In addition to bigloo, gambit, and mit-scheme the
[original sources][LiSP-2ndEdition] also supported elk, scheme2c, and
scm.  I'm not planning to get those working myself, but pull requests
are welcome.

Guile was not supported in the original sources.


More Info
---------

For a lot more info, see the [original README][README] file.


[README]: https://raw.githubusercontent.com/appleby/Lisp-In-Small-Pieces/master/README.orig
[vagrant]: https://app.vagrantup.com/appleby/boxes/lisp-in-small-pieces-vm
[releases]: https://github.com/appleby/Lisp-In-Small-Pieces-VM/releases/
[latest-release]: https://github.com/appleby/Lisp-In-Small-Pieces-VM/releases/latest

[LiSP]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/WWW/LiSP.html
[LiSP-2ndEdition]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/Books/LiSP-2ndEdition-2006Dec11.tgz

[bigloo]: http://www-sop.inria.fr/indes/fp/Bigloo
[gambit]: http://dynamo.iro.umontreal.ca/wiki/index.php/Main_Page
[mit-scheme]: http://www.gnu.org/software/mit-scheme/
[guile]: http://www.gnu.org/software/guile/
[vagrant]: https://www.vagrantup.com/
[vagrant-vmware]: https://www.vagrantup.com/vmware/
[packer]: https://www.packer.io/
