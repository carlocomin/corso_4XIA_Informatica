#include <iostream>

using namespace std;

int main() {
    int dato = 40;
    int* p = &dato;
    int* q = p;

    *q = 30;
    cout << dato << " " << *p << " " << *q << "\n";
    return 0;
}
