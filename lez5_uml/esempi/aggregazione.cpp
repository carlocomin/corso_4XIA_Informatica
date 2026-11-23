#include <iostream>

using namespace std;

class Robot {
private:
    int codice;

public:
    Robot(int codiceIniziale) : codice(codiceIniziale) {}

    int leggiCodice() const {
        return codice;
    }
};

class Gruppo {
private:
    static constexpr int CAPACITA = 2;
    const Robot* membri[CAPACITA]{};
    int quanti = 0;

public:
    bool aggiungi(Robot& robot) {
        if (quanti == CAPACITA) {
            return false;
        }
        for (int i = 0; i < quanti; i++) {
            if (membri[i] == &robot) {
                return false;
            }
        }
        membri[quanti] = &robot;
        quanti++;
        return true;
    }

    int numeroMembri() const {
        return quanti;
    }
};

int main() {
    Robot r1(101);
    Robot r2(102);
    Robot r3(103);
    {
        Gruppo collaudo;
        Gruppo consegne;
        cout << collaudo.aggiungi(r1) << '\n';
        cout << consegne.aggiungi(r1) << '\n';
        cout << collaudo.aggiungi(r1) << '\n';
        cout << collaudo.aggiungi(r2) << '\n';
        cout << collaudo.aggiungi(r3) << '\n';
        cout << collaudo.numeroMembri() << '\n';
    }

    cout << r1.leggiCodice() << '\n';
    return 0;
}
