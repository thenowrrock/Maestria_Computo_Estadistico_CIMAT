#include <iostream>

using namespace std;

int main(){
	int i=5;
	switch(i){
		case 1 :
			cout << "El valor de i es 1" << endl;
			break;
		case 2 :
			cout << "El valor de i es 2" << endl;
			break;
		case 5 : 
			cout << "El valor de i es 5" << endl;
			break;
		case 6 :
			cout << "El valor de i es 6" << endl;
			break;
		default :
			cout << "No se cumplio ningun caso" << endl;
			break;
	}

	if(i==1)
		cout << "El valor es 1" << endl;
	else if (i==2)
		cout << "El valor es 2" << endl;
	else if(i==5)
		cout << "El valor es 5" << endl;
	else if (i==6)
		cout << "El valor es 6" << endl;
	else{
		cout << "No se cumplio ningun caso" << endl;
	}

	return 0;
}
