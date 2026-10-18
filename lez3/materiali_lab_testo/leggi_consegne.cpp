#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int main() {
    ifstream in("consegne.txt");
    if (!in) {
        cerr << "Impossibile aprire consegne.txt in lettura\n";
        return 1;
    }

    // Prima prova: leggiamo una sola coppia.
    string destinazione;
    int pacchi = 0;
    if (!(in >> destinazione >> pacchi)) {
        cerr << "Prima coppia mancante o non leggibile\n";
        return 2;
    }
    cout << destinazione << ": " << pacchi << " pacchi\n";

    // Fase 3: sostituisci la lettura singola con un ciclo.
    // Fase 4: aggiungi conteggio, totale e riepilogo su file.
}
