#include <iostream>

using namespace std;

class Batteria {
private:
    int livello;

public:
    Batteria() {
        livello = 0;
    }

    Batteria(int iniziale) {
        livello = 0;
        if (iniziale >= 0 && iniziale <= 100) {
            livello = iniziale;
        }
    }

    int leggiLivello() const {
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
    Batteria originale(40);
    Batteria copia = originale;
    copia.consuma(10);
    cout << originale.leggiLivello() << " ";
    cout << copia.leggiLivello() << "\n";

    Batteria altra;
    altra = originale;
    altra.consuma(5);
    cout << originale.leggiLivello() << " ";
    cout << altra.leggiLivello() << "\n";
    return 0;
}
