#include <iostream>

using namespace std;

class Batteria {
private:
    int livello = 0;

public:
    void caricaCompleta() {
        livello = 100;
    }

    int leggiLivello() const {
        return livello;
    }
};

class Robot {
private:
    Batteria batteria;

public:
    void caricaCompleta() {
        batteria.caricaCompleta();
    }

    int leggiCarica() const {
        return batteria.leggiLivello();
    }
};

int main() {
    Robot r1;
    Robot r2;
    r1.caricaCompleta();

    cout << r1.leggiCarica() << '\n';
    cout << r2.leggiCarica() << '\n';
    return 0;
}
