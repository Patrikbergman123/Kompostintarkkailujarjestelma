# Kompostintarkkailujärjestelmä
2026 kesäprojekti
Laitteisto: Arduino mkr Wi-Fi 1010
Ohjelmisto: flutter

# Yleistä järjestelmästä
Tämä kompostintarkkailu järjestelmä koostuu kahdesta osasta, laitteistosta ja erillisestä käyttöliittymästä, jota voi ajaa esim. kotipalvelimella. Arduino liitetään kotiverkkoon Wi-Fi yhteydellä, jolle reititin antaa paikallisen ip-osoitteen (Tämä on näkyvissä arduinon omalla fyysisellä näytöllä). Arduino lukee anturin kosteus- ja lämpötila-arvoja, luo oman pienen web-palvelimen, jonne mittausdata siirretään json muodossa. Flutter web app lukee täältä mittausarvot ja näyttävät ne omassa liittymässään. Yksinkertaisin ratkaisu tämän toteuttamiseen olisi ollut koko paketin työntäminen Arduinoon, jolloin järjestelmästä ei olisi tarvinnut tehdä "kaksiosaista", mutta laitteiston teho ei tähän riittänyt.

# Käyttöohjeet


