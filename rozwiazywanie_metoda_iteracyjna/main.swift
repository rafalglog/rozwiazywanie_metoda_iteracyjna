//program na zajęcia: Metody Numeryczne projekt
//Proszę przygotować program do rozwiązywania układów równań liniowych dowolną metodą iteracyjną
//Wybrana metoda: Jacobiego
//Rafał Głogowski
//numer albumu: 163707
//Grupa Dziekańska U2 Semestr 1

import Foundation

// Funkcja wczytująca macierz z pliku o podanej ścieżce
func wczytajMacierzZPliku(sciezkaPliku: String) -> [[Double]]? {
	do {
		// Odczytaj zawartość pliku
		let zawartosc = try String(contentsOfFile: sciezkaPliku, encoding: .utf8)
		// Podziel zawartość na wiersze
		let wiersze = zawartosc.components(separatedBy: .newlines)

		var macierz = [[Double]]()
		// Przetwórz każdy wiersz na tablicę Double-ów i dodaj go do macierzy
		for wiersz in wiersze {
			let elementy = wiersz.components(separatedBy: " ")
				.compactMap { Double($0) }
			if !elementy.isEmpty {
				macierz.append(elementy)
			}
		}

		return macierz
	} catch {
		// Obsłuż błąd wczytywania pliku
		print("Błąd podczas wczytywania pliku: \(error)")
		return nil
	}
}

// Funkcja rozwiązująca układ równań liniowych metodą Jacobiego
func rozwiazRownaniaLiniowe(macierz: [[Double]]) {
	let n = macierz.count
	var wspolczynniki: [[Double]] = []
	var stale: [Double] = []

	// Przetwórz macierz, aby uzyskać współczynniki i stałe z równań
	for wiersz in macierz {
		guard wiersz.count == n + 1 else {
			print("Błędny format danych w macierzy.")
			return
		}

		let wspolczynnikiWiersza = Array(wiersz.dropLast())
		let stala = wiersz.last!

		wspolczynniki.append(wspolczynnikiWiersza)
		stale.append(stala)
	}

	var x = Array(repeating: 0.0, count: n)

	let maksymalnaLiczbaIteracji = 100
	let tolerancja = 0.0001

	// Iteracyjnie aktualizuj wartości wektora x
	for _ in 0..<maksymalnaLiczbaIteracji {
		var blad = 0.0
		for i in 0..<n {
			var suma = stale[i]
			for j in 0..<n {
				if i != j {
					suma -= wspolczynniki[i][j] * x[j]
				}
			}
			let noweX = suma / wspolczynniki[i][i]
			blad += abs(noweX - x[i])
			x[i] = noweX
		}
		// Sprawdź, czy osiągnięto wystarczającą dokładność
		if blad < tolerancja {
			break
		}
	}

	// Wyświetl rozwiązanie
	print("Rozwiązanie: \(x)")
}

// Użycie programu
if let sciezkaPliku = Bundle.main.path(forResource: "test", ofType: "txt"), let macierz = wczytajMacierzZPliku(sciezkaPliku: sciezkaPliku) {
	rozwiazRownaniaLiniowe(macierz: macierz)
} else {
	print("Nie udało się wczytać danych z pliku.")
}
