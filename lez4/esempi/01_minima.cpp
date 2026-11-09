#include <iostream>

using namespace std;

class Batteria {
private:
    int livello = 0;

public:
    int leggiLivello() {
        return livello;
    }

    void caricaCompleta() {
        livello = 100;
    }
};

int main() {
    Batteria b1;
    Batteria b2;
    b1.caricaCompleta();
    cout << b1.leggiLivello() << "\n";
    cout << b2.leggiLivello() << "\n";
    return 0;
}
