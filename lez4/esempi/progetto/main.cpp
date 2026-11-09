#include <iostream>
#include "Batteria.h"

using namespace std;

int main() {
    Batteria b(40);
    if (b.consuma(10)) {
        cout << "Consumo eseguito\n";
    }
    cout << b.leggiLivello() << "\n";
    return 0;
}
