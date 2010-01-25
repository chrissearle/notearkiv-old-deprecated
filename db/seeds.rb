# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

epochs = Epoch.create([{ :name => 'Barokk' },
                       { :name => 'Klassisisme' },
                       { :name => 'Nasjonalromantikk' },
                       { :name => 'Nyere' },
                       { :name => 'Renessanse' },
                       { :name => 'Romantikken' },
                       { :name => 'Trad.' }])

composers = Composer.create([{ :name => 'Aafl�y, Helge' },
                             { :name => 'Aamodt, Thorleif' },
                             { :name => 'ABBA, arr. Ingegerd Idar' },
                             { :name => 'Alfredson/Edenroth' },
                             { :name => 'Allegri, Gregorio' },
                             { :name => 'Alnes, Eyvind' },
                             { :name => 'Anderssen, Fridthjov' },
                             { :name => '�rva, �ystein' },
                             { :name => 'Aveyard, J.' },
                             { :name => 'Bach, Johann Sebastian' },
                             { :name => 'Balfour Gardiner, H.' },
                             { :name => 'Barnard, John' },
                             { :name => 'Beck, Thomas' },
                             { :name => 'Berger, Jean' },
                             { :name => 'Bond, Anders' },
                             { :name => 'Borg, Oscar' },
                             { :name => 'Brahms, Johannes' },
                             { :name => 'Briegel, Wolfgang Carl' },
                             { :name => 'Britten, Benjamin' },
                             { :name => 'Bruch, Max' },
                             { :name => 'Bruckner, Anton' },
                             { :name => 'Busengdal/Over�ye' },
                             { :name => 'Byrd, William' },
                             { :name => 'Campian, Thomas' },
                             { :name => 'Dahlen, Trond' },
                             { :name => 'Darke, Harold' },
                             { :name => 'Davies, Walford' },
                             { :name => 'Diverse' },
                             { :name => 'Dowland, John' },
                             { :name => 'Durufl�, Maurice' },
                             { :name => 'Eccard, Johannes' },
                             { :name => 'Egge, Klaus' },
                             { :name => 'Elgar, Edward' },
                             { :name => 'Falck' },
                             { :name => 'Fasmer Dahl/Sandvold' },
                             { :name => 'Faur�, Gabriel' },
                             { :name => 'Fleming, L. L.' },
                             { :name => 'Gardner, John' },
                             { :name => 'Gibbons, Orlando' },
                             { :name => 'Grieg, Edvard' },
                             { :name => 'Gulliksen, Harald' },
                             { :name => 'Gullin/Eriksson' },
                             { :name => 'H�ndel, Georg Friedrich' },
                             { :name => 'Hassler, Hans Leo' },
                             { :name => 'Haweis/Webbe' },
                             { :name => 'Haydn, Joseph' },
                             { :name => 'Hindemith, Paul' },
                             { :name => 'Homilius, G. A.' },
                             { :name => 'Hovland, Egil' },
                             { :name => 'Howells, Herbert' },
                             { :name => 'Hulkkonen, Jaakko' },
                             { :name => 'H�ybye, John' },
                             { :name => 'Jaques, Reginald' },
                             { :name => 'Jennefelt, Thomas' },
                             { :name => 'Karlsen, Kjell M�rk' },
                             { :name => 'Kleive, Iver' },
                             { :name => 'Klug, J.' },
                             { :name => 'Kod�ly, Zolt�n' },
                             { :name => 'Kruse, Bj�rn' },
                             { :name => 'Kvandal, Johan' },
                             { :name => 'Kverno, Trond' },
                             { :name => 'Lasso, Orlando' },
                             { :name => 'Lotti, Antonio' },
                             { :name => 'Luboff, Norman' },
                             { :name => 'Lundin, Bengt' },
                             { :name => 'Martin, Gilbert M.' },
                             { :name => 'Mendelssohn, Felix Bartholdy' },
                             { :name => 'Millington, Andrew' },
                             { :name => 'Monk, E. G.' },
                             { :name => 'Morley, Thomas' },
                             { :name => 'Mozart, Wolfgang Amadeus' },
                             { :name => 'M�ller, Svein' },
                             { :name => 'Nielsen, Ludvig' },
                             { :name => 'Nordraak, Rikard' },
                             { :name => 'Nystedt, Knut' },
                             { :name => 'N�ss, Carl-Andreas' },
                             { :name => '�hrwall, Anders' },
                             { :name => 'Olsson, Otto' },
                             { :name => 'Ord, Boris' },
                             { :name => 'Palestrina, Giovanni Pierluigi' },
                             { :name => 'Parry, C. Hubert H.' },
                             { :name => 'P�rt, Arvo' },
                             { :name => 'Peterson-Berger, W.' },
                             { :name => 'Pr�torius, Michael' },
                             { :name => 'Purcell, Henry' },
                             { :name => 'Ragnarsson, Hj�lmar H.' },
                             { :name => 'Rathbone, George' },
                             { :name => 'Rautavaara, Einojuhani' },
                             { :name => 'Reading, John' },
                             { :name => 'Reger, Max' },
                             { :name => 'Rutter, John' },
                             { :name => 'Saint-Sa�ns, Camille' },
                             { :name => 'Sandvold, Arild' },
                             { :name => 'Sark, Einar Tr�rup' },
                             { :name => 'Sateren, Leland B.' },
                             { :name => 'Scarlatti, A' },
                             { :name => 'Schubert, Franz' },
                             { :name => 'Sch�tz, Heinrich' },
                             { :name => 'Sch�tz/Kverno' },
                             { :name => 'Shaw, Martin' },
                             { :name => 'Sibelius, Jean' },
                             { :name => 'Sigurbj�rnsson, Thorkell' },
                             { :name => 'Simonsen, Terje' },
                             { :name => 'Skauen, Guttorm' },
                             { :name => 'Skotte, G' },
                             { :name => 'Sl�gedal, Bjarne' },
                             { :name => 'Smith, William' },
                             { :name => 'Sommerro, Henning' },
                             { :name => 'Stanford, Charles Villiers' },
                             { :name => 'Sumsion, Herbert' },
                             { :name => 'Takle, Mons Leidvin' },
                             { :name => 'Tchaikovsky, Peter' },
                             { :name => 'Templeton/Alldahl' },
                             { :name => 'Thompson, Randall' },
                             { :name => 'Thorarinsson, J�n' },
                             { :name => 'Trad' },
                             { :name => 'Trad. Arr. Fleming' },
                             { :name => 'Trad. Arr. Luboff' },
                             { :name => 'Trad. Arr. Sl�gedal' },
                             { :name => 'Tveit, Sigvald' },
                             { :name => 'Ukjent' },
                             { :name => 'Verdi, Guiseppe' },
                             { :name => 'Walmisley, T. A.' },
                             { :name => 'Walsh, Michael' },
                             { :name => 'Wesley, Samuel Sebastian' },
                             { :name => 'Weyse, C. E. F.' },
                             { :name => 'Wid�en, Ivar' },
                             { :name => 'Willcocks, David' },
                             { :name => 'Z�llner, C.' },
                             { :name => '�deg�rd, Henrik' }])

