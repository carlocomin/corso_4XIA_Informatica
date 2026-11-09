#ifndef BATTERIA_H
#define BATTERIA_H

class Batteria {
private:
    int livello;

public:
    Batteria();
    Batteria(int iniziale);
    int leggiLivello() const;
    void caricaCompleta();
    bool consuma(int quantita);
    bool ricarica(int quantita);
};

#endif
