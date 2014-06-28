import os
import sys

from lxml import etree

def get_producturls(f):
    context = etree.iterparse(f, events=('end',))
    query1 = etree.XPath("string(concat('wap: ', ProductUrl))", smart_strings=False)
    query2 = etree.XPath("string(ProductUrl)", smart_strings=False)
    for _, element in context:
        if element.tag=='Product':
            print (query1(element))
            print (query2(element))
            element.clear()
            while element.getprevious() is not None:
                del element.getparent()[0]


def entry_point(argv):
    if len(argv) != 2:
        print ("Usage: %s <file>" % argv[0])
        return 1

    f = open(argv[1], 'rb')
    get_producturls(f)
    f.close()
    return 0


if __name__ == '__main__':
    entry_point(sys.argv)
