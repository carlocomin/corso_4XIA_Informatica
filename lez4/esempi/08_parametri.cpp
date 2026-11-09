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

void provaValore(Batteria b) {
    b.consuma(10);
}

void provaRiferimento(Batteria& b) {
    b.consuma(10);
}

void mostra(const Batteria& b) {
    cout << b.leggiLivello() << "\n";
}

int main() {
    Batteria originale(40);
    provaValore(originale);
    mostra(originale);
    provaRiferimento(originale);
    mostra(originale);

    Batteria& alias = originale;
    alias.consuma(5);
    mostra(originale);
    return 0;
}
