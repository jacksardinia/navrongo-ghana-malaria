clear
cls 

use "/Users/jacksardinia/Downloads/Malaria_final_dataset.dta"

generate heard=.

replace heard=1 if q53a==1

replace heard=2 if q53b==1
replace heard=3 if q53c==1
replace heard=4 if q53d==1
replace heard=5 if (q53e==1 |q53f==1)


tab heard 
 

label define heardlab 1"24hrs" 2"ACT" 3"ACT completion" 4"ITNs" 5"No message" 
label values heard heardlab




/*Creating variable for zones*/
gen _zone=.
replace _zone=1 if zone=="c"
replace _zone=2 if zone=="n"
replace _zone=3 if zone=="e"

label define location 1"Central" 2"North" 3"East"
label values _zone location

order _zone, a(location)
drop zone
rename _zone zone

tab zone


/* Replace Var for Water, generate SES and representative variables*/
tab q12
gen water=.
replace water=1 if q12=="Pipe water"
replace water=2 if q12=="Sachet water"
replace water=3 if q12=="Surface water"
replace water=4 if q12=="Dug well"
replace water=5 if q12=="Water from a Borehole"

gen waterOrig=water
recode water 1/2=1 min/max=0

/*Replace Var for Toilet, genenerate SES and representative variables*/
gen toilet=.
replace toilet=1 if q13=="Own Flush Toilet"
replace toilet=2 if q13=="Shared Flush Toilet"
replace toilet=3 if q13=="Own traditional pit toilet"
replace toilet=4 if q13=="Shared traditional toilet"
replace toilet=5 if q13=="Own ventilated improved latrine"
replace toilet=6 if q13=="Shared ventilated improved latrine"
replace toilet=7 if q13=="Bucket/pan"
replace toilet=8 if q13=="No facility/ Bush/ Field"

gen toiletOrig= toilet
recode toilet 1/2=1 min/max=0  

/*Replace variable for floor, genenerate SES and representative variables*/
gen trash=.
replace trash=1 if q14=="Buried by the household"
replace trash=2 if q14=="Burned by the household"
replace trash=3 if q14=="Dump elsewhere"
replace trash=4 if q14=="Dump into Public Containers"
replace trash=5 if q14=="Public Dump"

gen trashOrig= trash
recode trash 4/5=1 min/max=0

/*Replace variable for floor, genenerate SES and representative variables*/
gen floor=.
replace floor=1 if q15=="Mud/Sand/Gravel"
replace floor=2 if q15=="Sand/Gravel/Muc mixed with dung"
replace floor=3 if q15=="wood planks"
replace floor=4 if q15=="Finished floor (polished wood)"
replace floor=5 if q15=="Finished floor (cement)"
replace floor=6 if q15=="Finished floor (carpet)"

gen floorOrig=floor
recode  floor  4/6=1 min/max=0  

/*Replace variable for roof, genenerate SES and representative variables*/
gen roof=.
replace roof=1 if q16=="Mud roof"
replace roof=2 if q16=="Grass/Thatch"
replace roof=3 if q16=="Iron sheets/ Zinc"
replace roof=4 if q16=="Tiles"
replace roof=5 if q16=="Other"

gen roofOrig=roof
recode roof 4/6=1 min/max=0

/*Replace variable for wall, genenerate SES and representative variables*/
gen wall=.
replace wall=1 if q17=="Bricks (mud)"
replace wall=2 if q17=="Cement blocks"
replace wall=3 if q17=="Ironsheets (zinc)"

gen wallOrig= wall
recode wall 2=1 min/max=0

sum wall
/*Replace variable for cooking fuel (cfuel), genenerate SES and representative variables*/
tab q118
gen cfuel=.
replace cfuel=1 if q118=="Kerosene"
replace cfuel=2 if q118=="gas"
replace cfuel=3 if q118=="electricity"
replace cfuel=4 if q118=="charcoal"
replace cfuel=5 if q118=="firewood"

gen fuelOrig= cfuel
recode cfuel 2/3=1 min/max=0

tab cfuel
/*Replace variable for light, genenerate SES and representative variables*/

gen light=.
replace light=1 if q19=="Kerosene"
replace light=2 if q19=="Gas"
replace light=3 if q19=="Electricity"
replace light=4 if q19=="Solar"
replace light=5 if q19=="Flashlight"
replace light=6 if q19=="firewood"
replace light=7 if q19=="Other"

