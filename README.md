Lisp In Small Pieces for Modern Schemes
=======================================

This repository contains source code from the book
[Lisp In Small Pieces][LiSP] by Christian Queinnec, updated to work
with modern versions of [Bigloo][bigloo], [Gambit][gambit],
[MIT Scheme][mit-scheme], and [Guile][guile].


Setting up an environment
-------------------------

If you want to run the code in this repo, you have the following
options, listed in decreasing order of likeliness-to-work:

1. [Use Virtualbox with Vagrant (preferred method)](#using-virtualbox-with-vagrant-preferred-method)
2. [Use Virtualbox without Vagrant](#using-virtualbox-without-vagrant)
3. [Use VMware (with or without Vagrant)](#using-vmware)
4. [Install dependencies yourself without using the provided virtual
   machines](#installing-dependencies-yourself)

If you have a reasonable internet connection and don't mind
downloading ~500MB of virtual machine, then options 1 and 2 are the
easiest, and provide the only tested and known-working
environment. The virtual machines are Arch Linux x86_64 systems with
all required dependencies pre-installed.


### Using Virtualbox with Vagrant (Preferred Method)

Using [Vagrant][vagrant] is the easiest way to get up and running with
an environment suitable for running the code in this repo. Assuming
you already have vagrant and virtualbox installed, just do the
following:

``` shell
git clone https://github.com/appleby/Lisp-In-Small-Pieces.git
cd Lisp-In-Small-Pieces
vagrant up
# Wait for vagrant to download the box and run it.
vagrant ssh
```

You should now be logged in to the vagrant box. Vagrant should have
mounted the Lisp-In-Small-Pieces source directory on `/vagrant` in the
vagrant guest. Therefore, you should be able to run `cd /vagrant` on
the vagrant box to get to the source files. Alternatively, you can
also just run `git clone` on the vagrant box to clone the repo there.

You can now skip to the section [Running the Code](#running-the-code).


### Using Virtualbox without Vagrant

If you want to use a known-working Virtualbox VM but don't want to
install Vagrant, you can download a tarball that contains an ovf and
the associated virtual disk [here][vm-latest-release].

Download the virtualbox tarball, extract it, and import the resulting
ovf into Virtualbox. You can login to the VM either via the console or
ssh with user `vagrant` and password `vagrant`.

You can now skip to the section [Running the Code](#running-the-code).


### Using VMware

In addition to the Virtualbox-compatible VMs mentioned above,
VMware-compatible versions are also available. However, I don't test
the VMware versions, not even to make sure they boot.  The VMware
versions are produced by the same [Packer][packer] build as the
Virtualbox versions. In so far as the Packer build was successful, the
VMware versions are expected to be equivalent to the Virtualbox
machines. They are provided as a convenience for people who already
have VMware installed and don't want to install Virtualbox.

The steps for getting set up with a VMware-based environment, either
with or without Vagrant, are essentially the same as the
[steps for Virtualbox described above](#using-virtualbox-with-vagrant-preferred-method),
just substituting VMware for Virtualbox everywhere. The one exception
is that VMware Tools are not installed on the guest, so Vagrant will
not be able to mount the Lisp-In-Small-Pieces sources on `/vagrant` in
the VMware guest. You will have to `git clone` the repository once
you've logged in to the guest.

Also note that you need to [purchase a license][vagrant-vmware] in
order to use the VMware provider with Vagrant, whereas the Virtualbox
provider is free.


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

- GCC 5.3.0
- GNU Make 4.1
- GNU Binutils 2.25.1 (ar, ranlib, size, ...)
- GNU coreutils 8.25 (uname, time, chmod, tee, nice, ...)
- GNU bash 4.3.42 (invoked as `sh`, so any Bourne shell likely OK)
- GNU grep 2.22
- Perl 5.22.1
- One or more of the following schemes
  - bigloo 4.2c
  - gambit 4.8.3
  - guile 2.0.11
  - mit-scheme 9.2

In addition to the above required dependencies, the following optional
dependencies are needed by certain tests which are not included in the
`grand.test` target, but which may be run individually.

- GNU indent 2.2.11
- Caml Light 0.82

Once you have the dependencies installed, you can keep your fingers
crossed and skip to [Running the Code](#running-the-code).


Running the Code
----------------

1. Clone this repo.
    `git clone http://github.com/appleby/Lisp-In-Small-Pieces.git`

2. Edit the Makefile and set the `SCHEME` variable to the scheme
   interpreter you want. The supported values for `SCHEME` are

        o/${HOSTTYPE}/book.bigloo
        o/${HOSTTYPE}/book.gsi
        o/${HOSTTYPE}/book.mit
        o/${HOSTTYPE}/book.guile

   So, e.g., to build the Gambit interpreter, set `SCHEME =
   o/${HOSTTYPE}/book.gsi`.

3. Run `make grand.test` to run the test suite. Running the tests will
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
[vm-latest-release]: https://github.com/appleby/Lisp-In-Small-Pieces-VM/releases/latest

[LiSP]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/WWW/LiSP.html
[LiSP-2ndEdition]: http://pagesperso-systeme.lip6.fr/Christian.Queinnec/Books/LiSP-2ndEdition-2006Dec11.tgz

[bigloo]: http://www-sop.inria.fr/indes/fp/Bigloo
[gambit]: http://dynamo.iro.umontreal.ca/wiki/index.php/Main_Page
[mit-scheme]: http://www.gnu.org/software/mit-scheme/
[guile]: http://www.gnu.org/software/guile/
[vagrant]: https://www.vagrantup.com/
[vagrant-vmware]: https://www.vagrantup.com/vmware/
[packer]: https://www.packer.io/
