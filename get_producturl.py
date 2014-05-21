import os
import sys


class STATE:
    READING_TAG_OPEN = 0
    READING_TAG_CLOSE = 1
    READING_STUFF = 2


def got_stuff(tree, stuff):
    if tree and tree[-1] == 'ProductUrl':
        print (stuff)


def get_producturls(s):
    i, tree, elem, state = 0, [], [], STATE.READING_STUFF

    while i < len(s):
        if state == STATE.READING_STUFF:
            if s[i] == '<':
                got_stuff(tree, "".join(elem))
                elem = []
                if s[i+1] == '/':
                    state = STATE.READING_TAG_CLOSE
                else:
                    state = STATE.READING_TAG_OPEN
            else:
                elem.append(s[i])
        elif state == STATE.READING_TAG_OPEN:
            if s[i] == '>':
                tree.append("".join(elem))
                elem = []
                state = STATE.READING_STUFF
            elif s[i] == '/' and s[i+1] == '>':
                # skip empty stuff
                state = STATE.READING_STUFF
                i += 1
            else:
                elem.append(s[i])
        elif state == STATE.READING_TAG_CLOSE:
            if s[i] == '>':
                tree.pop()
                state = STATE.READING_STUFF
        i += 1


def entry_point(argv):
    if len(argv) != 2:
        print ("Usage: %s <file>" % argv[0])
        return 1

    f = open(argv[1], 'r')
    s = f.read()
    f.close()

    get_producturls(s)
    return 0


def target(*args):
    return entry_point, None


if __name__ == '__main__':
    entry_point(sys.argv)