gen lightOrig= light
recode light 3/4=1 min/max=0

/*Replace variable for land, genenerate SES and representative variables*/
gen land=.
replace land=1 if q21=="Landlord"
replace land=2 if q21=="Public/Government Land"
replace land=3 if q21=="Self/ Family owned"
replace land=4 if q21=="Other"
replace land=5 if q21=="Don't know"

gen landOrig= land
recode land 3=1 min/max=0

/*Replace variable for tenure of land, genenerate SES and representative variables*/

gen tenure=.
replace tenure=1 if q22=="Purchased"
replace tenure=2 if q22=="(owned) Constructed"
replace tenure=3 if q22=="(owned) Inherited"
replace tenure=4 if q22=="Rented from an individual"
replace tenure=4 if q22=="rented from Government"
replace tenure=5 if q22=="a"
replace tenure=5 if q22=="b"
replace tenure=6 if q22=="c"
replace tenure=7 if q22=="d"
replace tenure=8 if q22=="e"
replace tenure=9 if q22=="f"
replace tenure=10 if q22=="g"
replace tenure=11 if q22=="h"

gen tenureOrig= tenure
recode tenure 1/3=1 min/max=0



/*Replace variable for bednet, genenerate SES and representative variables*/
tab q46
gen bednet=.
replace bednet=1 if q46>0 
replace bednet=2 if q46==0



rename q46 Bednets
tab Bednets
tab q45
gen bedusage= Bednets/q45
tab bedusage
sum bedusage
/*Renaming q11a-q11s*/
rename q11a car
rename q11b motor
rename q11c tractor
rename q11d bike
rename q11e electric
rename q11f refriger
rename q11g television
rename q11h radio
rename q11i sew
rename q11j iron
rename q11k dcart
rename q11l kerostov
rename q11m computer
rename q11n phone
rename q11o dvd
rename q11p egasstove
rename q11q fan
rename q11r solar
rename q11s grindmil

pca    land toilet roof wall cfuel light car motor bike kerostov electric solar refriger dvd radio sew iron fan phone egasstov dcart tractor grindmil tenure bednet  computer 
predict f1

xtile index=f1,nq(5)

label define index 1 "Poorest" 2 "Poorer" 3"Poor" 4"Less poor" 5 "Least poor"
lab val index index

/*tab for SES frequencies of specified household aspects*/
tab index, summarize (wall)
tab index, summarize (toilet)
tab index, summarize (trash)
tab index, summarize (floor)
tab index, summarize (roof)
tab index, summarize (cfuel)
tab index, summarize (light)
tab index, summarize (land)
/*variable names*/
rename q1 Children
rename q2 Ethnicity
rename q3 Age
rename q4 Size
rename q5 Insurance
rename q6 Femedu
rename q7 Fememploy
rename q8 Relstatus
rename q9 Malemploy
rename q10 Maledu
rename q12 Water
rename q13 Humwaste
rename q14 Trash
rename q15 Floor
rename q16 Roof
rename q17 Walls
rename q19 Lighting
rename q20 Cooklocale
rename q21 Landown
rename q22 Homeown
rename q23 Phones
rename q24a shaking
rename q24b feveryn
rename q24c sweating
rename q24d headache
rename q24e nausea
rename q24f vomiting
rename q24g diarrhea
rename q24h anemia
rename q24i infwounds
rename q24j noeat
rename q24k unsure
rename q24l musclepain
rename q24m convulsions
rename q24n bloodystools
rename q24o swelling 
rename q24p breathlessness
rename q24q cough
rename q24r coughingblood
rename q24s yellow 
rename q24t floppy
rename q24u other
rename q25a Shaking
rename q25b Feveryn
rename q25c Sweating
rename q25d Headache
rename q25e Nausea
rename q25f Vomiting
rename q25g Diarrhea 
rename q25h Anemia
rename q25i Wounds
rename q25j Noeat
rename q25k Unsure
rename q25l Musclepain
rename q25m Convulsions
rename q25n Bloodystools
rename q25o Swelling 
rename q25p Breathlessness
rename q25q Cough
rename q25r Coughingblood
rename q25s Yellow 
rename q25t Floppy
rename q25u Other
rename q26 Fever
 
 /*tab for serious symptoms*/
