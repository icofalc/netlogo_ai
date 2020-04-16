breed [sedie sedia]
breed [persone persona]
breed [palchi palco]


globals [
  primo
  patch-data
]


persone-own
[
  seated? ;true se la persona è seduta, falsa altrimenti
]

sedie-own
[
  libero? ; proprietà della sedia, true se la sedia è libera, falsa altrimenti
]


to clear-everything
  clear-all
  reset-ticks
  print "reset dell'ambiente completato"
end

to crea-palco
  set primo true
  let conto-palchi (count palchi)

  if conto-palchi >= 0 [
    ask palchi [die]

    let palco-id 0
    create-palchi 1 [
      set color blue
      set palco-id who
      set xcor 0
      set ycor 16
      set heading 180
    ]

  ]

end

to prova-config1 ;spawn delle sedie configurazione 1
  clear-everything
  if numsedie < numpersone [
    ;print "non ci sono abbastanza sedie"
    user-message ("non ci sono abbastanza sedie disponibili per tali persone")
    clear-everything
    stop
  ]
crea-palco
crea-persone

foreach (range -14 16 2) [ x ->
  foreach (range 14 -16 -2)[ y ->
    create-sedie 1 [
        set libero? true
        ;set shape "arrow"
        set color yellow
        set xcor (- y)
        set ycor (- x)
        face one-of palchi

      ]

      if count sedie = numsedie [
        stop; se il numero di sedie e quello, allora esco
      ]
  ]
]
;per mettere in mezzo semplicemente ogni volta conto se la riga e arrivata a 30, verifico se ce la possibilita di metterna altri 30, se non ce allora li metto a partire dal mezzo

end



to prova-config2;sedia a parabola, spawn delle sedie
  clear-everything
  if numsedie2 < numpersone [
    ;print "non ci sono abbastanza sedie"
    user-message ("non ci sono abbastanza sedie disponibili per tali persone")
    clear-everything
    stop
  ]
crea-palco
crea-persone

foreach (range 12 -2 -4) [ z ->
  let j 1
    if count sedie >= numsedie2 [
        stop; se il numero di sedie e quello, allora esco
      ]
   create-sedie 1 [
        set libero? true
        ;set shape "arrow"
        set color yellow
        set xcor (0)
        set ycor (z)
        face one-of palchi

      ]

    foreach (range z 15 1) [
     i ->
      if count sedie >= numsedie2 [
        stop; se il numero di sedie e quello, allora esco
      ]
      create-sedie 1 [
        set libero? true
        ;set shape "arrow"
        set color yellow
        set xcor (j)
        set ycor (i + 1)
        face one-of palchi

      ]
      if count sedie >= numsedie2 [
        stop; se il numero di sedie e quello, allora esco
      ]
      create-sedie 1 [
        set libero? true
        ;set shape "arrow"
        set color yellow
        set xcor ( - j)
        set ycor (i + 1)
        face one-of palchi

      ]

      set j (j + 1)
      if count sedie >= numsedie2 [
        stop; se il numero di sedie e quello, allora esco
      ]

    ]


  ]

;per mettere in mezzo semplicemente ogni volta conto se la riga e arrivata a 30, verifico se ce la possibilita di metterna altri 30, se non ce allora li metto a partire dal mezzo

end



to crea-persone ;dato che le persone sono le ultime ad essere create, ogni persona individua la sedia più vicina al palco e la colora di verde

  create-persone numpersone[; quindi creo le persone
    set color red
    set shape "person"
    set seated? false
    set xcor -16
    set ycor -16
    face one-of palchi
  ]

end

to colora-sedia-vicina;la variante del programma e che ogni persona cerca la sedia immediatamente vicina e libera subito dopo la prima vicina gia occupata

  ;questo funziona
  if count sedie with [color = green and libero? = true] = 0 [
    let i 0
    while [count sedie with [color = green and libero? = true] = 0][;sto ciclo cicla finche non vengono colorate sedie
      ifelse i < 100 [;se per 100 volte non trova una sedia, prova a diminuire la repulsione alla linea 175
      print "wow"
        if repulsione < 0 [stop]
       set i (i + 1)
      prova;funzione che determina il prossimo da colorare di verde
      ][
        ifelse repulsione > 0 [set repulsione (repulsione - 1)
          if repulsione < 0 [ stop]
       set i 0
        colora-sedia-vicina][
        set repulsione (repulsione + 2)
       set i 0
        colora-sedia-vicina
        ]

      ]
      ]

  ]



end


