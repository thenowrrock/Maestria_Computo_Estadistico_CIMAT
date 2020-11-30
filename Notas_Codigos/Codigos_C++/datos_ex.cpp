#include <iostream>
#define PI 3.14159

using namespace std;

void foo(){
	static int count = 0;
	const double pi =3.1415;
	cout << count++ <<endl;
	cout << pi << endl;
	cout << pi*count*count << endl;
}

int main(){
	
	for(int i=0; i<5; i++){
		foo();
	}
	cout << "La constante PI es: " << PI << endl;
	return 0;
}
