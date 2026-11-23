#include <iostream>

using namespace std;

class Batteria {
private:
    int livello;

public:
    Batteria() {
        livello = 0;
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

    int leggiLivello() const {
        return livello;
    }
};

int main() {
    Batteria b;
    b.caricaCompleta();
    if (b.consuma(30)) {
        cout << "Consumo eseguito\n";
    }
    cout << b.leggiLivello() << "\n";
    return 0;
}
