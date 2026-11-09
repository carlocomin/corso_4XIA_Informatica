#include <iostream>

using namespace std;

class Batteria {
private:
    int livello;

public:
    Batteria() {
        livello = 0;
    }

    int leggiLivello() {
        return livello;
    }

    void caricaCompleta() {
        livello = 100;
    }

    bool consuma(int quantita) {
        if (quantita <= 0 || quantita > livello) {
            return false;
        }
        livello = livello - quantita;
        return true;
    }

    bool ricarica(int quantita) {
        if (quantita <= 0 || quantita > 100 - livello) {
            return false;
        }
        livello = livello + quantita;
        return true;
    }
};

int main() {
    Batteria b1;
    Batteria b2;
    cout << b1.leggiLivello() << "\n";
    cout << b2.leggiLivello() << "\n";
    return 0;
}