to prova

  let nearest-neighbor one-of sedie with [libero? = true and color != green]; inusato ora


 ; ask one-of sedie with [libero? = true and color != green][
  ;  let cina (other sedie with [libero? = true and color != green] ) in-radius 3 ; devo selezionare quelle not in radius, ma devo trovare un modo per falro
   ; ask one-of cina [
    ;set color green
    ;]
  ;]

  ;;;;funziona
 ;let i 0
 ; while [i < 30000][
 ; ask one-of sedie with [libero? = true and color != green ][
 ;   if not any? other sedie with [color = green] in-radius repulsione [
 ;     set color green
 ;   ]
 ;
 ; ]
 ;   set i ( i + 1 )
 ; ]

 ; print count sedie with [color = green]
 ; prova-config1
  ;;;;funziona
  ifelse repulsione >= 0 [
  let candidati sedie with [libero? = true and color != green and not any? other sedie with [color = green] in-radius repulsione ];seleziono tutti i possibili candidati a distanza 3, da metterci anche se non voglio davanti nessuno
  let nearest-neighbora (min-one-of (other candidati) [distance one-of palchi]);seleziono il minimo e lo coloro

  carefully [
    ask nearest-neighbora [;qua va messo un carefully per diminuire la repulsione
    set color green
    ]
  ][

   set repulsione (repulsione - 1 )
    if repulsione < 0 [
    stop
    ]

  ]

  ][
  set repulsione 0
    stop
  ]



  ;ask nearest-neighbor [
  ;  set color green
  ;]
end



to check;condizione che funziona

  ;if [distance one-of sedie with [libero? = true]] of one-of sedie with [libero? = false]  >= repulsione [
   ;print "ciao"
 ; ]

  carefully [ask sedie with [libero? = true and color != green and distance (one-of sedie with [libero? = false]) = repulsione][
    set color green
  ]][
  if count sedie with [color = green and libero? = true] = 0 [;condizione fatta per colorare una sedia alla volta
    let nearest-neighbor ( min-one-of  (other sedie with [color != green])[ distance (one-of palchi)]);per ogni persona, individuo la sedia più vicina al palco e la coloro di verde

    ask nearest-neighbor [

      set color green

    ]
  ]
  ]


end


