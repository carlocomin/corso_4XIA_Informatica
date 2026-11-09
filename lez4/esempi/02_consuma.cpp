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

    bool consuma(int quantita) {
        if (quantita <= 0 || quantita > livello) {
            return false;
        }
        livello = livello - quantita;
        return true;
    }
};

int main() {
    Batteria b;
    b.caricaCompleta();

    bool esito = b.consuma(60);
    cout << esito << " " << b.leggiLivello() << "\n";
    esito = b.consuma(70);
    cout << esito << " " << b.leggiLivello() << "\n";
    return 0;
}
