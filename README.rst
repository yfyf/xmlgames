Dumphole for fast XML processors
================================

::
  Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz

Goal: parse ``publicfeed.huge.xml`` (~1 GB) as quickly as possible. Output all
``Products/Product/ProductUrl`` strings separated by newline.

Existing implementations:

1. XSLT via XALAN. OOM.
2. XSLT via xsltproc. OOM.
3. Custom parser (get_producturl.py) via pypy: 26s.
4. Custom parser (get_producturl.py) via rpython: 9.5s.

To be evaluated:

* expat (or hexpat)
* Python via LXML
* xml.etree in PyPy
* add JIT to ``get_producturl.py`` rpython.

Rules:

1. Read to memory before processing.
2. Warm filesystem cache (i.e. do it more than once).
3. Single-threaded. We are interested only about serial performance.

Compile rpython application
===========================

::
  /path/to/pypy/rpython/bin/rpython ./get_producturl.py

See `tutorial`_ for more info.

.. _tutorial: http://morepypy.blogspot.nl/2011/04/tutorial-writing-interpreter-with-pypy.html