to go ;rimane solo un bug per la quale se vengono create due sedie troppo vicine, allora se si avvicina uno, le prende tutte e due

  if repulsione < 0 [stop]

  if not any? persone with [seated? = false];questo if parte se tutte le persone si sono sedute, rispettando il vincolo che ci siano i posti
    [stop]

  if count persone with [seated? = false] > 0 [;se il conteggio delle persone che non si sono ancora sedute è > 0 allora coloro ancora sedie
    colora-sedia-vicina
  ]

  ask one-of persone with [seated? = false][

    ;carefully [face one-of sedie with [color = green and libero? = true]
      ;fd 1
      ;questo è da cancellare

      ;if not any? turtles-on patch-ahead 1[

       ;ask patch-ahead 1 [ set pcolor red ]
      ;]

   ; ifelse (not any? neighbors with [count sedie with [color = green and libero? = true] = 0])[;se questo ritorna 1, allora significa che nelle vicinanze c'è una sedia
   ;   let nearest-neighbor min-one-of neighbors with [count turtles-on turtles-here = 0] [distance one-of sedie with [color = green and libero? = true]]
   ;   print "qua1"
   ;   carefully [face nearest-neighbor
   ;   fd 1
  ;    ][stop]
 ; ][
  ;carefully [face one-of sedie with [color = green and libero? = true]
   ;     print "qua"
   ;   fd 1][stop]
  ;]

    ifelse sum [count sedie-here with [color = green and libero? = true]] of neighbors > 0 [
      print "qua stanno"
      carefully [face one-of sedie with [color = green and libero? = true]

      fd 1][stop]
    ][
      print "qua non stanno"
      let nearest-neighbor min-one-of neighbors with [count turtles-on turtles-here = 0] [distance one-of sedie with [color = green and libero? = true]]
      carefully [face nearest-neighbor
      fd 1
      ][stop]
    ]




    let current-persona self
    ask sedie with [color = green and libero? = true and distance current-persona < 0.5 ][;da  mettere la distanza tra sedie una patch alla volta
      set libero? false
      set hidden? true

      ask current-persona [
        set seated? true
        face one-of palchi
      ]
    ]

  ]

end


to set-persona-down;procedura da capire che permette di far spawnare le persone alla pressione del mouse
  if mouse-down?
  [
    if count persone = count sedie [
      ;print "non puoi creare persone se non ci sono abbastanza sedie"
      user-message ("non puoi creare persone se non ci sono abbastanza sedie, continua con la simulazione")
      stop
    ]
    if timer > 0.5[
      ask patch (round mouse-xcor) (round mouse-ycor)
      [
        sprout-persone 1
        [
          setxy (round xcor) (round ycor)

          ;disegna sul display l'area coperta dal raggio (in trasparenza)
          set color red
          set shape "person"
          set seated? false
          if any? palchi [
            face one-of palchi
          ]


          ;face one-of palchi
        ]
      ]

    reset-timer
    ]


      ;stop

  ]
end


to salva-modello
  ;funzione salva mondo con export-world "filename.txt"

  let file user-new-file

  if ( file != false )
  [
     export-world file
  ]
end

to carica-modello
  ;funzione carica mondo con import-world "filename.txt"
  let file user-file

  if ( file != false )
  [
    import-world file
  ]
end



to set-sedia-down;procedura da capire che permette di far spawnare le persone alla pressione del mouse
  if mouse-down?
  [
    if timer > 0.5[
      ask patch (round mouse-xcor) (round mouse-ycor)
      [
        sprout-sedie 1
        [
          setxy (round xcor) (round ycor)

          ;disegna sul display l'area coperta dal raggio (in trasparenza)
          set libero? true
        ;set shape "arrow"
        set color yellow
          if any? palchi [
            face one-of palchi
          ]


          ;face one-of palchi
        ]
      ]

    reset-timer
    ]


      ;stop

  ]
end

to set-spawn-point
  if mouse-down?
  [
    if (count persone) + numpersone >= count sedie [
      ;print "non puoi creare persone se non ci sono abbastanza sedie"
      user-message ("non puoi creare persone se non ci sono abbastanza sedie, continua con la simulazione")
      stop
    ]
    if timer > 0.5[
      ask patch (round mouse-xcor) (round mouse-ycor)
      [
        sprout-persone numpersone
        [
          setxy (round xcor) (round ycor)

          ;disegna sul display l'area coperta dal raggio (in trasparenza)
          set color red
          set shape "person"
          set seated? false
          if any? palchi [
            face one-of palchi
          ]


          ;face one-of palchi
        ]
      ]

    reset-timer
    ]


      ;stop

  ]

end



to crea-persone-personale
  ifelse (count persone + numpersone) <= count sedie [
  crea-persone
  ][
  user-message ("non puoi creare persone se non ci sono abbastanza sedie, continua con la simulazione")
      stop
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
649
95
1394
842
-1
-1
17.82
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

SLIDER
29
202
201
235
numsedie
numsedie
30
225
225.0
1
1
NIL
HORIZONTAL

SLIDER
132
65
304
98
numpersone
numpersone
0
450
22.0
1
1
NIL
HORIZONTAL

BUTTON
40
517
129
550
Clear-all
clear-everything
NIL
1
T
OBSERVER
NIL
C
NIL
NIL
1

BUTTON
40
624
156
657
spawn-sim1
prova-config1
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
15
792
183
852
go
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
240
790
410
852
tick-by-tick
go
NIL
1
T
OBSERVER
NIL
T
NIL
NIL
1

BUTTON
235
629
351
662
spawn-sim2
prova-config2
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

SLIDER
237
202
409
235
numsedie2
numsedie2
0
76
76.0
1
1
NIL
HORIZONTAL

BUTTON
209
519
371
552
NIL
set-persona-down
T
1
T
OBSERVER
NIL
D
NIL
NIL
1

SLIDER
98
327
362
360
repulsione
repulsione
1
10
2.0
1
1
NIL
HORIZONTAL

TEXTBOX
95
17
373
50
Scelta numero persone
20
15.0
1

TEXTBOX
52
123
426
155
Numero sedie delle disposizioni
20
15.0
1

TEXTBOX
55
168
195
192
Disposizione 1
16
0.0
1

TEXTBOX
264
167
452
191
Disposizione 2
16
0.0
1

TEXTBOX
54
272
463
305
Scelta della repulsione tra spettatori
20
15.0
1

TEXTBOX
68
690
398
748
Comandi avvio simulazione
20
15.0
1

TEXTBOX
24
749
159
773
Avvio continuo
16
0.0
1

TEXTBOX
253
752
441
779
Passo per passo
16
0.0
1

TEXTBOX
73
395
446
429
Comandi spawn sedie e persone
20
15.0
1

TEXTBOX
13
473
190
497
Resetta simulatore
16
0.0
1

TEXTBOX
20
582
208
606
Spawn sedie disp 1
16
0.0
1

TEXTBOX
202
583
390
607
Spawn sedie disp 2
16
0.0
1

TEXTBOX
200
476
503
503
Disponi persona su tocco mouse
16
0.0
1

TEXTBOX
772
38
1354
82
Visualizzazione della simulazione
30
15.0
1

TEXTBOX
1473
49
1718
77
Carica - Salva Modello
20
15.0
1

BUTTON
1475
103
1719
161
Carica Modello
carica-modello
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1475
179
1718
239
Salva Modello
salva-modello\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1452
280
2001
316
Opzioni generazione mondo personalizzato
20
15.0
1

BUTTON
1488
350
1586
385
Crea palco
crea-palco
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1490
425
1620
460
set-sedia-down
set-sedia-down
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1489
486
1661
521
crea-persone-numero
crea-persone-personale
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1493
558
1611
593
Mostra griglie
ask patches [set pcolor random 10]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1660
560
1763
595
Leva griglia
ask patches [set pcolor 0]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1495
613
1728
648
Mostra conteggio sedie corrente
show count sedie
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
416
632
606
667
spawn persone personale
set-spawn-point
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
415
593
634
621
Spawn persone punto
15
66.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
