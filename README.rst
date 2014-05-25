Dumphole for fast XML processors
================================

::

    Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz

Goal: parse ``publicfeed.huge.xml`` (~1 GB) as quickly as possible. Output all
``Products/Product/ProductUrl`` strings separated by newline.

Existing implementations:

1. XSLT via XALAN. OOM.
2. XSLT via xsltproc. OOM.
3. Custom parser (get_producturl.py) via ``pypy 2.2.1``.
4. Custom parser (get_producturl.py) via ``rpython 2.2.1``.
5. Naïve ``hexpat 0.20.6 (GHC 7.6.3)``.
6. ``Expat 2.1.0`` streaming parser, ``gcc: 4.8.2``.
7. ``lxml 3.3.5`` in ``pypy 2.2.1`` (leaks lots of memory).
8. ``lxml 3.3.5`` in ``CPython 3.3.5`` (leaks lots of memory).
9. xml.etree.ElementTree in ``CPython 3.3.5`` and ``pypy 2.2.1``.
10. ``xml.parsers.expat`` via ``CPython 3.3.5``.
11. ``expat`` in ``luajit 2.0.3`` and ``lua 5.2.3``.
12. ``encoding/xml`` in ``go 1.2.1``.

To be evaluated:

* rewrite of ``get_producturl.py`` in C.
* add JIT to ``get_producturl.py`` RPython.

Rules:

1. Streaming (for constant memory usage) for all implementations.
2. Warm filesystem cache (i.e. do it more than once).
3. Single-threaded. We are interested only about serial performance.
4. If you make your own parser, don't try to make it correct. Make it work.

Results
=======

================ ================== ============ ===== =====
What             i7-4500 1.8Mhz (s) Heap (MB)    MB/s  wc -l
================ ================== ============ ===== =====
Expat (C)        7.05               0.6          144.9 65
Custom (RPython) 8                  19.7         127.7 69
Custom (Rust)    12s (?)            1mb (?)      ~83   77
LXML (Python3)   13.4               **5573**     76.2  26
Expat (luajit)   14.4               1.8          70.9  29
Expat (lua5.2)   16.5               1.7          61.9  29
Expat (Python3)  20.8               6.7          49.1  38
Etree (Python3)  23.3               68.3         43.8  29
LXML (PyPy)      27.3               **5587**     37.4  26
Custom (PyPy)    32.4               35.1         31.5  69
Etree (PyPy)     35.0               5.1          29.1  29
Hexpat (Haskell) 36.5               36.5         28.0  18
std (Go)         68.3               1.7          14.9  43
================ ================== ============ ===== =====

Compile rpython application
===========================

::

  /path/to/pypy/rpython/bin/rpython ./get_producturl.py

See `tutorial`_ for more info.

.. _tutorial: http://morepypy.blogspot.nl/2011/04/tutorial-writing-interpreter-with-pypy.html

Haskell
=======

::

    cabal install hexpat
    make hexpat

Rust
====

::

    make rust

Benches were run on an i5 (TODO, re-run with i7) with

::

    $ rustc --version
    rustc 0.11.0-pre-nightly (4605232 2014-05-21 01:11:25 -0700)
