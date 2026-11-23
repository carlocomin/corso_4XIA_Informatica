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

class Missione {
private:
    const Robot* assegnato = nullptr;

public:
    bool assegna(Robot& robot) {
        if (assegnato != nullptr) {
            return false;
        }
        assegnato = &robot;
        return true;
    }

    void annullaAssegnazione() {
        assegnato = nullptr;
    }

    const Robot* leggiAssegnato() const {
        return assegnato;
    }
};

int main() {
    Robot r1(101);
    Robot r2(102);
    Missione m;
    cout << m.assegna(r1) << '\n';
    cout << m.assegna(r2) << '\n';
    const Robot* robot = m.leggiAssegnato();
    if (robot != nullptr) {
        cout << robot->leggiCodice() << '\n';
    }

    m.annullaAssegnazione();
    cout << (m.leggiAssegnato() == nullptr) << '\n';
    return 0;
}
