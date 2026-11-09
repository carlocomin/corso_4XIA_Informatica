#include <iostream>

using namespace std;

class Batteria {
private:
    int livello;

public:
    Batteria();
    Batteria(int iniziale);
    int leggiLivello() const;
    void caricaCompleta();
    bool consuma(int quantita);
    bool ricarica(int quantita);
};

Batteria::Batteria() {
    livello = 0;
}

Batteria::Batteria(int iniziale) {
    livello = 0;
    if (iniziale >= 0 && iniziale <= 100) {
        livello = iniziale;
    }
}

int Batteria::leggiLivello() const {
    return livello;
}

void Batteria::caricaCompleta() {
    livello = 100;
}

bool Batteria::consuma(int quantita) {
    if (quantita <= 0 || quantita > livello) {
        return false;
    }
    livello = livello - quantita;
    return true;
}

bool Batteria::ricarica(int quantita) {
    if (quantita <= 0 || quantita > 100 - livello) {
        return false;
    }
    livello = livello + quantita;
    return true;
}

int main() {
    Batteria b(40);
    b.consuma(10);
    cout << b.leggiLivello() << "\n";
    return 0;
}
