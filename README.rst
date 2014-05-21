Dumphole for fast XML processors
================================

::

    Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz

Goal: parse ``publicfeed.huge.xml`` (~1 GB) as quickly as possible. Output all
``Products/Product/ProductUrl`` strings separated by newline.

Existing implementations:

1. XSLT via XALAN. OOM.
2. XSLT via xsltproc. OOM.
3. Custom parser (get_producturl.py) via pypy: 26.5s.
4. Custom parser (get_producturl.py) via rpython: 8.2
5. Naïve hexpat (Haskell): 50s (benched on an i5 though)

To be evaluated:

* rewrite of ``get_producturl.py`` in C.
* C + expat
* LXML in CPython.
* xml.etree.ElementTree in PyPy.
* xml.etree.cElementTree in CPython.
* add JIT to ``get_producturl.py`` rpython.

Rules:

1. Streaming (for constant memory usage) for all implementations.
2. Warm filesystem cache (i.e. do it more than once).
3. Single-threaded. We are interested only about serial performance.
4. If you make your own parser, don't try to make it correct. Make it work.

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
    ghc -O3 get_producturl.hs
