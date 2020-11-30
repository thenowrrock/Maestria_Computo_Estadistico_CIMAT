#include<iostream>

using namespace std;

int main(int argc, char* argv[]){
	double a= atof(argv[1]), b= atof(argv[2]),c, r=1;
	int x=1,y=2;

	 //r += a; //r=r+a;
	 //cout << r << endl;
	 //r -= a; //r=r-a
	 //cout << r << endl;
	 //r *= a; //r=r*a;
	 //cout << r << endl;
	 //r /= a; //r=r/a;
	 //cout << r << endl;
	 //x %= y; // x=x%y
	 //y %= x; //y = y%x;
	// cout << x << endl;

	c = (a>b) ? a : b; //Máximo entre dos números
	cout << c << endl;
	 return 0;
}

