# Children and (future) Parents, supported by Prediction and Professionals in Prevention, to improve Opportunity - C-4PO

## Doel van C-4PO: hoe kunnen we (aanstaande) ouders ondersteunen tijdens de eerste 1000 dagen?
*(The English version will soon be available)*

De ontwikkeling van een kind tijdens de zwangerschap en de eerste twee jaar van het leven heeft invloed op de gezondheid en ontwikkeling tijdens het hele leven. Helaas hebben sommige kinderen een slechte start. Doordat zij te vroeg geboren worden, te weinig wegen bij de geboorte of door andere factoren. De gezondheid van een kind voor, tijdens en na de geboorte blijkt een belangrijke voorspeller te zijn van problemen – zowel fysiek als mentaal – op latere leeftijd.

In dit project gaan ouders, professionals en onderzoekers samen ontdekken hoe “big data” ingezet kunnen worden voor zorg op maat. Zo hoopt C-4PO (aanstaande) ouders beter te kunnen ondersteunen in de eerste 1000 dagen van het leven van hun kind.

Het project bestaat uit meerdere stappen. Wetenschappers onderzoeken met “big data” en voorspelmodellen welke kenmerken in het vroege leven samenhangen met ongunstige ontwikkeling of gezondheidsproblemen op een later moment. Daarbij maken zij gebruik van gepseudonimiseerde gegevens over de gezondheid en ontwikkeling van honderdduizenden kinderen die al wat ouder zijn. Dit gebeurt binnen de beveiligde data-omgeving van het Centraal Bureau voor de Statistiek (CBS). Een zeer beperkte groep onderzoekers heeft toegang tot die gegevens en de gegevens blijven achter slot en grendel bij het CBS.

In de volgende stap gaan we in de regio's Rotterdam, Twente en Zuid-Limburg met ouders én professionals in de geboortezorg en de jeugdgezondheidszorg aan de slag met de resultaten van het onderzoek. Door vroegtijdig inzicht te krijgen in de situatie van een kind, kunnen zij samen besluiten op welke manier (aanstaande) ouders het beste ondersteund kunnen worden. 

Richting het einde van dit project wordt zorgvuldig afgewogen of de resultaten van het model ook in de rest van Nederland ingezet kunnen worden in de geboortezorg en de jeugdgezondheidszorg. Voorop staat dat we uiterst zorgvuldig omgaan met alle data en de resultaten van de voorspelmodellen. In het project zullen ook de ethische, juridische en maatschappelijke overwegingen bij het gebruik van “big data” worden meegenomen. Hierover zullen we openbaar verslag doen.

# Wat kun je met de harmonization-scripts van C-4PO? 
## Harmonization-scripts van C-4PO: de geharmonizeerde microdata 
De onderzoekers in het project C-4PO werken met CBS microdata over de gezondheid en ontwikkeling van kinderen, demografische variabelen en ouderkenmerken, zoals inkomen en sociaaleconomische status. We hebben gegevens van 11 CBS microdata bestanden geharmoniseerd;
- PRNL (2004-2016): Perinatale Registratie Nederland 
- KINDOUDERTAB: om kinderen aan hun ouders te koppelen
- GBAPERSOONTAB: Persoonskenmerken van alle in de Gemeentelijke Basis Administratie (GBA) ingeschreven personen
-	GBAADRESOBJECTBUS: Adreskenmerken van personen die in de gemeentelijke bevolkingsregisters ingeschreven (hebben ge)staan
-	HOOGSTEOPLTAB: Hoogst behaald en hoogst gevolgd opleidingsniveau en opleidingsrichting van de bevolking in Nederland 
-	IPI (2003-2010) INPATAB (2011-2020): Inkomen van personen 
-	POLISBUS (2006-2010) SPOLISBUS (2010-202106): Banen en lonen op basis van de Polisadministratie 
-	SECMBUS: Personen sociaaleconomische categorie
-	ZVWZORGKOSTENTAB: Zorgkosten van Nederlandse ingezetenen met een basisverzekering

