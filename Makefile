###(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))
### This file is derived from the files that accompany the book:
###     LISP Implantation Semantique Programmation (InterEditions, France)
###     or  Lisp In Small Pieces (Cambridge University Press).
### By Christian Queinnec <Christian.Queinnec@INRIA.fr>
### The original sources can be downloaded from the author's website at
###   http://pagesperso-systeme.lip6.fr/Christian.Queinnec/WWW/LiSP.html
### This file may have been altered from the original in order to work with
### modern schemes. The latest copy of these altered sources can be found at
###   https://github.com/appleby/Lisp-In-Small-Pieces
### If you want to report a bug in this program, open a GitHub Issue at the
### repo mentioned above.
### Check the README file before using this file.
###(((((((((((((((((((((((((((((((( L i S P ))))))))))))))))))))))))))))))))

default.work : build.interpreter

# This is the Makefile of the distribution.  The first part defines
# the variables that you may have to setup in order to run the
# tests. The second part defines how to test the various parts of
# the sourcef files.

# If you decide to build a specialized interpreter on top of Bigloo
# then indicate the correct command to invoke bigloo.

BIGLOO = bigloo

# If you decide to build multiple specialized interpreters on
# multiple machines, then you must give different HOSTTYPE for all
# these CPU-different machines. Very often, HOSTTYPE is set up for
# you by your shell (tcsh does this). If so, you can leave empty
# this definition, it will be automatically inherited from your
# shell.

export HOSTTYPE := $(shell uname -m)

# Choose a Scheme interpreter. This interpreter must contain Meroonet,
# hygienic macros and a test-suite driver. It is better to build a
# specialized interpreter with these facilities compiled in.  See the
# target o/${HOSTTYPE}/book.bigloo below for an example of a
# pre-compiled interpreter. You can also directly use an interpreter
# and load on the fly Meroonet and the test-suite driver every time.
# This is what the MIT, Gambit, and Guile-based definitions do.

# The original Makefile defines only the SCHEME variable. MYSCHEME is
# a shorthand form that is easier to override on the make command
# line.
#
# The default value for MYSCHEME is bigloo because the Bigloo
# interpreter is the only one that is pre-compiled with Meroonet and
# other support code, and is quite a bit faster at executing the
# included test suite than any other interpreter.  -- appleby

MYSCHEME = bigloo
# MYSCHEME = gsi
# MYSCHEME = guile
# MYSCHEME = mit

SCHEME = o/${HOSTTYPE}/book.${MYSCHEME}

# This variable allows to measure time.  I personnally use Gnu time but time
# will do also.

TIME = time

# A temporary file used to store temporary results. Put it in a
# place where it will disappear automatically sometime.

RESULTS = o/test.results

# A temporary file used to store the names of failing tests when
# running the grand.test target.

FAILURES = o/test.failures

# Make an archive grouping *.o files
# You need it if you want to test the Scheme towards C compiler.

AR = ar

# Updating an archive (void on some machines)
# You need it if you want to test the Scheme towards C compiler.

RANLIB = ranlib

# Only needed for test.chap6.ml. -- appleby
CAMLLIGHT = camllight

# This is the C compiler I used as well as its preferred flags.
# You need it if you want to test the Scheme towards C compiler.

# On BSD, you probably want to set CC=gcc48, or whatever version of gcc you
# have installed. Note that it's not enough to specify CC=gcc48 on the make
# command line. The `export' clause here will override it. -- appleby

export CC=gcc
export CFLAGS=-ansi -pedantic -Wall -O

# This is perl. I use it for checking results of tests. It is not
# mandatory to setup this variable.

PERL = perl

# Absolute path to LiSP source root. -- appleby
export LiSP_TOPDIR=${PWD}

# Set the SHELL explicitly. Mit-scheme's run-shell-command respects
# this variable, and some shell commands will fail if using a non-standard
# shell (e.g. fish). -- appleby
export SHELL=/bin/sh

# This part of the Makefile defines how to run and test the programs
# of the book.

# Build the necessary directories where will go specialized interpreters.
MKDIR_TARGET = o/${HOSTTYPE}/mkdir_done
${MKDIR_TARGET}:
	mkdir -p o/${HOSTTYPE}
	touch $@

##################################### Build specialized interpreters.
# Rebuild a Bigloo interpreter with Meroonet and tester in it.
# Adapted to Bigloo 4.1a. Due to name conflicts, the compilation of
# rtbook.scm emits much warnings: ignore them!

o/${HOSTTYPE}/book.bigloo : bigloo/book.scm o/${HOSTTYPE}/rtbook.a
	${BIGLOO} -v -call/cc -cg -o o/${HOSTTYPE}/book.bigloo bigloo/book.scm \
	    -ldopt o/${HOSTTYPE}/rtbook.a
	-rm bigloo/book.[co] o/${HOSTTYPE}/book.[co]

o/${HOSTTYPE}/rtbook.a : o/${HOSTTYPE}/rtbook.o common/pp.scm common/format.scm
	-rm o/${HOSTTYPE}/rtbook.a
	cd o/${HOSTTYPE} ; ${AR} cvr rtbook.a rtbook.o
	-${RANLIB} o/${HOSTTYPE}/rtbook.a

o/${HOSTTYPE}/rtbook.o : bigloo/rtbook.scm bigloo/hack.scm src/tester.scm ${MKDIR_TARGET}
	${BIGLOO} -c -v -call/cc -cg -w -o o/${HOSTTYPE}/rtbook.o bigloo/rtbook.scm
	-rm bigloo/rtbook.[co] o/${HOSTTYPE}/rtbook.c

# Default work for the distribution, create some sub-directories
# where will go compilation products.
build.interpreter : ${MKDIR_TARGET}
	@if [ "X${SCHEME}" = X ] ; \
	    then echo "*** Unbound SCHEME variable, see Makefile" ; exit 1 ; \
	    else : ; fi

	case "${SCHEME}" in \
	    *bigloo|*gsi|*mit|*guile) ${MAKE} ${SCHEME} ;; \
	    *) : ;; esac

######################################## Test interpreters

test.interpreters : o/${HOSTTYPE}/book.bigloo.test o/${HOSTTYPE}/book.mit.test \
    o/${HOSTTYPE}/book.gsi.test o/${HOSTTYPE}/book.guile.test

MIT_BAND_FILE=o/${HOSTTYPE}/book.mit.com
${MIT_BAND_FILE} : ${MKDIR_TARGET}
	echo "(disk-save \"${MIT_BAND_FILE}\" \"${MIT_BAND_FILE}\")" \
	| mit-scheme --batch-mode --no-init-file --load mitscheme/book.scm

# Makes a command to run mitscheme. Must be run from the current
# directory.
o/${HOSTTYPE}/book.mit : ${MIT_BAND_FILE}
	echo "#!/bin/sh" > $@
	echo "exec mit-scheme --band ${MIT_BAND_FILE} --eval '(start)'" >> $@
	chmod a=rwx $@

# Makes a command to run guile. Must be run from the current
# directory.
o/${HOSTTYPE}/book.guile : ${MKDIR_TARGET}
	echo "#!/bin/sh" > $@
	echo "exec guile -q -l guile/book.scm" >> $@
	chmod a=rwx $@

