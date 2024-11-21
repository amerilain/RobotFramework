#include <stdint.h>
void write_wds(unsigned int snumber, uint32_t value);
uint32_t read_wds(unsigned int snumber);
void reboot(void);
int getchar_wait_us(uint32_t timeout_us);