#include <alt_types.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/alt_alarm.h>
#include <sys/alt_stdio.h>
#include <sys/times.h>
#include <system.h>
#include <unistd.h>
#include <math.h>

// Test case 1.
#define step 5
#define N 52

// Test case 2.
// #define step 1/8.0
// #define N 2041

// Test case 3.
//#define step 1/1024.0
//#define N 261121

// Generate the vector x and store it in the memory.
void generateVector(float x[N]) {
  int i;
  x[0] = 0;
  for (i = 1; i < N; i++)
    x[i] = x[i - 1] + step;
}

float sumVector(float x[], int M) {
	float result = 0.0;
	for (int i = 0; i < M; i++) {
		result += 0.5 * x[i] + (x[i] * x[i] * cos((x[i] - 128) / 128));
	}
	return result;
}

int main() {
  printf("Task 2!\n");

  // Define input vector.
  float x[N];

  // Returned result.
  float y;

  generateVector(x);

  char buf[50];
  clock_t exec_t1, exec_t2;
  // Get system time before starting the process.
  exec_t1 = times(NULL);

  y = sumVector(x, N);

  // Get system time after finishing the process.
  exec_t2 = times(NULL);
  gcvt((exec_t2 - exec_t1), 10, buf);

  alt_putstr(" proc time = ");
  alt_putstr(buf);
  alt_putstr(" ticks\n");

  int i;
  for (i = 0; i < 10; i++) {
    y = y / 2.0;
  }

  gcvt(((int)y), 10, buf);
  alt_putstr(" Result (divided by 1024) = ");
  alt_putstr(buf);

  // NOTE: printf could be used if there was enough memory.

  return 0;
}