# Makes a command for Gambit interpreter similar to the others.
# This command has to be run from the current directory.
o/${HOSTTYPE}/book.gsi : ${MKDIR_TARGET}
	echo "#!/bin/sh" > o/${HOSTTYPE}/book.gsi
	echo "exec gsi -:s,d- gambit/book.scm" >> o/${HOSTTYPE}/book.gsi
	chmod a=rwx o/${HOSTTYPE}/book.gsi

check.results :
	@if grep -i '= done' ${RESULTS} ; \
	    then echo '*** Tests successfully passed ***' ; \
	    else echo '*** *** Abnormal results **** ***' ; exit 1 ; fi

o/${HOSTTYPE}/book.bigloo.test :
	${MAKE} SCHEME=o/${HOSTTYPE}/book.bigloo book.interpreter.test
o/${HOSTTYPE}/book.gsi.test :
	${MAKE} SCHEME=o/${HOSTTYPE}/book.gsi book.interpreter.test
o/${HOSTTYPE}/book.mit.test :
	${MAKE} SCHEME=o/${HOSTTYPE}/book.mit book.interpreter.test
o/${HOSTTYPE}/book.guile.test :
	${MAKE} SCHEME=o/${HOSTTYPE}/book.guile book.interpreter.test

book.interpreter.test : book.interpreter.test1 book.interpreter.test2 \
			book.interpreter.test3 book.interpreter.test4
book.interpreter.test1 : ${SCHEME}
	echo '(test "src/syntax.tst")' | ${SCHEME} | tee ${RESULTS}
	${MAKE} check.results
book.interpreter.test2 : ${SCHEME}
	echo '(test "meroonet/oo-tests.scm")' | ${SCHEME} | tee ${RESULTS}
	${MAKE} check.results
book.interpreter.test3 : ${SCHEME}
	${MAKE} SCHEME=${SCHEME} test.chap1 | tee ${RESULTS}
	${MAKE} check.results
book.interpreter.test4 : ${SCHEME}
	${MAKE} SCHEME=${SCHEME} test.chap2a | tee ${RESULTS}
	${MAKE} check.results

########################## All the tests
# Some tests have a name starting with no. That means that the test
# has some problems (it does not complete or loops) I just verify
# that it ends at the expected point. Some test have a name starting
# with long. That means that it is a very long long test, so it is
# only run if the variable YOU_HAVE_TIME is true (not false).

# Moore's law has been kind to us. Tests that apparently took hours to
# run on the original author's machine 20 years ago now complete in
# less than a minute. I'm leaving the long- prefixes and YOU_HAVE_TIME
# alone since they're still useful, but unless you're really
# impatient, you probably don't want to disable the "long" tests. For
# reference, the entire grand.test suite takes about 6 minutes to
# complete even with the slower interpreters on my 5-year-old (as of
# late 2014) laptop. When using a pre-compiled interpreter
# (i.e. SCHEME = book.bigloo) the entire suite finishes in less than 3
# minutes. -- appleby

YOU_HAVE_TIME = true

GRAND_TESTS = ${TEST_CHAP1} ${TEST_CHAP2} ${TEST_CHAP3} ${TEST_CHAP4} \
	      ${TEST_CHAP5} ${TEST_CHAP6} ${TEST_CHAP7} ${TEST_CHAP8} \
	      ${TEST_CHAP9} ${TEST_CHAP10}

GRAND_TEST_FLAGS = SCHEME="${SCHEME}" YOU_HAVE_TIME="${YOU_HAVE_TIME}"

grand.test :
	${TIME} nice ${MAKE} do.grand.test ${GRAND_TEST_FLAGS}

do.grand.test : ${SCHEME}
	@rm -f ${FAILURES}
	@for test in ${GRAND_TESTS} ; do \
	    ( echo Testing $$test ... ; ${MAKE} $$test ${GRAND_TEST_FLAGS} ) \
	    | tee ${RESULTS} ; echo Checking results of $$test ... ; \
	    ${PERL} perl/check.prl ${RESULTS} $$test ; \
	    [ $$? -ne 0 ] && echo $$test >> ${FAILURES} ; \
	done; echo "Finished grand.test"

	@[ -e ${FAILURES} ] && ( echo "The following tests failed:"; \
	    cat ${FAILURES} ) || echo "All tests passed."

grand.test.with.bigloo : o/${HOSTTYPE}/book.bigloo
	${MAKE} grand.test SCHEME=o/$$HOSTTYPE/book.bigloo
grand.test.with.gsi : o/${HOSTTYPE}/book.gsi
	${MAKE} grand.test SCHEME=o/$$HOSTTYPE/book.gsi
grand.test.with.mit : o/${HOSTTYPE}/book.mit
	${MAKE} grand.test SCHEME=o/$$HOSTTYPE/book.mit
grand.test.with.guile : o/${HOSTTYPE}/book.guile
	${MAKE} grand.test SCHEME=o/$$HOSTTYPE/book.guile


########################## (Really) All the tests
# Run all tests for all schemes. This includes all tests from the
# test.interpreters and grand.test targets, plus a handful of other
# targets. -- appleby
ALL_SCHEMES = bigloo guile gsi mit
EXTRA_TESTS = chap10e.example chap10k.example o/chap10ex.E test.chap10e.c
MISC_TARGETS = test.chap6.bgl test.chap6.ml compare.chap10
GRAND_BENCH = ${BENCH_CHAP5} ${BENCH_CHAP6} ${BENCH_CHAP7}

define ok-or-fail =
	${PERL} -e "printf '%-40s', '"${1}"'" ; \
	${2} ; \
	if [ $$? -eq 0 ] ; \
	   then echo ok ; \
	   else echo fail; echo "    ${1}" >> "${FAILURES}"; fi
endef

all.test:
	@${TIME} ${MAKE} -s do.all.test

do.all.test:
	@${MAKE} clean
	@${MAKE} misc.test
	@for scheme in ${ALL_SCHEMES} ; do \
	    ${MAKE} clean.all.but.failures; \
	    ${MAKE} interpreter.test MYSCHEME=$$scheme; \
	    ${MAKE} extra.test MYSCHEME=$$scheme; \
	    ${MAKE} grand.test.quiet MYSCHEME=$$scheme; \
	    ${MAKE} grand.bench.quiet MYSCHEME=$$scheme; \
	done; echo "Finished test.all."

	@if [ -e ${FAILURES} ]; \
		then echo "The following tests failed:"; cat ${FAILURES}; \
		else echo "All tests passed."; fi

interpreter.test: ${MKDIR_TARGET}
	@$(call ok-or-fail,"Running book.${MYSCHEME}.test",\
		${MAKE} o/${HOSTTYPE}/book.${MYSCHEME}.test > /dev/null 2>&1)

misc.test: ${MKDIR_TARGET}
	@for target in ${MISC_TARGETS} ; do \
	    $(call ok-or-fail,"Running $$target",\
	        ${MAKE} $$target > ${RESULTS} 2>/dev/null) ; \
	done

extra.test: ${SCHEME}
	@for target in ${EXTRA_TESTS} ; do \
	    $(call ok-or-fail,"Running $$target with ${MYSCHEME}",\
		${MAKE} $$target MYSCHEME=${MYSCHEME} > ${RESULTS} 2> /dev/null) ; \
	done

grand.test.quiet: ${SCHEME}
	@for target in ${GRAND_TESTS} ; do \
	    $(call ok-or-fail,"Running $$target with ${MYSCHEME}",\
	        ${MAKE} $$target MYSCHEME=${MYSCHEME} > ${RESULTS} 2> /dev/null \
	        && ${PERL} perl/check.prl ${RESULTS} $$target > /dev/null) ; \
	done

