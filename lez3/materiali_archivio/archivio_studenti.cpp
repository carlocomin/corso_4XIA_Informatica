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
    return s.matricola > 0 && !s.nome.empty()
        && s.anno >= 1 && s.anno <= 5;
}

int cercaStudente(const Studente archivio[], int n, int matricola) {
    for (int i = 0; i < n; i++) {
        if (archivio[i].matricola == matricola) return i;
    }
    return -1;
}

bool aggiungiStudente(Studente archivio[], int& n, const Studente& nuovo) {
    if (n >= MAX || !studenteValido(nuovo)) return false;
    if (cercaStudente(archivio, n, nuovo.matricola) != -1) return false;
    archivio[n] = nuovo;
    n++;
    return true;
}

bool modificaStudente(Studente archivio[], int n, const Studente& aggiornato) {
    if (!studenteValido(aggiornato)) return false;
    int posizione = cercaStudente(archivio, n, aggiornato.matricola);
    if (posizione == -1) return false;
    archivio[posizione] = aggiornato;
    return true;
}

bool rimuoviStudente(Studente archivio[], int& n, int matricola) {
    int posizione = cercaStudente(archivio, n, matricola);
    if (posizione == -1) return false;
    for (int i = posizione; i < n - 1; i++) {
        archivio[i] = archivio[i + 1];
    }
    n--;
    return true;
}

void stampaArchivio(const Studente archivio[], int n) {
    if (n == 0) cout << "Archivio vuoto\n";
    for (int i = 0; i < n; i++) {
        cout << archivio[i].matricola << ' '
             << archivio[i].nome << ' ' << archivio[i].anno << '\n';
    }
}

int convertiIntero(const string& testo) {
    // Presuppone un intero completo e rappresentabile come int.
    return stoi(testo);
}

bool ricostruisciStudente(const string& matricola, const string& nome,
                         const string& anno, Studente& risultato) {
    Studente s;
    s.matricola = convertiIntero(matricola);
    s.nome = nome;
    s.anno = convertiIntero(anno);
    if (!studenteValido(s)) return false;
    risultato = s;
    return true;
}

bool caricaSpazi(const string& nomeFile, Studente archivio[], int& n) {
    ifstream in(nomeFile);
    if (!in) return false;
    n = 0;
    Studente s;
    while (in >> s.matricola) {
        if (!(in >> s.nome >> s.anno)) return false;
        if (!aggiungiStudente(archivio, n, s)) return false;
    }
    return in.eof() && !in.bad();
}

bool salvaSpazi(const string& nomeFile, const Studente archivio[], int n) {
    // Per questo formato i nomi devono essere singole parole.
    if (n < 0 || n > MAX) return false;
    ofstream out(nomeFile);
    if (!out) return false;
    for (int i = 0; i < n; i++) {
        out << archivio[i].matricola << ' '
            << archivio[i].nome << ' ' << archivio[i].anno << '\n';
    }
    out.close();
    return !out.fail();
}

bool leggiRecordCSV(const string& riga, Studente& risultato) {
    istringstream campi(riga);
    string matricola;
    string nome;
    string anno;
    if (!getline(campi, matricola, ';')) return false;
    if (!getline(campi, nome, ';')) return false;
    if (!getline(campi, anno)) return false;
    return ricostruisciStudente(matricola, nome, anno, risultato);
}

bool caricaCSV(const string& nomeFile, Studente archivio[], int& n) {
    ifstream in(nomeFile);
    if (!in) return false;
    string riga;
    if (!getline(in, riga) || riga != "matricola;nome;anno") return false;
    n = 0;
    while (getline(in, riga)) {
        Studente s;
        if (!leggiRecordCSV(riga, s)) return false;
        if (!aggiungiStudente(archivio, n, s)) return false;
    }
    return in.eof() && !in.bad();
}

bool salvaCSV(const string& nomeFile, const Studente archivio[], int n) {
    // I nomi possono avere spazi, ma non separatori o virgolette.
    if (n < 0 || n > MAX) return false;
    ofstream out(nomeFile);
    if (!out) return false;
    out << "matricola;nome;anno\n";
    for (int i = 0; i < n; i++) {
        out << archivio[i].matricola << ';'
            << archivio[i].nome << ';' << archivio[i].anno << '\n';
    }
    out.close();
    return !out.fail();
}

int main() {
    Studente archivio[MAX];
    int n = 0;

    if (!caricaSpazi("studenti_spazi.txt", archivio, n)) {
        cout << "Caricamento fallito\n";
        return 1;
    }
    cout << "Archivio iniziale\n";
    stampaArchivio(archivio, n);

    Studente nuovo = {1004, "Edsger", 5};
    if (!aggiungiStudente(archivio, n, nuovo)) return 1;
    Studente aggiornato = {1002, "Turing", 5};
    if (!modificaStudente(archivio, n, aggiornato)) return 1;
    if (!rimuoviStudente(archivio, n, 1001)) return 1;

    cout << "Dopo le modifiche\n";
    stampaArchivio(archivio, n);

    if (!salvaSpazi("studenti_aggiornati.txt", archivio, n)) return 1;
    if (!salvaCSV("studenti_aggiornati.csv", archivio, n)) return 1;
    if (!caricaCSV("studenti_aggiornati.csv", archivio, n)) return 1;

    cout << "Riletto dal CSV\n";
    stampaArchivio(archivio, n);
    return 0;
}
