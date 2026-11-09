#include "Batteria.h"

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