grand.bench.quiet: ${SCHEME}
	@for target in ${GRAND_BENCH} ; do \
	    $(call ok-or-fail,"Running $$target with ${MYSCHEME}",\
	        ${MAKE} $$target MYSCHEME=${MYSCHEME} > ${RESULTS} 2> /dev/null) ; \
	done


##################################### Chap 1 ##############################

TEST_CHAP1 = test.chap1

# chap1.scm contains a naive interpreter written in naive Scheme.
test.chap1 : src/chap1.scm
	echo \
	    '(load "src/chap1.scm")' \
	    '(and (test-scheme1 "src/scheme.tst")' \
	    '     (test-scheme1 "src/chap1.tst"))' \
	| ${SCHEME}

##################################### Chap 2 ##############################

TEST_CHAP2 = test.chap2a test.chap2b test.chap2c test.chap2e test.chap2f \
	     test.chap2g test.chap2h

# chap2a.scm contains a little Lisp2 interpreter (eval e env fenv).
# chap2d.scm displays simple cyclic lists in a finite way.
test.chap2a : src/chap2a.scm
	echo \
	    '(load "src/chap2a.scm")' \
	    '(and (test-chap2a "src/chap2a.tst")' \
	    '     (load "src/chap2d.scm")' \
	    "     'done)" \
	| ${SCHEME}

# chap2b.scm adds flet and function to the previous interpreter
src/chap2b.scm : src/chap2a.scm
test.chap2b : src/chap2b.scm
	echo \
	    '(load "src/chap2a.scm")' \
	    '(load "src/chap2b.scm")' \
	    '(test-scheme2a "src/chap2b.tst")' \
	| ${SCHEME}

# chap2c.scm adds dynamic variables (eval e env fenv denv)
src/chap2c.scm : src/chap2b.scm
test.chap2c : src/chap2c.scm
	echo \
	    '(load "src/chap2a.scm")' \
	    '(load "src/chap2b.scm")' \
	    '(load "src/chap2c.scm")' \
	    '(test-scheme2c "src/chap2c.tst")' \
	| ${SCHEME}

# chap2e.scm adds dynamic variables a la Common Lisp
src/chap2e.scm : src/chap2c.scm
test.chap2e : src/chap2e.scm
	echo \
	    '(load "src/chap2a.scm")' \
	    '(load "src/chap2b.scm")' \
	    '(load "src/chap2c.scm")' \
	    '(load "src/chap2e.scm")' \
	    '(test-scheme2c "src/chap2e.tst")' \
	| ${SCHEME}

# chap2f.scm adds dynamic variables without special forms
test.chap2f : src/chap2f.scm
	echo \
	    '(load "src/chap2f.scm")' \
	    '(test-scheme2f "src/chap2f.tst")' \
	| ${SCHEME}

# chap2g.scm adds the let, letrec special forms to chap1.scm (scheme)
src/chap2g.scm : src/chap1.scm
test.chap2g : src/chap2g.scm
	echo \
	    '(load "src/chap1.scm")' \
	    '(load "src/chap2g.scm")' \
	    '(and (test-scheme1 "src/scheme.tst")' \
	    '     (test-scheme1 "src/chap2g.tst"))' \
	| ${SCHEME}

# chap2h.scm allows extensions such as (1 e) or ((f1 f2) e)
src/chap2h.scm : src/chap1.scm
test.chap2h : src/chap2h.scm
	echo \
	    '(load "src/chap1.scm")' \
	    '(load "src/chap2h.scm")' \
	    '(and (test-scheme1 "src/scheme.tst")' \
	    '     (test-scheme1 "src/chap2h.tst"))' \
	| ${SCHEME}

##################################### Chap 3 ##############################

TEST_CHAP3 = test.chap3f test.chap3h

# chap3{a,b,c,d,e}.scm contain excerpts from chapter3 (not necessarily
# Scheme).

# chap3f.scm contains an interpreter in OO style
test.chap3f : src/chap3g.scm
	echo \
	    '(load "src/chap3f.scm")' \
	    '(load "src/chap3g.scm")' \
	    '(load "src/chap3h.scm")' \
	    '(test-scheme3f "src/scheme.tst")' \
	| ${SCHEME}

# chap3g.scm defines additional control features (block, catch)
# chap3h.scm defines unwind-protect
# chap3j.scm improves chap3f.scm
src/chap3g.scm : src/chap3f.scm
src/chap3h.scm : src/chap3f.scm
src/chap3j.scm : src/chap3f.scm
test.chap3h : src/chap3g.scm
	echo \
	    '(load "src/chap3f.scm")' \
	    '(load "src/chap3g.scm")' \
	    '(load "src/chap3h.scm")' \
	    '(load "src/chap3j.scm")' \
	    '(and (test-scheme3f "src/scheme.tst")' \
	    '     (test-scheme3f "src/chap3f.tst"))' \
	| ${SCHEME}

##################################### Chap 4 ##############################

TEST_CHAP4 = test.chap4

# chap4.scm contains excerpts from chapter 4
# chap4a.scm contains a Scheme interpreter coded with nothing but closures.
test.chap4 : src/chap4.scm src/chap4a.scm src/chap4.tst
	echo \
	    '(load "src/chap4.scm")' \
	    '(load "src/chap4a.scm")' \
	    "(define box1 'wait)" \
	    "(define p1 'wait)" \
	    '(and (file-test "src/scheme.tst")' \
	    '     (set! evaluate new-evaluate)' \
	    '     (file-test "src/chap4a.tst")' \
	    '     (suite-test' \
	    '       "src/chap4.tst" "?? " "== " #t' \
	    '       (lambda (read check err)' \
	    "         (lambda () (check (eval (read)))))" \
	    '       naive-match))' \
	| ${SCHEME}

##################################### Chap 5 ##############################
# Denotational semantics

TEST_CHAP5 = test.chap5a loop.test.chap5b test.chap5c test.chap5d test.chap5e \
	     test.chap5f test.chap5g test.chap5h

BENCH_CHAP5 = bench.chap5a bench.chap5d

bench.chap5 : bench.chap5a

test.chap5a : src/chap5a.scm
	echo \
	    '(load "src/chap5a.scm")' \
	    '(test-denScheme "src/scheme.tst")' \
	| ${SCHEME}

# See typical times a the end of src/chap5-bench.scm
bench.chap5a : src/chap5a.scm
	echo \
	    '(load "src/chap5a.scm")' \
	    '(bench "src/chap5-bench.scm")' \
	| ${SCHEME}

# Lambda calculus denotation
# The last tests loop due to applicative order.
loop.test.chap5b :
	-echo skip that test or run it by hand : ${MAKE} test.chap5b
test.chap5b : src/chap5b.scm
	echo \
	    '(load "src/chap5b.scm")' \
	    '(test-L "src/chap5b.tst")' \
	| ${SCHEME}

# Scheme + dynamic variables denotational interpreter
test.chap5c : src/chap5c.scm
	echo \
	    '(load "src/chap5c.scm")' \
	    '(and (test-denScheme "src/scheme.tst")' \
	    '     (test-denScheme "src/chap5c.tst"))' \
	| ${SCHEME}

# Same as chap5c except that this one tries to precompute meanings.
# This is slightly faster than chap5a.
test.chap5d : src/chap5d.scm
	echo \
	    '(load "src/chap5d.scm")' \
	    '(test-denScheme "src/scheme.tst")' \
	| ${SCHEME}