tab Shaking
tab Feveryn
tab Sweating
tab Headache
tab Nausea
tab Vomiting
tab Diarrhea 
tab Anemia
tab Wounds
tab Noeat
tab Unsure
tab Musclepain
tab Convulsions
tab Bloodystools
tab Swelling 
tab Breathlessness
tab Cough
tab Coughingblood
tab Yellow 
tab Floppy
tab Other
tab Fever

 /*clean up Age*/
gen age= real(Age)
drop Age
order age, b(Size)
recode age 88=.
tab age
sum age


/*find odds ratio of all symptoms*/
tab shaking 
tab feveryn
tab sweating
tab headache
tab nausea
tab vomiting
tab diarrhea 
tab anemia
tab infwounds
tab noeat
tab unsure
tab musclepain
tab convulsions
tab bloodystools
tab swelling 
tab breathlessness
tab cough
tab coughingblood
tab yellow 
tab floppy
tab other

 
 /*create and use yesno label for feveryn, etc...*/
 label define yesno 0"No" 1"Yes"
 label values feveryn yesno
 label values headache yesno
 /*SES table analysis*/
tab index
tab Ethnicity
tab Femedu
tab Fememploy
tab Relstatus
tab Maledu
tab Malemploy

/* First symptom recongition analysis*/
rename q27a mother
rename q27b father
rename q27c grandma
rename q27d patgrandma
rename q27e sister
rename q27f aunt
rename q27g otherper
rename q27h healthworker

recode mother 88=.
recode father 88=.
recode grandma 88=.
recode patgrandma 88=.
recode sister 88=.
recode aunt 88=.
recode otherper 88=.
recode healthworker 88=.

tab mother
tab father
tab grandma
tab patgrandma
tab sister
tab aunt
tab otherper
tab healthworker

/*treatment at home*/
rename q30a drugs
rename q30b herbs
rename q30c spiritual
rename q30d none

recode drugs 88=.
recode herbs 88=.
recode spiritual 88=.
recode none 88=.

tab drugs 
tab herbs
tab spiritual
tab none
 /*clean up Children*/
 tab Children
 sum Children
 /*generate wrong sympotom recognition*/
 gen falsesympt=.

replace falsesympt=0 if (shaking==1 | feveryn==1 | sweating==1 | headache==1 | nausea==1 | vomiting==1 |diarrhea==1 |musclepain==1 |bloodystools==1)
replace falsesympt=1 if (infwounds==1 | convulsions==1 | swelling==1 | breathlessness==1 | cough==1 | coughingblood==1 |yellow==1)
label define false 1"False symptom recongnition" 0"Proper recognition"
label value falsesympt false
 
 tab falsesympt
 
 /*clean up Ethnicity*/
 gen ethnicity=.
 replace ethnicity=1 if Ethnicity=="Kassena"
 replace ethnicity=2 if Ethnicity=="Nankani"
 replace ethnicity=3 if Ethnicity=="Other"
 
 label define speak 1"Kassena" 2"Nankani" 3"Other"
 label values ethnicity speak
 drop Ethnicity
 
 


/*clean up Insurance*/
gen insurance= real(Insurance)
drop Insurance
order insurance, b(Femedu)
 
/*clean up Femedu*/
gen femedu=.
replace femedu=0 if Femedu=="None"
replace femedu=1 if Femedu=="Primary"
replace femedu=2 if Femedu=="Secondary"
replace femedu=3 if Femedu=="Tertiary"

label define edu 0"None" 1"Primary" 2"Secondary" 3"Tertiary"
label values femedu edu
drop Femedu
order femedu, b(Fememploy)
tab femedu
sum femedu

/*clean up Fememploy*/
gen fememploy=.
replace fememploy=0 if Fememploy=="None"
replace fememploy=1 if Fememploy=="Farmer"
replace fememploy=2 if Fememploy=="Craftsmanship"
replace fememploy=3 if Fememploy=="Student"
replace fememploy=4 if Fememploy=="White collar/Office worker"
replace fememploy=5 if Fememploy=="Trading"
replace fememploy=6 if Fememploy=="Other"

label define employ 0"None" 1"Farmer" 2"Craftsmanship" 3"Student" 4"White collar/Office worker" 5"Trading" 6"Other"
label values fememploy employ
drop Fememploy 
order fememploy, b(Relstatus)
tab fememploy
sum fememploy

