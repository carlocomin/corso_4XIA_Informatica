#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

using namespace std;

const int MAX = 30;

struct Studente {
    int matricola;
    string nome;
    int anno;
};

bool studenteValido(const Studente& s) {
    if (s.matricola <= 0 || s.anno < 1 || s.anno > 5) {
        return false;
    }
    if (s.nome.empty()) {
        return false;
    }
    if (s.nome[0] == ' ' || s.nome[s.nome.length() - 1] == ' ') {
        return false;
    }
    if (s.nome.find_first_of(";\"\t\r\n\v\f") != string::npos) {
        return false;
    }
    return s.nome.find('\0') == string::npos;
}

int cercaStudente(const Studente archivio[], int n, int matricola) {
    for (int i = 0; i < n; i++) {
        if (archivio[i].matricola == matricola) {
            return i;
        }
    }
    return -1;
}

bool aggiungiStudente(Studente archivio[], int& n,
                     const Studente& nuovo) {
    if (n >= MAX || !studenteValido(nuovo)) {
        return false;
    }
    if (cercaStudente(archivio, n, nuovo.matricola) != -1) {
        return false;
    }
    archivio[n] = nuovo;
    n++;
    return true;
}

bool modificaStudente(Studente archivio[], int n,
                     const Studente& aggiornato) {
    if (!studenteValido(aggiornato)) {
        return false;
    }
    int posizione = cercaStudente(archivio, n, aggiornato.matricola);
    if (posizione == -1) {
        return false;
    }
    archivio[posizione] = aggiornato;
    return true;
}

bool rimuoviStudente(Studente archivio[], int& n, int matricola) {
    int posizione = cercaStudente(archivio, n, matricola);
    if (posizione == -1) {
        return false;
    }
    for (int i = posizione; i < n - 1; i++) {
        archivio[i] = archivio[i + 1];
    }
    n--;
    return true;
}

void stampaArchivio(const Studente archivio[], int n) {
    if (n == 0) {
        cout << "Archivio vuoto\n";
    }
    for (int i = 0; i < n; i++) {
        cout << archivio[i].matricola << " | "
             << archivio[i].nome << " | anno "
             << archivio[i].anno << '\n';
    }
}

bool convertiIntero(const string& testo, int& valore) {
    istringstream in(testo);
    int numero;
    char extra;
    if (!(in >> numero)) {
        return false;
    }
    if (in >> extra) {
        return false;
    }
    valore = numero;
    return true;
}

bool archivioValido(const Studente archivio[], int n) {
    if (n < 0 || n > MAX) {
        return false;
    }
    for (int i = 0; i < n; i++) {
        if (!studenteValido(archivio[i])) {
            return false;
        }
        if (cercaStudente(archivio, i, archivio[i].matricola) != -1) {
            return false;
        }
    }
    return true;
}

bool caricaSpazi(const string& nomeFile, Studente archivio[], int& n) {
    ifstream in(nomeFile);
    if (!in) {
        return false;
    }
    Studente temporanei[MAX];
    int quanti = 0;
    string matricola;
    string anno;
    while (in >> matricola) {
        Studente s;
        if (!(in >> s.nome >> anno)) {
            return false;
        }
        if (!convertiIntero(matricola, s.matricola)
            || !convertiIntero(anno, s.anno)) {
            return false;
        }
        if (!aggiungiStudente(temporanei, quanti, s)) {
            return false;
        }
    }
    if (!in.eof() || in.bad()) {
        return false;
    }
    // Solo un caricamento completo sostituisce l'archivio precedente.
    for (int i = 0; i < quanti; i++) {
        archivio[i] = temporanei[i];
    }
    n = quanti;
    return true;
}

bool salvaSpazi(const string& nomeFile, const Studente archivio[], int n) {
    if (!archivioValido(archivio, n)) {
        return false;
    }
    for (int i = 0; i < n; i++) {
        if (archivio[i].nome.find(' ') != string::npos) {
            return false;
        }
    }
    // I controlli sui dati precedono l'apertura che cancella il vecchio file.
    ofstream out(nomeFile);
    if (!out) {
        return false;
    }
    for (int i = 0; i < n; i++) {
        out << archivio[i].matricola << ' '
            << archivio[i].nome << ' '
            << archivio[i].anno << '\n';
    }
    out.close();
    return !out.fail();
}

void togliCR(string& riga) {
    if (!riga.empty() && riga.back() == '\r') {
        riga.pop_back();
    }
}