bench.chap5d : src/chap5d.scm src/chap5-bench.scm
	echo \
	    '(load "src/chap5d.scm")' \
	    '(bench "src/chap5-bench.scm")' \
	| ${SCHEME}

# Modify the denotational interpreter chap5d to specify that
# the evaluation order is unspecified.
test.chap5e : src/chap5e.scm
	echo \
	    '(load "src/chap5d.scm")' \
	    '(load "src/chap5e.scm")' \
	    '(test-den+Scheme "src/chap5e.tst")' \
	| ${SCHEME}

# CPS without any tests.
test.chap5f : src/chap5f.scm
	echo \
	    '(and (load "src/chap5f.scm")' \
	    "     'done)" \
	| ${SCHEME}

# Same as chap5d with an explicit global environment.
test.chap5g : src/chap5g.scm
	echo \
	    '(load "src/chap5g.scm")' \
	    '(and (test-denScheme "src/scheme.tst")' \
	         '(test-denScheme "src/chap5g.tst"))' \
	| ${SCHEME}

# Unordered evaluation order simulated with random.
test.chap5h : src/chap5h.scm
	echo \
	    '(load "src/chap5h.scm")' \
	    '(load "src/chap1.scm")' \
	    '(test-scheme1 "src/scheme.tst")' \
	| ${SCHEME}

##################################### Chap 6 ##############################
# Chapter on fast interpretation (by means of precompilation)

TEST_CHAP6 = test.chap6a test.chap6b test.chap6c test.chap6d \
	     shared.test.chap6dd test.chap6e dynext.test.chap6f test.chap6g \
	     test.chap6h

BENCH_CHAP6 = bench.chap6a bench.chap6b bench.chap6c bench.chap6d bench.chap6e bench.chap6f

bench.chap6 : bench.chap6a bench.chap6b bench.chap6c bench.chap6d bench.chap6e

# Fast interpretation, code is precompiled into (lambda (sr k)..)
test.chap6a : src/chap6a.scm
	echo \
	    '(load "src/chap6a.scm")' \
	    '(test-scheme6a "src/scheme.tst")' \
	| ${SCHEME}

# Interpreted bench
bench.chap6a : src/chap6a.scm
	echo \
	    '(load "src/chap6a.scm")' \
	    '(bench6a 1 (call-with-input-file "src/chap5-bench.scm" read))' \
	| ${SCHEME}

# The file bigloo/compapp.scm was not included in the source tarball
# from the author's site. One could re-create
# `compile-bigloo-application' and get this target working again, if
# one so desired. I do not so desire. -- appleby
#
# Compiled bench with Bigloo
# test.chap6a.bgl : o/${HOSTTYPE}/rtbook.a o/${HOSTTYPE}/bglchap6a
# 	${TIME} o/${HOSTTYPE}/bglchap6a 10

# o/${HOSTTYPE}/bglchap6a : src/chap6a.scm bigloo/compapp.scm
# 	echo \
# 	    '(load "bigloo/compapp.scm")' \
# 	    '(define the-bench (call-with-input-file "src/chap5-bench.scm" read))' \
# 	    '(compile-bigloo-application '\
# 	    '  "${BIGLOO}" "o/${HOSTTYPE}/" "bglchap6a" ' \
# 	    "  `(bench6a (string->number (cadr command-options)) ',the-bench)" \
# 	    '  "src/chap6a.scm")' \
# 	| ${SCHEME}

# Testing the same fast interpreter with Bigloo (intepreted)
test.chap6.bgl :
	echo \
	    "(define primes " \
	    " (lambda (n f max)" \
	    "    ((lambda (filter) " \
	    "       (begin " \
	    "          (set! filter (lambda (p) (lambda (n) (= 0 (remainder n p)))))" \
	    "          (if (> n max)" \
	    "              '()" \
	    "              (if (f n)" \
	    "                  (primes (+ n 1) f max)" \
	    "                  (cons n ((lambda (ff)" \
	    "                             (primes (+ n 1)" \
	    "                                     (lambda (p) (if (f p) #t (ff p)))" \
	    "                                     max))" \
	    "                           (filter n)))))))" \
	    "     'wait)))" \
	    "(define (bench factor)" \
	    "  (let loop ((factor factor))" \
	    "    (let ((v (eval '(primes 2 (lambda (x) #f) 500))))" \
	    "      (if (> factor 1)" \
	    "        (loop (- factor 1))" \
	    "        (display v)))))" \
	    "(bench 100)" \
	| ${TIME} ${BIGLOO} -i

# Compare also with CAML light
test.chap6.ml :
	echo \
	    "let rec primes n f max =" \
	    "  let filter p n = (0 = n mod p) in" \
	    "    if (n > max) then" \
	    "      []" \
	    "    else if (f n) then" \
	    "      primes (n+1) f max" \
	    "    else" \
	    "      n :: let ff = (filter n) in" \
	    "             primes (n+1)" \
	    "                    (function p -> if (f p) then true else (ff p))" \
	    "                    max;;" \
	    "let bench factor =" \
	    "  let rec loop factor =" \
	    "    let v = primes 2 (fun x -> false) 500 in" \
	    "      if (factor > 1) then" \
	    "        loop (factor-1)" \
	    "      else" \
	    "        v" \
	    "  in" \
	    "    loop factor;; " \
	    "bench 100;;" \
	    | ${TIME} ${CAMLLIGHT}

# patch to chap6a.scm to define new global variables on the fly:
test.chap6b : src/chap6a.scm src/chap6b.scm
	echo \
	    '(load "src/chap6a.scm")' \
	    '(load "src/chap6b.scm")' \
	    '(and (test-scheme6b "src/chap6b.tst")' \
	    '     (test-scheme6b "src/scheme.tst"))' \
	| ${SCHEME}

# Interpreted bench
bench.chap6b : src/chap6a.scm src/chap6b.scm
	echo \
	    '(load "src/chap6a.scm")' \
	    '(load "src/chap6b.scm")' \
	    '(bench6a 1 (call-with-input-file "src/chap5-bench.scm" read))' \
	| ${SCHEME}

# Environment is now held in a global variable *env*.
# Programs are precompiled into (lambda (k) ...)
test.chap6c : src/chap6c.scm
	echo \
	    '(load "src/chap6a.scm")' \
	    '(load "src/chap6c.scm")' \
	    '(test-scheme6c "src/scheme.tst")' \
	| ${SCHEME}

# Interpreted bench
bench.chap6c : src/chap6c.scm
	echo \
	    '(load "src/chap6a.scm")' \
	    '(load "src/chap6c.scm")' \
	    '(bench6c 1 (call-with-input-file "src/chap5-bench.scm" read))' \
	| ${SCHEME}

# Make continuation implicit.
# The program is precompiled into (lambda ()...)
test.chap6d : src/chap6d.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(test-scheme6d "src/scheme.tst")' \
	| ${SCHEME}

# Interpreted bench
bench.chap6d : src/chap6d.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(bench6d 1 (call-with-input-file "src/chap5-bench.scm" read))' \
	| ${SCHEME}

# Variant with pre-allocated frames (work for Lisp not for Scheme)
# An error is expected on one of the lattest tests on call/cc. This
# test is preceded by the string "The following test forces a
# continuation to return multiply."
shared.test.chap6dd : test.chap6dd
test.chap6dd : src/chap6d.scm src/chap6dd.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap6dd.scm")' \
	    '(and (test-scheme6d "src/chap6dd.tst")' \
	    '     (test-scheme6d "src/scheme.tst"))' \
	| ${SCHEME}

