## Zadanie
Napisać prostą aplikację do sprawdzania prognozy pogody z wykorzystaniem jakiejś darmowej usługi np. http://apidev.accuweather.com/developers/ lub http://openweathermap.org/api (do wyboru programisty)

## Założenia biznesowe
na pierwszym widoku będzie można podać miasto dla którego chce się wyszukać prognozę pogody lub wybrać jedno z miast już wcześniej wyszukiwanych. Wskazane jest zrobienie zapamiętywania wyszukiwanych miast pomiędzy uruchomieniami aplikacji. Nazwa miejscowości ma być walidowana wg wyrażenia regularnego a-zA-Z
po pobraniu prognozy pogody dla podanego miasta ma nastąpić nawigacja do nowego widoku ze szczegółami prognozy
ilość szczegółów prognozy pogody na ekranie szczegółowym jest dowolna. Może być np. temperatura aktualna, stan zachmurzenia, możliwość opadów, tabelka z temperaturami na najbliższe godziny itd w zależności co uda się pobrać z usługi. Po przejściu na ekran szczegółów mogą być dociągane jakieś dodatkowe dane, np. prognoza na kolejne dni
kolor czcionki temperatury ma różnić się w zależności od stopni -> poniżej 10 stopni kolor niebieski, między 10 a 20 stopni kolor czarny, powyżej 20 kolor czerwony
UI aplikacji pozostawiamy w gestii programisty - ma być taki, jaki programista chciałby sam używać w swojej aplikacji

## Założenia techniczne
Rozwiązanie powinno zostać dostarczone jako kompletny projekt Xcode w postaci repozytorium git możliwego do sklonowania. Może to być np jakieś repozytorium na GitHubie. Aplikacja powinna uruchamiać się na symulatorze oraz dowolnie wybranym modelu iPhone’a (minimalna wersja wersja systemu - iOS 10).

### 2 widoki:
- wybór miasta i 