gen fememploycat=fememploy
recode fememploycat 3/4=1 min/max=0
label define skills 0"Unskilled" 1"Skilled"
label values fememploycat skills


/*clean up Relstatus*/
gen relstatus=.
replace relstatus=1 if Relstatus=="Married"
replace relstatus=2 if Relstatus=="Single/not married"
replace relstatus=3 if Relstatus=="Separated/divorced"
replace relstatus=4 if Relstatus=="Widowed/widower"

label define marriage 1"Married" 2"Single/not married" 3"Separated/divorced" 4"Widowed/widower"
label values relstatus marriage
drop Relstatus
order relstatus, b(Malemploy)
tab relstatus
sum relstatus

gen relstatuscat=relstatus
recode relstatuscat 1=1 min/max=0
label define love 0"Alone" 1"married" 
label values relstatuscat love
 

/*clean up Malemploy*/
gen malemploy=.
replace malemploy=0 if Malemploy=="None"
replace malemploy=1 if Malemploy=="Farmer"
replace malemploy=2 if Malemploy=="Craftsmanship"
replace malemploy=3 if Malemploy=="Student"
replace malemploy=4 if Malemploy=="White collar/Office worker"
replace malemploy=5 if Malemploy=="Trading"
replace malemploy=6 if Malemploy=="Other"

label values malemploy employ
drop Malemploy
order malemploy, b(Maledu)
tab malemploy
sum malemploy

gen malemploycat=malemploy
recode malemploycat 3/4=1 min/max=0
label values malemploycat skills


/*clean up Maledu*/
gen maledu=.
replace maledu=0 if Maledu=="None"
replace maledu=1 if Maledu=="Primary"
replace maledu=2 if Maledu=="Secondary"
replace maledu=3 if Maledu=="Tertiary"
label values maledu edu
drop Maledu
order maledu, b(car)

/*clean up car*/

 /*clean up fever*/
 gen fever=.
 replace fever=0 if Fever=="No"
 replace fever=1 if Fever=="Yes"
 drop Fever
 order fever, b(mother) 

 /*clean up reason*/
gen reason=.
replace reason=1 if q37=="I had probelms with my insurance card"
replace reason=2 if q37=="The place was nearby"
replace reason=3 if q37=="The symptoms were too severe to treat at home"
replace reason=4 if q37=="There is not a long waiting time"
replace reason=5 if q37=="There was free of cheap treatment" 
replace reason=6 if q37=="You have used this treatment in the past" 
replace reason=7 if q37=="You thought there would be an availability of drugs" 

label define reaslab 1"Insurance card" 2"Proximity" 3"Severity" 4"waiting time" 5"cheap" 6"used before" 7"drug availiability"
label values reason reaslab
drop q37
order reason, b(q38)

/*clean up transport*/
gen transport=.
replace transport=1 if q42=="Bicycle"
replace transport=2 if q42=="Motorcycle"
replace transport=3 if q42=="On foot"

label define translab 1"Bicycle" 2"Motorcycle" 3"On foot"
label values transport translab

drop q42
order transport, b(q43)

/*clean up net disposal*/
gen disposal=.
replace disposal=0 if q47=="No"
replace disposal=1 if q47=="Yes"

label define nettosslab 0"No" 1"Yes"
label values disposal nettosslab

drop q47
order disposal, b(q48)

/*clean up net time*/
gen nettime=.
replace nettime=1 if q48=="Less than 2 years"
replace nettime=2 if q48=="2-4 years"
replace nettime=3 if q48=="More than 4 years"

label define nettimelab 1"< 2 yrs" 2"2-4 yrs" 3">4 yrs"
label values nettime nettimelab

drop q48
order nettime, b(q49)

/*clean up reason for disposal*/
gen dispreas=.

replace dispreas=1 if q49=="Torn"
replace dispreas=2 if q49=="Got a new one"
replace dispreas=3 if q49=="Could not repel mosquitos"
replace dispreas=4 if q49=="Don't know"

label define dispreaslab 1"Torn" 2"Got a new one" 3"Could not repel" 4"Don't know"
label values dispreas dispreaslab