# a small byte-tree-code compiler. (Not used in the book)
test.chap6e : src/chap6e.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap6e.scm")' \
	    '(test-scheme6e "src/scheme.tst")' \
	| ${SCHEME}

bench.chap6e : src/chap6e.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap6e.scm")' \
	    '(bench6e 1 (call-with-input-file "src/chap5-bench.scm" read))' \
	| ${SCHEME}

# chap6e is very dependent on tests on types in byte-eval
# but faster than Scheme->C.

########### Skip chap6f which was superseded by chap10.
# Small compiler towards C (not in the book but still working). This
# compiler uses a different pattern of C generation and a variant
# for environment management. That's why I leave it here. It is
# grafted to the precompiler similarly to the bytecode compiler.
# ATTENTION, this is a very long test. This test fails on
# continuation used out of their dynamic extent (no full
# continuation a la Scheme).
long.dynext.test.chap6f :
	if ${YOU_HAVE_TIME} ; then ${MAKE} dynext.test.chap6f ; else : ; fi
dynext.test.chap6f : test.chap6f
test.chap6f : o/${HOSTTYPE}/rt.o src/chap6f.scm
	echo \
	    '(load "src/chap6f.scm")' \
	    '(test-scheme6f "src/scheme.tst")' \
	| ${SCHEME}

# start an interpreter to interactively compile towards C.
#
# The (scheme) toplevel reads an expression and shows the generated
# C.  This test fails on continuation used out of their dynamic
# extent (no full continuation a la Scheme).
start.chap6f : o/${HOSTTYPE}/rt.o src/chap6f.scm
	@(echo '(load "src/chap6f.scm") (scheme6f)' ; tee ) | ${SCHEME}

# A little bench to appreciate the compiler speed. (obsolete)
bench.chap6f : o/${HOSTTYPE}/chap6f-bench
	${TIME} o/${HOSTTYPE}/chap6f-bench

export CaFLAGS=-I${LiSP_TOPDIR}/src/c ${CFLAGS}

o/${HOSTTYPE}/chap6f-bench.c : src/chap6f.scm src/chap5-bench.scm
	echo \
	    '(load "src/chap6f.scm")' \
	    '(compile-file "src/chap5-bench.scm" "$@")' \
	| ${SCHEME}
	-indent $@

# The runtime in C for that compiler. Generates a lot of warnings...
# superseded by the new library src/c/scheme*.[ch] (but this one
# contains a GC).
o/${HOSTTYPE}/rt.o : src/c/rt.c src/c/rt.h
	cd o/${HOSTTYPE} ; ${CC} -c ${CaFLAGS} ../../src/c/rt.c
o/${HOSTTYPE}/chap6f-bench : o/${HOSTTYPE}/chap6f-bench.c
o/${HOSTTYPE}/chap6f-bench : o/${HOSTTYPE}/rt.o
	${CC} -o $@ ${CaFLAGS} o/${HOSTTYPE}/chap6f-bench.c o/${HOSTTYPE}/rt.o

########### end of chap6f which was superseded by chap10. (obsolete)

# Handling the define special form.
test.chap6g : src/chap6a.scm src/chap6b.scm src/chap6g.scm
	echo \
	    '(load "src/chap6a.scm")' \
	    '(load "src/chap6b.scm")' \
	    '(load "src/chap6g.scm")' \
	    '(and (test-scheme6b "src/chap6g.tst")' \
	    '     (test-scheme6b "src/scheme.tst"))' \
	| ${SCHEME}

# exercice on a specialized invocation protocol for thunks
test.chap6h : src/chap6d.scm src/chap6h.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap6h.scm")' \
	    '(test-scheme6d "src/scheme.tst")' \
	| ${SCHEME}

##################################### Chap 7 ##############################
# Bytecode compilation
TEST_CHAP7 = test.chap7a test.chap7b test.chap7c test.chap7d test.chap7e \
	     test.chap7g test.chap7h shallow.test.chap7i

BENCH_CHAP7 = bench.chap7d

bench.chap7 : bench.chap7d

# Linearize the intermediate language to make register *val* appear.
test.chap7a : src/chap6d.scm src/chap7a.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7a.scm")' \
	    '(test-scheme7a "src/scheme.tst")' \
	| ${SCHEME}

# make stack appear (as well as other registers)
test.chap7b : src/chap6d.scm src/chap7b.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7b.scm")' \
	    '(test-scheme7b "src/scheme.tst")' \
	| ${SCHEME}

# represents instructions by list of closures. Make register PC
# appear.
test.chap7c : src/chap6d.scm src/chap7c.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7c.scm")' \
	    '(test-scheme7c "src/scheme.tst")' \
	| ${SCHEME}

# the complete bytecode compiler itself.
# The instruction set is defined in chap7f but is directly
# handled by chap7d.
test.chap7d : src/chap6d.scm src/chap7d.scm src/chap7f.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(test-scheme7d "src/scheme.tst")' \
	| ${SCHEME}

bench.chap7d : src/chap6d.scm src/chap7d.scm src/chap7f.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(bench7d 1 (call-with-input-file "src/chap5-bench.scm" read))' \
	| ${SCHEME}

# added bind-exit, dynamic variables and error handling (first version
# with dynenv register) in the bytecode compiler.
test.chap7e : src/chap7d.scm src/chap7e.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7e.scm")' \
	    '(and (test-scheme7e "src/scheme.tst")' \
	    '     (test-scheme7e "src/chap7d.tst")' \
	    '     (test-scheme7e "src/chap5c.tst"))' \
	| ${SCHEME}

# chap7f.scm contains the definition of the instructions of the machine

