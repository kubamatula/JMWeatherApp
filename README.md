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
