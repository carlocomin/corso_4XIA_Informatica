# Verifica – OOP in C/C++ (Lezione 4 fino al costruttore di copia)

## Struttura e durata
- Durata complessiva: **50 minuti** (seguirà una parte di programmazione separata).
- Circa **60% quesiti a risposta chiusa** (una sola risposta esatta su 5, con opzione "nessuna delle altre") e **40% a risposta aperta**.
- Argomenti: introduzione all'OOP in C/C++ fino al **costruttore di copia**; esclusi overloading dell'operatore di assegnamento e move constructor/assignment.

---

## Quesiti a risposta chiusa (7)
1. Nel frammento seguente:
   ```cpp
   class Conto {
   private:
       double saldo;
   public:
       void deposita(double v) { saldo += v; }
   };

   int main() {
       Conto c;
       // ?
   }
   ```
   Quale riga sostituisce `// ?` affinché il codice **compili** rispettando l'incapsulamento?
   - A) `c.saldo = 1000;`
   - B) `std::cout << c.saldo;`
   - C) `c.deposita(1000);`
   - D) `double x = c.saldo;`
   - E) Nessuna delle altre

2. Considera una classe con membri `const`:
   ```cpp
   class Punto {
   private:
       const int x;
       int y;
   public:
       Punto(int xx, int yy) : x(xx) { y = yy; }
   };
   ```
   Qual è il motivo per cui la lista di inizializzazione è indispensabile qui?
   - A) Senza lista, `x` rimarrebbe non inizializzato e il compilatore genera errore
   - B) Serve solo per migliorare le performance, ma il codice compila ugualmente
   - C) Inizializza `y` prima di `x` per rispettare l'ordine alfabetico
   - D) Evita che il distruttore sia implicito
   - E) Nessuna delle altre

3. Dato il seguente programma:
   ```cpp
   struct Timer {
       Timer() { std::cout << "ctor"; }
       ~Timer() { std::cout << "dtor"; }
   };

   int main() {
       Timer t;
       {
           Timer u;
       }
       std::cout << '!';
   }
   ```
   Cosa stampa **esattamente** su stdout?
   - A) `ctor!dtorctor`
   - B) `ctorctordtor!`
   - C) `ctorctordtor!dtor`
   - D) `ctordtorctor!`
   - E) Nessuna delle altre

4. Riguardo ai metodi `const`, quale riga provoca errore di compilazione?
   ```cpp
   class Punto {
   private:
       int x, y;
   public:
       void sposta(int dx, int dy) { x += dx; y += dy; }
       int getX() const { return x; }
   };
   ```
   - A) `const Punto p(1, 2); p.getX();`
   - B) `const Punto p(1, 2); p.sposta(1, 0);`
   - C) `Punto p; p.sposta(1, 0);`
   - D) `Punto p; p.getX();`
   - E) Nessuna delle altre

5. Dov'è l'errore logico nel frammento che gestisce memoria dinamica?
   ```cpp
   class Buffer {
       size_t n;
       int* data;
   public:
       Buffer(size_t n) : n(n), data(new int[n]) {}
       ~Buffer() { delete[] data; }
   };

   void usa(Buffer b) { /* ... */ }
   int main() {
       Buffer a(3);
       usa(a);
   }
   ```
   - A) Il distruttore è marcato `const`
   - B) Il costruttore non inizializza `n`
   - C) La copia di `a` in `usa` porta a doppia `delete[]` senza un costruttore di copia profondo
   - D) `delete[]` andrebbe sostituito con `delete`
   - E) Nessuna delle altre

6. Completa il costruttore per far stampare `A(1) B(2)` nell'ordine corretto:
   ```cpp
   class Coppia {
       int a, b;
   public:
       Coppia(int x, int y) /* ? */ {
           std::cout << " B(" << b << ")";
       }
   };
   ```
   Quale opzione inserisci al posto di `/* ? */`?
   - A) `: a(x), b(y) { std::cout << " A(" << a << ")"; }`
   - B) `: b(y), a(x) { std::cout << " A(" << a << ")"; }`
   - C) `{ a = x; b = y; std::cout << " A(" << a << ")"; }`
   - D) `: a{x}, b{y} { std::cout << " A(" << a << ")"; }`
   - E) Nessuna delle altre

7. In quale scenario il **costruttore di copia** viene invocato implicitamente nel seguente codice?
   ```cpp
   class Punto {
   public:
       Punto() = default;
       Punto(const Punto&) { std::cout << "copy"; }
   };
   ```
   - A) `Punto p; Punto q = p;` ma non in `void f(Punto p); f(p);`
   - B) `Punto p; Punto q(p);` e anche quando `Punto g() { Punto r; return r; }` (prima del C++17 NRVO obbligatorio)
   - C) Solo con `Punto* p = new Punto(*q);`
   - D) Mai, perché il compilatore preferisce sempre il move constructor implicito
   - E) Nessuna delle altre

---

## Quesiti a risposta aperta (5)
1. Spiega con un esempio cosa significa **astrazione** in una classe C++ e come si collega al concetto di contratto d'uso.
2. Descrivi il ruolo dell'**incapsulamento** per mantenere un invariante (esempio: saldo non negativo in un conto bancario) e quali parole chiave del linguaggio supportano questo principio.
3. Illustra la differenza tra **costruttore di default**, **costruttore parametrico** e **distruttore**, indicando quando il compilatore li genera automaticamente.
4. Definisci cos'è un **costruttore di copia**, quando viene invocato e perché una copia superficiale può essere pericolosa in presenza di risorse dinamiche.
5. Fornisci uno schema minimo di classe `Punto` che rispetti buone pratiche viste a lezione: campi privati, costruttori, metodo `sposta`, metodo osservatore `distanza_da_origine` marcato `const` e una `to_string()` per la stampa.

---

## Suggerimenti di punteggio (facoltativo)
- Quesiti chiusi: 1 punto ciascuno (7 pt totali).
- Quesiti aperti: 2–3 punti ciascuno in base alla completezza (circa 12 pt totali).
- Totale teorico: ~19 pt ⇒ scalare a 10/10 secondo necessità.