# separate compilation stuff, link compiled files, build stand-alone
# with the bytecode compiler.
test.chap7g : src/chap7h.scm src/chap7g.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(load "src/chap7g.scm")' \
	    '(and (test-scheme7g "src/scheme.tst")' \
	    '     (test-scheme7g "src/chap7d.tst")' \
	    '     (test-scheme7g "src/chap5c.tst"))' \
	    '(compile-file "si/foo.scm" "o/foo.so")' \
	    '(run-application 100 "o/foo.so")' \
	    '(compile-file "si/fact.scm" "o/fact.so")' \
	    '(compile-file "si/fib.scm" "o/fib.so")' \
	    '(compile-file "si/after.scm" "o/after.so")' \
	    '(build-application' \
	    '  "o/a.out" "o/fact.so" "o/fib.so" "o/foo.so" "o/after.so")' \
	    '(run-application 400 "o/a.out")' \
	    '(build-application-renaming-variables' \
	    '  "o/na.out" "o/a.out"' \
	    "  '((fib fact) (fact fib)))" \
	    '(run-application 400 "o/na.out")' \
	    "(assoc 'long-goto (disassemble *code*))" \
	| ${SCHEME}

# implementation variant for dynamic variables, error handlers
# with labels in the stack (without dynenv register).
test.chap7h : src/chap7d.scm src/chap7h.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(and (test-scheme7h "src/scheme.tst")' \
	    '     (test-scheme7h "src/chap7d.tst")' \
	    '     (test-scheme7h "src/chap5c.tst"))' \
	| ${SCHEME}

# shallow binding for dynamic variables
# It will fail on the last test of src/chap7d.tst
shallow.test.chap7i : test.chap7i
test.chap7i : src/chap7h.scm
	echo \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(load "src/chap7i.scm")' \
	    '(and (test-scheme7h "src/scheme.tst")' \
	    '     (test-scheme7h "src/chap5c.tst")' \
	    '     (test-scheme7h "src/chap7d.tst"))' \
	| ${SCHEME}

##################################### Chap 8 ##############################
# Chapter on evaluation and reflection

TEST_CHAP8 = test.chap8a test.chap8b test.chap8c test.chap8d evalf.test.chap8e \
	     evalf.test.chap8f evalf.test.chap8g test.chap8h test.chap8i \
	     big.test.chap8j

# add eval/ce (as a special form) to the naive interpreter of chapter 1.
test.chap8a : src/chap8a.scm src/chap1.scm
	echo \
	    '(load "src/chap1.scm")' \
	    '(load "src/chap8a.scm")' \
	    '(and (test-scheme1 "src/scheme.tst")' \
	    '     (test-program "src/chap8.tst")' \
	    '     (set! set-global-value! dynamic-set-global-value!)' \
	    '     (test-scheme1 "src/chap8a.tst"))' \
	| ${SCHEME}

# Add eval/ce (as a special form) to the predenotational interpreter
# (with closures everyhere) seen in chapter 4.
test.chap8b : src/chap8b.scm src/chap4a.scm
	echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap4a.scm")' \
	    '(load "src/chap8b.scm")' \
	    '(and (file-test "src/scheme.tst")' \
	    '     (file-test "src/chap8a.tst"))' \
	| ${SCHEME}

# Add eval/ce (as a special form) to the threaded interpreter of
# chapter 6.
test.chap8c : src/chap8c.scm src/chap6d.scm
	echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap8c.scm")' \
	    '(and (test-scheme6d "src/scheme.tst")' \
	    '     (test-scheme6d "src/chap8a.tst"))' \
	| ${SCHEME}

# Add eval/ce (as a special form) to the bytecode compiler
test.chap8d : src/chap8c.scm src/chap8d.scm src/chap6d.scm
	echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(load "src/chap7g.scm")' \
	    '(load "src/chap8d.scm")' \
	    '(and (test-scheme7g "src/scheme.tst")' \
	    '     (test-scheme7g "src/chap5c.tst")' \
	    '     (test-scheme7g "src/chap7d.tst")' \
	    '     (test-scheme7g "src/chap8a.tst"))' \
	| ${SCHEME}

# add eval/at (a function) as a function to the naive interpreter
# It fails on a test preceded by "eval as a function will fail..."
evalf.test.chap8e : src/chap8e.scm src/chap1.scm
	echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap1.scm")' \
	    '(load "src/chap8e.scm")' \
	    '(and (test-scheme1 "src/scheme.tst")' \
	    '     (test-scheme1 "src/chap8a.tst"))' \
	| ${SCHEME}

# add eval/at (a function) to the bytecode compiler.
# It fails on a test preceded by "eval as a function will fail..."
evalf.test.chap8f : src/chap8f.scm
	echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(load "src/chap7g.scm")' \
	    '(load "src/chap8f.scm")' \
	    '(and (test-scheme7g "src/scheme.tst")' \
	    '     (test-scheme7g "src/chap5c.tst")' \
	    '     (test-scheme7g "src/chap7d.tst")' \
	    '     (test-scheme7g "src/chap8a.tst"))' \
	| ${SCHEME}

# represent interpreted functions as functions in the naive interpreter.
# It fails on a test preceded by "eval as a function will fail..."
evalf.test.chap8g : src/chap8g.scm src/chap1.scm
	echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap1.scm")' \
	    '(load "src/chap8g.scm")' \
	    '(and (test-scheme1 "src/scheme.tst")' \
	    '     (test-scheme1 "src/chap8a.tst"))' \
	| ${SCHEME}

# Add the export special form and a binary function eval/b,
# also add procedure->body and procedure->environment.
test.chap8h : src/chap8h.scm
	echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(load "src/chap7g.scm")' \
	    '(load "src/chap8h.scm")' \
	    '(and (test-scheme7g "src/scheme.tst")' \
	    '     (test-scheme7g "src/chap5c.tst")' \
	    '     (test-scheme7g "src/chap7d.tst")' \
	    '     (test-scheme7g "src/chap8h.tst"))' \
	| ${SCHEME}

# add the import special form
test.chap8i : src/chap8i.scm
	echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(load "src/chap7g.scm")' \
	    '(load "src/chap8h.scm")' \
	    '(load "src/chap8i.scm")' \
	    '(and (test-scheme7g "src/scheme.tst")' \
	    '     (test-scheme7g "src/chap5c.tst")' \
	    '     (test-scheme7g "src/chap7d.tst")' \
	    '     (test-scheme7g "src/chap8h.tst")' \
	    '     (test-scheme7g "src/chap8i.tst"))' \
	| ${SCHEME}

# a little reflective interpreter.
# Pay attention, this is very long and needs much much space...
long.test.chap8j :
	if ${YOU_HAVE_TIME} ; then ${MAKE} test.chap8j ; else : ; fi
big.test.chap8j : test.chap8j
test.chap8j : src/chap8h.scm si/reflisp.scm
	( echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(load "src/chap7g.scm")' \
	    '(load "src/chap8h.scm")' \
	    '(load "src/chap8j.scm")' \
	    '(call-with-input-file' \
	    '  "si/reflisp.scm"' \
	    '  (lambda (in)' \
	    '    (let ((e (read in)))' \
	    '      (call-with-output-file' \
	    '        "o/tmp.scm"' \
	    '        (lambda (out)' \
	    "          (write \`((lambda (reflisp-code) ,e) ',e) out)" \
	    '          (newline out))))))' \
	    '(compile-file "o/tmp.scm" "o/tmp.so")' \
	    '(build-application "o/a.out" "o/tmp.so")' \
	    '(display `(byte-size is ,(vector-length *code*)))' \
	    '(newline)' \
	    '(and (run-application 400 "o/a.out")' \
	    "     'done)" \
	    ; cat src/chap8j.tst ) \
	| ${SCHEME}

# a direct test of the reflective interpreter
#
# This is a known-failing test. See README.md for more info. -- appleby
test.reflisp : si/reflisp.scm src/chap8k.scm
	( echo \
	    '(load "src/chap8a.scm")' \
	    '(load "src/chap6d.scm")' \
	    '(load "src/chap7d.scm")' \
	    '(load "src/chap7h.scm")' \
	    '(load "src/chap7g.scm")' \
	    '(load "src/chap8h.scm")' \
	    '(load "src/chap8j.scm")' \
	    '(load "src/chap8k.scm")' \
	    '(begin' \
	    '  (display `(cons-size is ,(count-pairs reflisp-code)))' \
	    '  (newline))' \
	    "(and (reflisp) 'done)" \
	    ; cat src/chap8j.tst ) \
	| ${SCHEME}

##################################### Chap 9 #############################
# Chapter on macros

TEST_CHAP9 = test.chap9c

# A macro system (hygien if I want it, where I want it).
test.chap9c : src/chap9c.scm
	echo \
	    '(load "src/chap9c.scm")' \
	    '(load "src/chap9d.scm")' \
	    '(load "src/chap9e.scm")' \
	    '(and (test-scheme9d "src/scheme.tst")' \
	    '     (test-scheme9d "src/chap9c.tst"))' \
	| ${SCHEME}

##################################### Chap 10 #############################
# Chapter on compilation -> C

TEST_CHAP10 = test.chap10a test.chap10c dynext.test.chap10e test.chap10k \
	      dynext.test.chap10je test.chap10jk dynext.test.chap10n

# chap10a.scm: objectification
# chap10b.scm: small interpreter for objectified code
test.chap10a : src/chap10a.scm src/chap10b.scm
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10b.scm")' \
	    '(and (test-scheme10b "src/scheme.tst"))' \
	| ${SCHEME}

# chap10c.scm: extract and globalize quotations
# chap10d.scm: interpret the objectified code
test.chap10c : src/chap10a.scm src/chap10b.scm
test.chap10c : src/chap10c.scm src/chap10d.scm
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10b.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10d.scm")' \
	    '(and (test-scheme10b "src/scheme.tst"))' \
	| ${SCHEME}

all-o = o/${HOSTTYPE}/scheme.o o/${HOSTTYPE}/schemelib.o \
	o/${HOSTTYPE}/schemeklib.o

o/${HOSTTYPE}/scheme.o : src/c/scheme.h src/c/scheme.c
	cd o/${HOSTTYPE} ; ${CC} ${CFLAGS} -c ../../src/c/scheme.c
o/${HOSTTYPE}/schemelib.o : src/c/scheme.h src/c/schemelib.c
	cd o/${HOSTTYPE} ; ${CC} ${CFLAGS} -c ../../src/c/schemelib.c
o/${HOSTTYPE}/schemeklib.o : src/c/scheme.h src/c/schemeklib.c
	cd o/${HOSTTYPE} ; ${CC} ${CFLAGS} -c ../../src/c/schemeklib.c

# chap10e.scm: C generation
# chap10g.scm: lifting, quotation extraction.
# chap10h.scm: predefined environment
# chap10f.scm: tests on test-suites
# This test is very long... but it fails on continuations that are used
# out of their dynamic extent or multiply.
long.dynext.test.chap10e :
	if ${YOU_HAVE_TIME} ; then ${MAKE} test.chap10e ; else : ; fi
dynext.test.chap10e : test.chap10e
test.chap10e : src/chap10a.scm src/chap10c.scm
test.chap10e : src/chap10g.scm src/chap10e.scm
test.chap10e : src/chap10h.scm src/chap10f.scm
test.chap10e : o/${HOSTTYPE}/scheme.o
test.chap10e : o/${HOSTTYPE}/schemelib.o
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(and (test-scheme10e "src/chap10e.tst")' \
	    '     (test-scheme10e "src/scheme.tst"))' \
	| ${SCHEME}

# chap10m.scm contains the letify function that recursively copies
# an AST into a pure tree, trying to insert let forms.  This test is
# very long... but it fails on continuations that are used out of
# their dynamic extent or multiply.
long.dynext.test.chap10n :
	if ${YOU_HAVE_TIME} ; then ${MAKE} test.chap10n ; else : ; fi
dynext.test.chap10n : test.chap10n
test.chap10n : src/chap10a.scm src/chap10c.scm
test.chap10n : src/chap10g.scm src/chap10e.scm
test.chap10n : src/chap10h.scm src/chap10f.scm
test.chap10n : src/chap10m.scm src/chap10n.scm
test.chap10n : o/${HOSTTYPE}/scheme.o
test.chap10n : o/${HOSTTYPE}/schemelib.o
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(load "src/chap10m.scm")' \
	    '(load "src/chap10n.scm")' \
	    '(and (test-scheme10e "src/chap10e.tst")' \
	    '     (test-scheme10e "src/scheme.tst"))' \
	| ${SCHEME}

# Generate the C code corresponding to the running example of
# chapter 10. The C code will be left in o/chap10ex.c
chap10e.example : o/chap10ex.c
o/chap10ex.c : src/chap10ex.scm src/chap10e.scm
o/chap10ex.c : o/${HOSTTYPE}/scheme.o
o/chap10ex.c : o/${HOSTTYPE}/schemelib.o
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(set! *cc+cflags* "${CC} ${CFLAGS}")' \
	    '(call-with-input-file' \
	    '  "src/chap10ex.scm"' \
	    '  (lambda (in) (test-expression (read in))))' \
	| ${SCHEME}

	size o/${HOSTTYPE}/chap10e
	indent -kr o/chap10e.c -o $@

# This is the best I can to show the expanded version of the file.
# It needs to be hacked a little by hand before being inserted in
# the book.
o/chap10ex.E : o/chap10ex.c src/c/scheme.h
	${CC} ${CFLAGS} -Isrc/c -E o/chap10ex.c -o $@
	indent -kr $@

# The file bigloo/compapp.scm was not included in the source tarball
# from the author's site. One could likely re-create
# `compile-bigloo-application' and get these targets working again, if
# one so desired. -- appleby

# Compile this compiler with Bigloo
#
# I patched a little the o/${HOSTTYPE}/LiSPbookc.bgl file because of
# a bug on write on strings containing \". To be solved.
# o/${HOSTTYPE}/LiSPbookc :
# 	H_DIR=`pwd`/src/c/ ; export H_DIR ; \
# 	A_FILE=`pwd`/o/${HOSTTYPE}/rtbook.a ; export A_FILE ; \
# 	echo \
# 	'(load "bigloo/compapp.scm")' \
# 	"'(set! *verbose* #t)" \
# 	'(compile-bigloo-application' \
# 	'  "${BIGLOO}" "o/${HOSTTYPE}/" "LiSPbookc"' \
# 	" '(begin" \
# 	'    (set! *h-dir* "$$H_DIR")' \
# 	'    (set! *rtbook-library* "$$A_FILE")' \
# 	'    (compiler-entry-point command-options))' \
# 	'  "src/chap10a.scm"' \
# 	'  "src/chap10c.scm"' \
# 	'  "src/chap10g.scm"' \
# 	'  "src/chap10e.scm"' \
# 	'  "src/chap10h.scm"' \
# 	'  "src/chap10f.scm")' \
#     | ${SCHEME}
#
# The following entries do not work since the rtbook.a library is
# not sufficient: IO operations are missing.
#
# Compile the compiler with itself (stage 2)
# o/${HOSTTYPE}/LiSPbookc2 : o/${HOSTTYPE}/LiSPbookc ${TIME}
# 	o/${HOSTTYPE}/LiSPbookc o/${HOSTTYPE}/LiSPbookc.bgl -v \
# 	   -o o/${HOSTTYPE}/LiSPbookc2 -C o/${HOSTTYPE}/LiSPbookc2.c
#
# Recompile the compiler with itself (stage 3)
# o/${HOSTTYPE}/LiSPbookc3 : o/${HOSTTYPE}/LiSPbookc2
# 	${TIME} o/${HOSTTYPE}/LiSPbookc2 o/${HOSTTYPE}/LiSPbookc.bgl -v \
# 	    -o o/${HOSTTYPE}/LiSPbookc3 -C o/${HOSTTYPE}/LiSPbookc3.c
#
# LiSPbookc.compare : o/${HOSTTYPE}/LiSPbookc3
# 	ls -l o/${HOSTTYPE}/LiSPbookc*[23].c
# 	diff o/${HOSTTYPE}/LiSPbookc*[23].c | wc
# 	size o/${HOSTTYPE}/LiSPbookc*[23]

# chap10i.scm : *Untested* variants for function invokation since it
# requires a change in SCM_invoke (in scheme.c).  This test is very
# long... but it fails on continuations that are used out of their
# dynamic extent or multiply.
# long.dynext.test.chap10i :
# 	if ${YOU_HAVE_TIME} ; then ${MAKE} dynext.test.chap10i ; else : ; fi
# dynext.test.chap10i : test.chap10i
# test.chap10i : src/chap10a.scm src/chap10c.scm
# test.chap10i : src/chap10g.scm src/chap10e.scm
# test.chap10i : src/chap10h.scm src/chap10f.scm src/chap10i.scm
# test.chap10i : o/${HOSTTYPE}/scheme.o
# test.chap10i : o/${HOSTTYPE}/schemelib.o
# 	echo \
# 	    '(load "src/chap10a.scm")' \
# 	    '(load "src/chap10c.scm")' \
# 	    '(load "src/chap10g.scm")' \
# 	    '(load "src/chap10e.scm")' \
# 	    '(load "src/chap10h.scm")' \
# 	    '(load "src/chap10f.scm")' \
# 	    '(load "src/chap10i.scm")' \
# 	    '(and (test-scheme10e "src/scheme.tst")' \
# 	    '     (test-scheme10e "src/chap10e.tst"))' \
# 	| ${SCHEME}

# as for various interpreters, try our usual bench.
# Compile it and run it.
chap10e.bench : o/${HOSTTYPE}/scheme.o
chap10e.bench : o/${HOSTTYPE}/schemelib.o
chap10e.bench : src/chap5-bench.scm
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(call-with-input-file' \
	    '  "src/chap5-bench.scm"' \
	    '  (lambda (in) (test-expression (read in))))' \
	| ${SCHEME}

	${TIME} o/${HOSTTYPE}/chap10e

# Start a compiler.
# You can try (test-expression e) or (show-C-expression e).
# See file chap10f.scm for other possibilities.
start.chap10e : ${all-o}
	( echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    ; tee ) \
	| ${SCHEME}

# test indepently a compiled file o/chap10e.c.
test.chap10e.c : ${all-o} o/chap10ex.c
	cd o/${HOSTTYPE} ; \
	${CC} ${CaFLAGS} ../chap10e.c scheme.o schemelib.o -o chap10e \
	&& ./chap10e

# chap10k.scm : CPS transformation, use schemeklib.c
# Very long test but it does not fail on call/cc tests.
long.test.chap10k :
	if ${YOU_HAVE_TIME} ; then ${MAKE} test.chap10k ; else : ; fi
test.chap10k : o/${HOSTTYPE}/scheme.o
test.chap10k : o/${HOSTTYPE}/schemeklib.o
test.chap10k : src/chap10k.scm
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(load "src/chap10k.scm")' \
	    '(load "src/chap10m.scm")' \
	    '(and (test-scheme10k "src/scheme.tst")' \
	    '     (test-scheme10k "src/chap10k.tst")' \
	    '     (test-scheme10k "src/chap10e.tst"))' \
	| ${SCHEME}

# as for various interpreters, try our usual bench.
chap10k.bench : o/${HOSTTYPE}/scheme.o
chap10k.bench : o/${HOSTTYPE}/schemeklib.o
chap10k.bench : src/chap5-bench.scm
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(load "src/chap10k.scm")' \
	    '(load "src/chap10m.scm")' \
	    '(set! *a.out* "chap10k")' \
	    '(call-with-input-file' \
	    '  "src/chap5-bench.scm"' \
	    '  (lambda (in) (test-expression (read in))))' \
	| ${SCHEME}

	${TIME} o/${HOSTTYPE}/chap10k

# Generate the C code corresponding to the running example of
# chapter 10.  The C code will be left in o/chap10kex.c
chap10k.example : o/chap10kex.c
o/chap10kex.c : src/chap10ex.scm src/chap10e.scm
o/chap10kex.c : o/${HOSTTYPE}/scheme.o
o/chap10kex.c : o/${HOSTTYPE}/schemelib.o
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(load "src/chap10k.scm")' \
	    '(load "src/chap10m.scm")' \
	    '(set! *cc+cflags* "${CC} ${CFLAGS}")' \
	    '(call-with-input-file' \
	    '  "src/chap10ex.scm"' \
	    '  (lambda (in) (test-expression (read in))))' \
	| ${SCHEME}

	size o/${HOSTTYPE}/chap10e
	indent -kr o/chap10e.c -o $@

# chap10j.scm contains an initialization analysis. It can be grafted
# to chap10e or chap10k without differences. As the others, it is
# very long.

# This test fails on continuations used out of their dynamic extent.
long.dynext.test.chap10je :
	if ${YOU_HAVE_TIME} ; then ${MAKE} dynext.test.chap10je ; else : ; fi
dynext.test.chap10je : test.chap10je
test.chap10je : src/chap10j.scm
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(load "src/chap10j.scm")' \
	    '(and (test-scheme10e "src/scheme.tst")' \
	    '     (test-scheme10e "src/chap10e.tst")' \
	    '     (test-scheme10e "src/chap10j.tst"))' \
	| ${SCHEME}

# This one does not fail but lasts long...
long.test.chap10jk :
	if ${YOU_HAVE_TIME} ; then ${MAKE} test.chap10jk ; else : ; fi
test.chap10jk : src/chap10j.scm src/chap10p.scm
	echo \
	    '(load "src/chap10a.scm")' \
	    '(load "src/chap10c.scm")' \
	    '(load "src/chap10g.scm")' \
	    '(load "src/chap10e.scm")' \
	    '(load "src/chap10h.scm")' \
	    '(load "src/chap10f.scm")' \
	    '(load "src/chap10k.scm")' \
	    '(load "src/chap10m.scm")' \
	    '(load "src/chap10j.scm")' \
	    '(load "src/chap10p.scm")' \
	    '(and (test-scheme10k "src/scheme.tst")' \
	    '     (test-scheme10k "src/chap10e.tst")' \
	    '     (test-scheme10k "src/chap10k.tst")' \
	    '     (test-scheme10k "src/chap10j.tst"))' \
	| ${SCHEME}

# Compare time between o/$HOSTTYPE/c10ex and c10kex
# They have been modified from o/chap10[k]ex.c to repeat the
# computation 10000 times so their duration can be better estimated.
# Pay attention to the precise timing command.
compare.chap10 : o/${HOSTTYPE}/c10ex o/${HOSTTYPE}/c10kex
compare.chap10 :
	${TIME} o/${HOSTTYPE}/c10ex
	${TIME} o/${HOSTTYPE}/c10kex

bCFLAGS = -I../../src/c -ansi -pedantic -O

c10ex-deps = src/c/c10ex.c o/${HOSTTYPE}/scheme.o o/${HOSTTYPE}/schemelib.o
o/${HOSTTYPE}/c10ex : ${c10ex-deps}
	${CC} ${bCFLAGS} -o $@ ${c10ex-deps}

c10kex-deps = src/c/c10ex.c o/${HOSTTYPE}/scheme.o o/${HOSTTYPE}/schemeklib.o
o/${HOSTTYPE}/c10kex : ${c10kex-deps}
	${CC} ${bCFLAGS} -o $@ ${c10kex-deps}

######################################################### Common entries

# Clean or recursively clean directories.
clean.all.but.failures ::
	-find o/* -maxdepth 0 \! -path ${FAILURES} -exec rm -rf '{}' \;

clean ::
	-rm -rf o/*

# Create tags for editing sources with Gnu Emacs.
tags : 
	etags */?*.scm