genres = Genre.create([{ :name => 'Chant' },
                       { :name => 'Epos' },
                       { :name => 'Folketone' },
                       { :name => 'Hymne' },
                       { :name => 'Irsk folketone' },
                       { :name => 'Jul' },
                       { :name => 'Kantate' },
                       { :name => 'Koral' },
                       { :name => 'Liturgi' },
                       { :name => 'Madrigal' },
                       { :name => 'Motett' },
                       { :name => 'Nasjonalsang' },
                       { :name => 'Oratorium' },
                       { :name => 'Pop' },
                       { :name => 'Salme' },
                       { :name => 'Spiritual' },
                       { :name => 'Te Deum' },
                       { :name => 'Verdslig' },
                       { :name => 'Vise' }])

languages = Language.create([{ :name => 'Dansk' },
                             { :name => 'Engelsk' },
                             { :name => 'Finsk' },
                             { :name => 'Fransk' },
                             { :name => 'Gresk' },
                             { :name => 'Islandsk' },
                             { :name => 'Italiensk' },
                             { :name => 'Latin' },
                             { :name => 'Norsk' },
                             { :name => 'Svensk' },
                             { :name => 'Tysk' }])

instruments = Instrument.create([{ :name => 'A capella' },
                                 { :name => 'A capella el. Continuo' },
                                 { :name => 'A capella el. Orkester' },
                                 { :name => 'A capella el. Strykere' },
                                 { :name => 'Bass' },
                                 { :name => 'Cello' },
                                 { :name => 'Cymbal' },
                                 { :name => 'Fiolin 1&2' },
                                 { :name => 'Fl�yte' },
                                 { :name => 'Klaver' },
                                 { :name => 'Kontrabass' },
                                 { :name => 'Orgel' },
                                 { :name => 'Orgel el. Orkester' },
                                 { :name => 'Orgel el. Piano' },
                                 { :name => 'Orgel el. Strykere' },
                                 { :name => 'Orkester' },
                                 { :name => 'Piano' },
                                 { :name => 'Stortromme' },
                                 { :name => 'Strykere' },
                                 { :name => 'Tam-tam (med k�ller)' },
                                 { :name => 'Tamburin' },
                                 { :name => 'Tromme' }])