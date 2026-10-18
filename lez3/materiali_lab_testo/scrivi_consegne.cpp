#include <fstream>
#include <iostream>

using namespace std;

int main() {
    ofstream out("consegne.txt");
    if (!out) {
        cerr << "Impossibile aprire consegne.txt in scrittura\n";
        return 1;
    }

    out << "ingresso" << ' ' << 3 << ' ';
    // TODO: aggiungi le altre quattro coppie, nello stesso ordine.

    out.close();
    if (!out) {
        cerr << "Errore durante la scrittura o la chiusura\n";
        return 2;
    }
    cout << "File consegne.txt scritto\n";
}
