# Kompostin tarkkailujärjestelmä
2026 kesäprojekti
Laitteisto: Arduino mkr Wi-Fi 1010
Ohjelmisto: flutter

# Yleistä järjestelmästä
Tämä kompostintarkkailu järjestelmä koostuu kahdesta osasta, laitteistosta ja erillisestä käyttöliittymästä, jota voi ajaa esim. kotipalvelimella. Arduino liitetään kotiverkkoon Wi-Fi yhteydellä, jolle reititin antaa paikallisen ip-osoitteen (Tämä on näkyvissä arduinon omalla fyysisellä näytöllä). Arduino lukee anturin kosteus- ja lämpötila-arvoja, luo oman pienen web-palvelimen, jonne mittausdata siirretään json muodossa. Flutter web app lukee täältä mittausarvot ja näyttävät ne omassa liittymässään. 

# Käyttöohjeet
1. Miten repo siirretään?
2. Kytke Arduino virtalähteeseen, vaihda arduinon koodiin oman kotiverkkosi nimi ja salasana. Arduinon koodi on lisätty varmuuden vuoksi /lib kansioon "Arduinokoodi.txt".
3. Kun arduino on onnistuneesti yhdistynyt kotiverkkoon, arduinon näyttön alareunaan ilmestyy ip osoite. Lisää ip osoite main.dart tiedostossa merkittyyn kohtaan.
4. Tämän jälkeen aja /lib kansiossa komento "flutter pub get" varmuuden vuoksi.
5. Seuraavaksi käynnistääksesi käyttöliittymä aja samassa kansiossa komento  "flutter run -d web-server"


# Mahdolliset ongelmatilanteet
Varmista seuraavat asiat:
1. Reitittimen DHCP-palvelin on käytössä

