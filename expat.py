import sys
import xml.parsers.expat

state = 0

def start_element(name, attrs):
    global state
    if name == 'ProductUrl':
        state = 1


def char_data(data):
    global state
    if state == 1:
        print (data)
        state = 0


def get_producturls(f):
    p = xml.parsers.expat.ParserCreate()
    p.StartElementHandler = start_element
    p.CharacterDataHandler = char_data
    p.ParseFile(f)


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
