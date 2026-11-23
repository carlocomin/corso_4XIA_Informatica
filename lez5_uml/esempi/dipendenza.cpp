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

class Report {
public:
    void stampaCodice(const Robot& robot) const {
        cout << robot.leggiCodice() << '\n';
    }
};

int main() {
    Report report;
    {
        Robot r1(101);
        report.stampaCodice(r1);
    }
    Robot r2(102);
    report.stampaCodice(r2);
    return 0;
}
