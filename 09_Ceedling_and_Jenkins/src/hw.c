#include "hw.h"
#include "pico/stdlib.h"
#include "hardware/watchdog.h"

void write_wds(unsigned int snumber, uint32_t value)
{
    if(snumber >= 4) return;
    watchdog_hw->scratch[snumber] = value;
}

uint32_t read_wds(unsigned int snumber)
{
    if(snumber >= 4) return 0;
    return watchdog_hw->scratch[snumber];
}

void reboot(void)
{
    watchdog_reboot(0, 0, 0);
}

int getchar_wait_us(uint32_t timeout_us)
{
    return getchar_timeout_us(timeout_us);
}