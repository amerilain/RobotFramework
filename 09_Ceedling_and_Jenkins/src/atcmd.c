#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include "pico/stdlib.h"
#include "echo.h"
#include "readchar.h"

#define LINE_SIZE  256

bool online = false;

char convert(char c)
{
    return isalnum((int)c) ? toupper((int)c) : (isspace((int)c) ? ' ' : 'X');
}


void parse_cmd(char *cmd);

void process_char(int ch);

int main() {

    // Initialize chosen serial port
    stdio_init_all();
    //stdio_set_translate_crlf(&stdio_usb, false); // disable cr-lf translation
    //printf("Boot\n");

    while(true){
        int ch = PICO_ERROR_TIMEOUT;
        bool escape = read_character(&ch);
        if(ch != PICO_ERROR_TIMEOUT) {
            if(online) {
                putchar(convert(ch));
            }
            else {
                if (get_local_echo()) putchar(ch);
                //printf("%02X ",ch);
                process_char(ch);
            }
        }
        else {
            if(escape && online) {
                online = false;
                printf("\nOK\n");
            }
        }
    }
}

void process_char(int ch) {
    static char rcv[LINE_SIZE];
    static int pos = 0;
    if(ch == '\r' || ch == '\n') {
        // crude command parser
        if(strlen(rcv) > 0) {
            //printf("\n[%s]\n",rcv);
            parse_cmd(rcv);
        }
        // clear
        rcv[0] = '\0';
        pos = 0;
    }
    else {
        if(ch == 127) { /* backspace handling */
            if(pos > 0) {
                --pos;
            }
        }
        else {
            //if(isspace(ch)) ch = ' '; // convert all white space to spaces
            rcv[pos++] = ch;
            if(pos >= LINE_SIZE) --pos;
        }
        rcv[pos] = '\0';
    }
}


void parse_cmd(char *cmd) {
    if(strncmp(cmd, "AT", 2) == 0 || strncmp(cmd, "at", 2) == 0) {
        char *par = cmd + 2;
        int echo = 0;
        switch(par[0]) {
            case 0:
                printf("OK\n");
                break;
            case 'E':
            case 'e':
                if(sscanf(par+1, "%d", &echo)==1) {
                    set_local_echo((bool) echo);
                    printf("OK\n");
                }
                else if(par[1] == '\0') {
                    printf("%s\nOK\n", get_local_echo() ? "ON" : "OFF");
                }
                else {
                    printf("INVALID\n");
                }
                break;
            case 'O':
            case 'o':
                if(par[1] == '\0') {
                    online = true;                }
                else {
                    printf("INVALID\n");
                }
                break;
            default:
                if(strncmp("+SEND=\"", par, 7) == 0 && strchr(par + 7, '\"') != NULL) {
                    par += 7;
                    printf("SENT=\"");
                    for(int i = 0; par[i] != '\0' && par[i] != '\"'; ++i) {
                        putchar(convert(par[i]));
                    }
                    printf("\"\nOK\n");
                }
                else {
                    printf("INVALID\n");
                }
                break;
        }
    }
    else {
        printf("ERROR\n");
    }
}