drop q49
order dispreas, b(q50)
tab dispreas
/* clean up means of possession*/
tab q50
gen recep=.
replace recep=1 if q50=="Handed out for free"
replace recep=2 if q50=="Purchased"

label define receplab 1"Handed out for free" 2"Purchased"
label values recep receplab

drop q50
order recep, b(q51)

/*clean up where they are treated*/
recode q36a 88=.
recode q36b 88=. 
recode q36c 88=.
recode q36d 88=.
recode q36e 88=.
recode q36f 88=.
recode q36g 88=.
recode q36h 88=.
recode q36i 88=.
recode q36j 88=.
recode q36k 88=.


tab q36a 
tab q36b  
tab q36c 
tab q36d 
tab q36e 
tab q36f 
tab q36g 
tab q36h 
tab q36i 
tab q36j 
tab q36k 

/*clean up IRS*/
gen IRS=.
replace IRS=0 if q51=="No"
replace IRS=1 if q51=="Yes"

label define IRSlab 0"No spraying" 1"House has been sprayed"
label values IRS IRSlab

drop q51
order IRS, b(q52a)

/*create comparison message*/
gen aware=.
replace aware=1 if q52a==1
replace aware=2 if q52b==1
replace aware=3 if q52c==1
replace aware=4 if q52d==1
replace aware=5 if q52e==1
replace aware=6 if q52f==1
replace aware=7 if q52g==1
replace aware=8 if q52h==1


label define awarelab 1"TV" 2"radio" 3"newspaper" 4"community voluteer" 5"Leaflets/brochure" 6"health worker" 7"poster" 8"relative"
label values aware awarelab
tab aware 
gen media=.
replace media=0 if (q52c==1 | q52d==1 | q52e==1 | q52f==1 | q52g==1 | q52h==1)
replace media=1 if (q52a==1 | q52b==1)






/*clean up 88's*/
recode q32 88=.
recode q35 88=.

 /*Drop excess*/
 drop var183 var184 var185 var186 var187

 
 /*tab for Socio-dem vs. vars freqeuncies */
 /*..vs falsesympt*/
tab falsesympt femedu, column row chi2
tab falsesympt index, column row chi2 
tab falsesympt relstatuscat, column row chi2 
tab falsesympt maledu, column row chi2 
tab falsesympt malemploycat, column row chi2
tab falsesympt fememploycat, column row chi2
/*..vs fever*/
tab feveryn femedu, column chi2
tab feveryn index, column chi2 
tab feveryn relstatuscat, column chi2 
tab feveryn maledu, column chi2 
tab feveryn malemploycat, column chi2
tab feveryn fememploycat, column chi2
/*..vs headache*/
tab headache femedu, column chi2
tab headache index, column chi2 
tab headache relstatuscat, column chi2 
tab headache maledu, column chi2 
tab headache malemploycat, column chi2
tab headache fememploycat, column chi2
/* .. vs time before (q35) and grouping of q35*/
tab q35 
sum q35

generate wait=q35
recode wait 0/1=0
recode wait 2/6=1

/*miscellaneous*/
tab wait index, column chi2
tab wait femedu, column chi2
tab wait relstatuscat, column chi2
tab wait maledu, column chi2
tab wait malemploycat, column chi2
tab wait fememploycat, column chi2


tab disposal index, column row chi2

tab nettime index, column row chi2
tab dispreas index, column row chi2
tab media index, column row chi2
tab q52f index, column row chi2

regress feveryn femedu index 
tab feveryn
tab headache
tab feveryn index, column row chi2

tab headache index, column row chi2
tab vomiting index, column row chi2
tab shaking index, column row chi2
tab musclepain index, column row chi2
tab anemia index, column row chi2


tab drugs index, column row chi2 /* "drugs" is drugs administered at home*/
tab none index, column row chi2  /*"none" is no treatment at home*/

 
tab q35 index, column row chi2

oneway q35 index, tab
order index, b(q35)

tab reason
tab IRS

tab fever
tab q33
recode q41a 88=.
recode q41b 88=.

tab nettime
tab dispreas
tab q35
tab q40
tab q41a
tab q41b
tab q41c
tab q41d
tab q41e
tab q41f
tab q41g
tab q41h
tab q41i
tab q41j

tab q41a index, column row chi2
tab q41b index, column row chi2

tab Water
 
tab headache index, column row
tab feveryn index, column row