## Hoe te gebruiken? 
Je kunt het R script [pipeline.R](https://github.com/MMJHendriks/HarmonizationScripts_CBSmicrodata/blob/main/C-4PO/pipeline.R) gebruiken om, in de Remote Access omgeving van het CBS, in één keer alle harmonization scripts te runnen. Zo genereer je een ready-to-use data set. Let op! Dit werkt alleen als je toegang hebt tot de bovenstaande microdata bestanden. Bovendien is deze data set gecreëerd voor het project C-4PO, het kan dus zijn dat dit niet de juiste data set is voor uw project en uw onderzoek.  

Werkt u aan uw eigen project met andere CBS microdata dan hierboven beschreven staat (niet getreurd), deze harmonization-scripts kunnen nog steeds behulpzaam zijn! Gebruik de code als inspiratie voor het oplossen van uw eigen data harmonization uitdagingen. 


## Meer informatie over C-4PO
###### Samenwerking tussen wetenschap en samenleving
C-4PO ontvangt financiering van de Nationale Wetenschapsagenda en de Bernard van Leer Foundation. De Nationale Wetenschapsagenda (NWA) is tot stand gekomen met de inbreng van burgers en wetenschappers. Het doel van de NWA is om met kennis een positieve, structurele bijdrage te leveren aan de maatschappij van morgen. Door vandaag bruggen te slaan tussen onderzoek en maatschappelijke partners wordt gezorgd voor impact in de wetenschap én de samenleving.  

De Nationale Wetenschapsagenda:
-	Stimuleert wetenschappelijke doorbraken en maatschappelijke verandering; 
-	Bevordert kennisontwikkeling en -deling via interdisciplinaire en kennisketenbrede (fundamenteel, toegepast en praktijkgericht onderzoek) samenwerking; 
-	Betrekt de samenleving en maatschappelijke partners proactief bij het formuleren, opzetten en uitvoeren van onderzoek. De dialoog tussen wetenschap en samenleving wordt verder versterkt door gerichte communicatie- en outreach-activiteiten en door het actief betrekken van burgers bij wetenschap en onderzoek.

De Bernard van Leer Foundation ondersteunt C-4PO financieel en met haar expertise op het gebied van het vertalen van onderzoek naar beleid en praktijk. De Bernard van Leer Foundation gelooft dat het realiseren van een sterke start voor alle jonge kinderen niet alleen goed is vanuit moreel perspectief, maar ook de beste manier is om een gezonde, welvarende en creatieve samenleving te creëren.

Voor het project is ruim 1,3 miljoen euro toegekend vanuit de Nationale Wetenschapsagenda en 240 duizend euro door de Bernard van Leer Foundation. Het project heeft een looptijd van 30 maanden en wordt afgerond in mei 2024.

###### Wie werken samen binnen C-4PO?
Het consortium bestaat uit negen aanvragers, namelijk de Erasmus School of Economics (penvoerder), Erasmus MC, de Universiteit Maastricht, de Hogeschool Rotterdam, het Verwey-Jonker Instituut, GGD Twente, GGD Zuid-Limburg, TNO, het Nederlands Centrum Jeugdgezondheid. Nu gaan zij aan de slag met de uitwerking. Ook andere partijen zijn of worden betrokken, zoals jeugdgezondheidszorg-organisaties, V&VN, AJN, VSV Twente, Regionaal Consortium Zwangerschap en Geboorte Zuidwest Nederland, de Universiteit van Amsterdam, LUMC, Radboud Universiteit Nijmegen, Pharos en de Bernard van Leer Foundation. 

###### Even voorstellen 
Bastian Ravesteijn, penvoerder C-4PO - *“Nederland is wereldwijd koploper in het bieden van hulp en ondersteuning tijdens de eerste 1000 dagen, maar het kan nog zoveel beter”*
Bastian Ravesteijn (Erasmus School of Economics) is penvoerder van C-4PO. Hij is als micro-econometrist geïnteresseerd geraakt in kansengelijkheid en de gezondheid en ontwikkeling van kinderen in de vroege jeugd. Na een aantal jaar gewerkt te hebben als ‘research fellow’ bij Harvard Medical School in Boston, is hij nu universitair docent op de Erasmus School of Economics. “Onderzoek naar het verbeteren van kansen in de vroege jeugd sluit erg goed aan bij de ambities van de Nationale Wetenschapsagenda. We brengen ouders en professionals samen met onderzoekers op het gebied van kwantitatieve en kwalitatieve onderzoeksmethoden. De kennis en inzichten die we opdoen blijven niet op de plank liggen, maar zullen direct gebruikt gaan worden in de praktijk.”

Mirthe Hendriks, data analist C-4PO - “Mijn doel is om data en de praktijk te verbinden om zo kinderen een kansrijke start te geven.”
Mirthe Hendriks is afgestudeerd aan de Universiteit Utrecht met een Master in Applied Data Science en Conflict Studies and Human Rights. "Ik ben leergiering en breed geïnteresseerd en ik wil graag een bijdrage leveren aan maatschappelijk kwesties zoals kansengelijkheid, zorg en welzijn. Binnen C-4PO zal ik bijdragen aan het modelleren van voorspellingen met behulp van machine learning, het vertalen van deze modellen in bruikbaar gereedschap en het evalueren daarvan in de praktijk.”


###### Waar komt de naam C-4PO vandaan?
C-4PO is een woordgrapje dat toevallig precies goed uitkwam. Misschien wist u al dat C-3PO het gouden robotje is in de Star Wars-films. C-3PO houdt zich bezig met het verbeteren van de relatie tussen mens en techniek. Dat is ook wat ons consortium hoopt te doen. De C in C-4PO staat voor Children (kinderen), de vier P’s staan voor (future) Parents, supported by Prediction and Professionals in Prevention ((toekomstige) ouders die ondersteund worden door voorspelmodellen en door professionals die zich bezighouden met preventie) en de O staat voor to improve Opportunity (het verbeteren van kansen en mogelijkheden voor die kinderen). C-4PO dus!

# Contact
Voor vragen en/of opmerkingen: [m.m.j.hendriks@ese.eur.nl](m.m.j.hendriks@ese.eur.nl) of [www.linkedin.com/in/mirthe-hendriks](www.linkedin.com/in/mirthe-hendriks)








