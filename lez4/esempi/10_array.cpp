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
    const int N = 3;
    Batteria robot[N];
    robot[0].ricarica(40);
    robot[1].ricarica(70);
    robot[2].ricarica(10);

    int scariche = 0;
    for (int i = 0; i < N; i++) {
        cout << robot[i].leggiLivello() << "\n";
        if (robot[i].leggiLivello() < 20) {
            scariche = scariche + 1;
        }
    }
    cout << "Sotto il 20%: " << scariche << "\n";
    return 0;
}
