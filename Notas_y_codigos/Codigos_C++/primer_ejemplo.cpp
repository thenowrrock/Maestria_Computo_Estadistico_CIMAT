/* floor example */
#include <stdio.h>      /* printf */
#include <math.h>       /* floor */
using namespace std; 

int main ()
{
  double x=2.3;
  printf ( "floor of 2.3 is %.1lf\n", floor (x) );
  printf ( "floor of 3.8 is %.1lf\n", floor (3.8) );
  printf ( "floor of -2.3 is %.1lf\n", floor (-2.3) );
  printf ( "floor of -3.8 is %.1lf\n", floor (-3.8) );
  return 0;
}