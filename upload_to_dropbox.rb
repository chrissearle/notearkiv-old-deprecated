#!/opt/local/bin/ruby

require 'rubygems'
require 'lib/dropbox'

db = DropBox.new('chris+notearkiv.ochs.no@chrissearle.org',
             'bei1Ahng',
             'Public/Evensong')

data = Hash.new


data["evensong_1"] = "Walsh.pdf"

data["evensong_2"] = "Tomkins.pdf"

data["evensong_3"] = "Sumsion.pdf"

data["evensong_4"] = "Smith.pdf"

data["evensong_5"] = "Skjølaas.pdf"

data["evensong_6"] = "Reading.pdf"

data["evensong_7"] = "Millington.pdf"

data["evensong_8"] = "Leighton.pdf"

data["evensong_9"] = "Ihlebæk.pdf"

data["evensong_10"] = "Sumsion in G.pdf"

data["evensong_11"] = "Stanford in C.pdf"

data["evensong_12"] = "Stanford in B.pdf"

data["evensong_13"] = "Stanford in A.pdf"

data["evensong_14"] = "Kverno i Fiss.pdf"

data["evensong_15"] = "Howells regale.pdf"

data["evensong_16"] = "Howells Gloucester.pdf"

data["evensong_17"] = "Darke in F.pdf"

data["evensong_18"] = "148 Laudate Dominum.pdf"

data["evensong_19"] = "147 Laudate Dominum.pdf"

data["evensong_20"] = "146 Lauda, anima mea.pdf"

data["evensong_21"] = "145 Exaltabo te, Deus.pdf"

data["evensong_22"] = "139 Domine, probasti.pdf"

data["evensong_23"] = "138 Confitebor tibi.pdf"

data["evensong_24"] = "130 De profundis.pdf"

data["evensong_25"] = "127 Nisi Dominus.pdf"

data["evensong_26"] = "126 In convertendo.pdf"

data["evensong_27"] = "125 Qui confidunt.pdf"

data["evensong_28"] = "124 Nisi quia Dominus.pdf"

data["evensong_29"] = "121 Levavi oculos.pdf"

data["evensong_30"] = "120 Ad Dominum.pdf"

data["evensong_31"] = "118 Confitemini Domino.pdf"

data["evensong_32"] = "116 Dilexi, quoniam.pdf"

data["evensong_33"] = "114 In exitu Israel.pdf"

data["evensong_34"] = "111 Confitebor tibi.pdf"

data["evensong_35"] = "100 Jubilate Deo.pdf"

data["evensong_36"] = "99 Dominus regnavit.pdf"

data["evensong_37"] = "93 Dominus regnavit.pdf"

data["evensong_38"] = "85 Benedixisti, Domine.pdf"

data["evensong_39"] = "84 Quam dilecta.pdf"

data["evensong_40"] = "83 Deus, quis similis.pdf"

data["evensong_41"] = "82 Deus stetit.pdf"

data["evensong_42"] = "80 Qui regis Israel.pdf"

data["evensong_43"] = "79 Deus, venerunt.pdf"

data["evensong_44"] = "77 Voce mea ad Dominum.pdf"

data["evensong_45"] = "75 Confitebimur tibi.pdf"

data["evensong_46"] = "72 Deus, judicium.pdf"

data["evensong_47"] = "71 In te, Domine, speravi.pdf"

data["evensong_48"] = "51 Miserere mei, Deus.pdf"

data["evensong_49"] = "49 Audite hæc, omnes.pdf"

data["evensong_50"] = "42 Quemadmodum-43 Judica me, Deus.pdf"

data["evensong_51"] = "42 Quemadmodum.pdf"

data["evensong_52"] = "38 Domine, ne in furore.pdf"

data["evensong_53"] = "33 Exultate, justi.pdf"

data["evensong_54"] = "28 Ad te, Domine.pdf"

data["evensong_55"] = "26 Judica me, Domine.pdf"

data["evensong_56"] = "25 Ad te, Domini, levavi.pdf"

data["evensong_57"] = "24 Domine est terra.pdf"

data["evensong_58"] = "23 Dominus regit me.pdf"

data["evensong_59"] = "21 Domine, in virtute tua.pdf"

data["evensong_60"] = "15 Domine, quis habitabit.pdf"

data["evensong_61"] = "8 Domine, Dominus noster.pdf"

data["evensong_62"] = "5 Verba mea auribus.pdf"

data["evensong_63"] = "4 Cum invocarem.pdf"

data["evensong_64"] = "3 Domine, quid multiplicati.pdf"

data["evensong_65"] = "1 Beatus vir, qui non abbit.pdf"

data["evensong_66"] = "Walmisley in d.pdf"

data["evensong_67"] = "73 Quam bonus Israel.pdf"

data["evensong_68"] = "113 Laudate, pueri.pdf"

data["evensong_69"] = "Barnard.pdf"

data["evensong_70"] = "Draagen.pdf"

data["evensong_71"] = "Messiaen_O_Sacrum.pdf"

data["evensong_72"] = "O_for_a_closer_walk_with_God.pdf"

data["evensong_73"] = "Noble in B.pdf"

data["evensong_74"] = "Ps.89 Misericordias Domini.pdf"

data["evensong_75"] = "115 Non nobis, Domine.pdf"

data.each do |file, oldfile|
  if FileTest.exists?(oldfile)
 #   db.create(oldfile)
 #   db.rename(oldfile, "#{file}.pdf")
  else
    print "Missing file #{oldfile} for file #{file}\n"
  end
end
