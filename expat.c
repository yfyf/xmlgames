#include <stdio.h>
#include <string.h>
#include "expat.h"

#define PRODUCT_URL "ProductUrl"
#define SIZE        4096*10

static void XMLCALL startElement(void *state, const char *name,
                                 const char **attr)
{
    if (!strcmp(name, PRODUCT_URL)) {
        *((int *)state) = 1;
    }
}

static void XMLCALL parseText(void *state, const XML_Char *str, int len) {
    int *tmp = (int *)state;

    if (*tmp && len > 1) {
        printf("%.*s\n", len, str);
        *tmp = 0;
    }
}

static void XMLCALL endElement(void *state, const char *name)
{
    // do nothing
}

int main(int argc, char *argv[])
{
    FILE *fp;
    char buf[SIZE];
    XML_Parser parser   = XML_ParserCreate(NULL);
    int done            = 0;
    int state           = 0;

    if (argc == 1) {
        printf("Usage: %s <file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    fp = fopen(argv[1], "r");
    if (!fp) {
        fprintf(stderr, "error while opening file: %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    XML_SetUserData(parser, &state);
    XML_SetElementHandler(parser, startElement, endElement);
    XML_SetCharacterDataHandler(parser, parseText);

    while (!done) {
        int len = (int)fread(buf, 1, sizeof(buf), fp);
        done = len < sizeof(buf);
        if (XML_Parse(parser, buf, len, done) == XML_STATUS_ERROR) {
            fprintf(stderr, "error while parsing XML\n");
            return EXIT_FAILURE;
        }
    }

    XML_ParserFree(parser);
    fclose(fp);
    return 0;
}
