#include <iostream>
#include <string>

using namespace std;

class Libro {
private:
    string titolo;
    bool inPrestito;

public:
    // In questo esercizio il chiamante fornisce un titolo non vuoto.
    Libro(string titoloIniziale) {
        titolo = titoloIniziale;
        inPrestito = false;
    }

    string leggiTitolo() const {
        return titolo;
    }

    bool eInPrestito() const {
        return inPrestito;
    }

    bool presta() {
        if (inPrestito) {
            return false;
        }
        inPrestito = true;
        return true;
    }

    bool restituisci() {
        if (!inPrestito) {
            return false;
        }
        inPrestito = false;
        return true;
    }
};

int main() {
    Libro libro("Il piccolo principe");
    cout << libro.leggiTitolo() << "\n";
    cout << libro.presta() << "\n";
    cout << libro.presta() << "\n";
    cout << libro.eInPrestito() << "\n";
    cout << libro.restituisci() << "\n";
    cout << libro.restituisci() << "\n";
    cout << libro.eInPrestito() << "\n";
    return 0;
}
