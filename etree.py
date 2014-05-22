import sys

try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

def get_producturls(f):
    parser = ET.iterparse(f, events=('end',))

    for event, element in parser:
        if event == 'end' and element.tag == 'ProductUrl':
            print (element.text)
        element.clear()


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
