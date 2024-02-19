#include <system.h>
#include <stdio.h>
#include "sys/alt_timestamp.h"

int main()
{
	printf("Power3 Custom Instruction Slave\n");

	int a;
	a = 6;

  int resultSw, resultHw;

  alt_u32 swTimeA, swTimeB;
  alt_u32 hwTimeA, hwTimeB;

  swTimeA = alt_timestamp();
	resultSw = a * a * a;
  swTimeB = alt_timestamp();
	printf("Multiplication result: %d\n", resultSw);
  printf("SW time = %.2lu ms\n", 1000*((unsigned long)(swTimeA-swTimeB))/((unsigned long)alt_timestamp_freq()));

	hwTimeA = alt_timestamp();
  resultHw = ALT_CI_POWER3_0(a);
  hwTimeB = alt_timestamp();
	printf("Multiplication result from custom instr: %d\n", resultHw);
  printf("HW time = %.2lu ms\n", 1000*((unsigned long)(hwTimeA-hwTimeB))/((unsigned long)alt_timestamp_freq()));

	return 0;
}
