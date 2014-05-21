import os
import sys


class STATE:
    READING_TAG_OPEN = 0
    READING_TAG_JUST_OPEN = 1
    READING_TAG_CLOSE = 2
    READING_STUFF = 3


def got_stuff(tree, stuff):
    if tree and tree[-1] == 'ProductUrl':
        print (stuff)


def get_producturls(f):
    tree, elem, state = [], [], STATE.READING_STUFF

    bu = 'tmp'
    while bu != '':
        bu = f.read(4096)
        for c in bu:
            if state == STATE.READING_STUFF:
                if c == '<':
                    got_stuff(tree, "".join(elem))
                    elem = []
                    state = STATE.READING_TAG_JUST_OPEN
                else:
                    elem.append(c)
            elif state == STATE.READING_TAG_JUST_OPEN:
                if c == '/':
                    state = STATE.READING_TAG_CLOSE
                else:
                    elem.append(c)
                    state = STATE.READING_TAG_OPEN
            elif state == STATE.READING_TAG_OPEN:
                if c == '>':
                    tree.append("".join(elem))
                    elem = []
                    state = STATE.READING_STUFF
                elif c == '/':
                    # skip empty stuff
                    state = STATE.READING_STUFF
                else:
                    elem.append(c)
            elif state == STATE.READING_TAG_CLOSE:
                if c == '>':
                    tree.pop()
                    state = STATE.READING_STUFF


def entry_point(argv):
    if len(argv) != 2:
        print ("Usage: %s <file>" % argv[0])
        return 1

    f = open(argv[1], 'r')
    get_producturls(f)
    f.close()
    return 0


def target(*args):
    return entry_point, None


if __name__ == '__main__':
    entry_point(sys.argv)
