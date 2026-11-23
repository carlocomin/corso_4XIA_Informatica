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

class RobotConsegne : public Robot {
private:
    int portataKg;

public:
    RobotConsegne(int codice, int portata)
        : Robot(codice), portataKg(portata) {}

    int leggiPortata() const {
        return portataKg;
    }
};

int main() {
    RobotConsegne r1(101, 5);
    const Robot& robot = r1;
    cout << robot.leggiCodice() << '\n';
    cout << r1.leggiPortata() << '\n';
    return 0;
}