bool leggiRecordCSV(const string& riga, Studente& risultato) {
    istringstream campi(riga);
    Studente s;
    string matricola;
    string anno;
    if (!getline(campi, matricola, ';')) {
        return false;
    }
    if (!getline(campi, s.nome, ';')) {
        return false;
    }
    if (!getline(campi, anno)) {
        return false;
    }
    if (!convertiIntero(matricola, s.matricola)
        || !convertiIntero(anno, s.anno)) {
        return false;
    }
    if (!studenteValido(s)) {
        return false;
    }
    risultato = s;
    return true;
}

bool caricaCSV(const string& nomeFile, Studente archivio[], int& n) {
    ifstream in(nomeFile);
    if (!in) {
        return false;
    }
    string riga;
    if (!getline(in, riga)) {
        return false;
    }
    togliCR(riga);
    if (riga != "matricola;nome;anno") {
        return false;
    }
    Studente temporanei[MAX];
    int quanti = 0;
    while (getline(in, riga)) {
        togliCR(riga);
        Studente s;
        if (!leggiRecordCSV(riga, s)) {
            return false;
        }
        if (!aggiungiStudente(temporanei, quanti, s)) {
            return false;
        }
    }
    if (!in.eof() || in.bad()) {
        return false;
    }
    for (int i = 0; i < quanti; i++) {
        archivio[i] = temporanei[i];
    }
    n = quanti;
    return true;
}

bool salvaCSV(const string& nomeFile, const Studente archivio[], int n) {
    if (!archivioValido(archivio, n)) {
        return false;
    }
    ofstream out(nomeFile);
    if (!out) {
        return false;
    }
    out << "matricola;nome;anno\n";
    for (int i = 0; i < n; i++) {
        out << archivio[i].matricola << ';'
            << archivio[i].nome << ';'
            << archivio[i].anno << '\n';
    }
    out.close();
    return !out.fail();
}

bool chiediIntero(const string& messaggio, int& valore) {
    cout << messaggio;
    string riga;
    if (!getline(cin, riga)) {
        return false;
    }
    return convertiIntero(riga, valore);
}

bool chiediStudente(Studente& risultato) {
    Studente s;
    if (!chiediIntero("Matricola: ", s.matricola)) {
        return false;
    }
    cout << "Nome (anche con spazi, solo per il CSV): ";
    if (!getline(cin, s.nome)) {
        return false;
    }
    if (!chiediIntero("Anno di corso (1-5): ", s.anno)) {
        return false;
    }
    if (!studenteValido(s)) {
        return false;
    }
    risultato = s;
    return true;
}

int main() {
    Studente archivio[MAX];
    int n = 0;
    int scelta;
    while (true) {
        cout << "\n1 Carica studenti_spazi.txt\n"
             << "2 Carica studenti.csv\n"
             << "3 Mostra archivio\n"
             << "4 Aggiungi studente\n"
             << "5 Modifica nome e anno di uno studente\n"
             << "6 Rimuovi studente\n"
             << "7 Salva studenti_spazi.txt\n"
             << "8 Salva studenti.csv\n"
             << "0 Esci (senza salvataggio automatico)\n";
        if (!chiediIntero("Scelta: ", scelta)) {
            cerr << "Scelta non numerica o input terminato\n";
            return 1;
        }
        if (scelta == 0) {
            return 0;
        }
        bool riuscita = false;
        if (scelta == 1) {
            riuscita = caricaSpazi("studenti_spazi.txt", archivio, n);
        } else if (scelta == 2) {
            riuscita = caricaCSV("studenti.csv", archivio, n);
        } else if (scelta == 3) {
            stampaArchivio(archivio, n);
            continue;
        } else if (scelta == 4 || scelta == 5) {
            Studente s;
            if (chiediStudente(s)) {
                if (scelta == 4) {
                    riuscita = aggiungiStudente(archivio, n, s);
                } else {
                    riuscita = modificaStudente(archivio, n, s);
                }
            }
        } else if (scelta == 6) {
            int matricola;
            if (chiediIntero("Matricola da rimuovere: ", matricola)) {
                riuscita = rimuoviStudente(archivio, n, matricola);
            }
        } else if (scelta == 7) {
            riuscita = salvaSpazi("studenti_spazi.txt", archivio, n);
        } else if (scelta == 8) {
            riuscita = salvaCSV("studenti.csv", archivio, n);
        } else {
            cout << "Scelta non prevista\n";
            continue;
        }
        if (riuscita) {
            cout << "Operazione completata\n";
        } else {
            cout << "Operazione non riuscita: controlla dati, matricola, "
                 << "capacità e file. I nomi con spazi richiedono il CSV.\n";
        }
    }
}
