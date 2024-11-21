//
// Created by Keijo Länsikunnas on 2.5.2024.
//
#include <stdio.h>
#include "hw.h"
#include "readchar.h"

bool read_character(int *ch)
{
    static const int sequence[] = {
            -1,
            -1,
            -1,
            '+',
            '+',
            '+',
            -1,
            -1,
            -1,
            0 };
    static int state = 0;
    int c = getchar_wait_us(500000);
    *ch = c;
    if(c == sequence[state]) {
        ++state;
        if(sequence[state] == 0) {
            state = 0;
            return true;
        }
        //printf("S:%d\n", state);
    }
    else if(c != -1 || state != 3) {
        //if(state) printf("S-->0\n");
        state = 0;
    }

    return false;
}
