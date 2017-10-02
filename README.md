# Zadanie rekuratacyjne, wykonane przez Jakub Matułę

## Ogólnie o zadaniu
Nie wiem czy nie zrobiłem "overengineeringu" na tym projekcie, przez co może być trudny w czytaniu.
Chciałem, żeby łatwy w rozszerzaniu, żeby był loose coupling między elementami, oraz żeby AccuWeatherService było stosunkowo "reusable".
Chciałem też, żeby można było ewentualnie podmienić ją na inną usługę dostarczającą pogodę, co się nie do końca udało, ponieważ można Location jest elementem specyficznym dla AccuWeather.
Starałem się nie korzystać z blibliotek zewnętrznych, ale w związku z formatem jsonów z AccuWeathe zdecydowałem się na SwiftyJSON
Persistance jest dość "ubogi", ale tutaj chciałem użyć rozwiązania możliwie prostego

## Co chciałbym zrobić lepiej, ale nie zdążyłem
Lepszy error handling
UI nie jest powalające..., przydałoby się klasa nadajaca styl całej apce
AccuWeather Service - dużo powtarzającego się kodu
ViewControllery - trochę za dużo odpowiedzialności, ale chciałem ogarniczyc liczbę klas (dlatego np nie robilem oddzielnych DataSourceów)
W kodzie zostało trochę "string literals", "magic numbers", część z nich, szcególnie stringów było zamirzeonych, ale nie wszystkie
Lokalizacja, a przynjamniej przygotownie do niej
Cachowanie requestów/responsów


## Uwagi techniczne
Język: Swift 4
MinIOS v.: 10
Testowane tylko na symulatorze iPhonea z 11 (nie mam zadnego telefonu)
Do uruchomienia projektu potrzebny Xcode 9
Uruchamiać przez: JMWeatherAPP.XcWorkspace, projekt korzysta z CocoaPods, ale jedne "Dependencies" są wrzucone do repo
Uwaga: nie wszystkie pośrednie commity się kompilują!

# AccuWeatherApi pozwala tylko na 50 requestów na dobę (wybrałem to, bo OpeanWeather pozwala na 1 co 10 min), gdyby aplikacja przestala odpowiadac na requesty, mozna zmienic w Constants AccuWeatherAPIKey, są jakies zapasowa w komentarzu


### Zadanie
Napisać prostą aplikację do sprawdzania prognozy pogody z wykorzystaniem jakiejś darmowej usługi np. http://apidev.accuweather.com/developers/ lub http://openweathermap.org/api (do wyboru programisty)

### Założenia biznesowe
na pierwszym widoku będzie można podać miasto dla którego chce się wyszukać prognozę pogody lub wybrać jedno z miast już wcześniej wyszukiwanych. Wskazane jest zrobienie zapamiętywania wyszukiwanych miast pomiędzy uruchomieniami aplikacji. Nazwa miejscowości ma być walidowana wg wyrażenia regularnego a-zA-Z
po pobraniu prognozy pogody dla podanego miasta ma nastąpić nawigacja do nowego widoku ze szczegółami prognozy
ilość szczegółów prognozy pogody na ekranie szczegółowym jest dowolna. Może być np. temperatura aktualna, stan zachmurzenia, możliwość opadów, tabelka z temperaturami na najbliższe godziny itd w zależności co uda się pobrać z usługi. Po przejściu na ekran szczegółów mogą być dociągane jakieś dodatkowe dane, np. prognoza na kolejne dni
kolor czcionki temperatury ma różnić się w zależności od stopni -> poniżej 10 stopni kolor niebieski, między 10 a 20 stopni kolor czarny, powyżej 20 kolor czerwony
UI aplikacji pozostawiamy w gestii programisty - ma być taki, jaki programista chciałby sam używać w swojej aplikacji

### Założenia techniczne
Rozwiązanie powinno zostać dostarczone jako kompletny projekt Xcode w postaci repozytorium git możliwego do sklonowania. Może to być np jakieś repozytorium na GitHubie. Aplikacja powinna uruchamiać się na symulatorze oraz dowolnie wybranym modelu iPhone’a (minimalna wersja wersja systemu - iOS 10).
