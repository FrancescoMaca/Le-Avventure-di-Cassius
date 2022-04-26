org 100h

.data
file_handle                     DW      ?

file_intro_path                 DB      'C:\menu\intro.dat', 0
file_menu_path                  DB      'C:\menu\menu.dat', 0
file_info_path                  DB      'C:\menu\info.dat', 0
file_exit_path                  DB      'C:\menu\exit.dat', 0   
file_settings_path              DB      'C:\menu\settings.dat', 0
file_character_path             DB      'C:\menu\character.dat', 0    
file_pause_path                 DB      'C:\menu\pause.dat', 0     
file_sentence_path              DB      'C:\menu\pause_sentences.dat', 0
file_global_map_path            DB      'C:\game\world_map.dat', 0
file_local_map_lerwick_path     DB      'C:\game\local_map_lerwick.dat', 0
file_saving                     DB      'C:\game\save.dat', 0

file_loading1_frm1_path         DB      'C:\menu\loading1_frm1.dat', 0
file_loading1_frm2_path         DB      'C:\menu\loading1_frm2.dat', 0
file_loading1_frm3_path         DB      'C:\menu\loading1_frm3.dat', 0
file_loading2_frm1_path         DB      'C:\menu\loading2_frm1.dat', 0
file_loading2_frm2_path         DB      'C:\menu\loading2_frm2.dat', 0
file_loading2_frm3_path         DB      'C:\menu\loading2_frm3.dat', 0
file_loading3_frm1_path         DB      'C:\menu\loading3_frm1.dat', 0
file_loading3_frm2_path         DB      'C:\menu\loading3_frm2.dat', 0
file_loading3_frm3_path         DB      'C:\menu\loading3_frm3.dat', 0

file_scroll_path                DB      'C:\game\scroll_empty.dat', 0
file_scroll_text_path           DB      'C:\game\story.dat', 0
file_you_died_path              DB      'C:\game\you_died.dat', 0
file_play_again_path            DB      'C:\game\play_again.dat', 0
file_dialogue_path              DB      'C:\game\dialogue.dat',0

file_prologue_scroll_path       DB      'C:\game\scroll_prologo.dat', 0
file_scene1_bar_path            DB      'C:\game\chapter0_bar.dat', 0
file_scene1_outside_bar_path    DB      'C:\game\chapter0_outside_bar.dat', 0
file_scene1_corn_path           DB      'C:\game\chapter0_corn.dat', 0
file_scene1_wall_path           DB      'C:\game\chapter0_wall.dat', 0       
file_scene1_drink_path          DB      'C:\game\chapter0_drink.dat', 0 
file_scene1_horse_path          DB      'C:\game\chapter0_horse.dat', 0
file_scene1_entrance_path       DB      'C:\game\chapter0_entrance.dat', 0
file_scene1_end_path            DB      'C:\game\chapter0_end.dat', 0

file_scene2_scroll_path         DB      'C:\game\scroll_chapter1.dat', 0  
file_scene2_wall_path           DB      'C:\game\chapter1_wall.dat', 0  
file_scene2_house_inside_path   DB      'C:\game\chapter1_house_inside.dat', 0     
file_scene2_forest_path         DB      'C:\game\chapter1_forest.dat', 0
file_scene2_forest_house_path   DB      'C:\game\chapter1_house.dat', 0
file_scene2_before_house_path   DB      'C:\game\chapter1_before_house.dat', 0
file_scene2_after_house_path    DB      'C:\game\chapter1_after_house.dat', 0
file_scene2_horse_path          DB      'C:\game\chapter1_horse.dat', 0
file_scene2_cap_path            DB      'C:\game\chapter1_camp.dat', 0
file_scene2_runswick_path       DB      'C:\game\chapter1_outside_runswick.dat', 0
file_scene2_end_path            DB      'C:\game\chapter1_end.dat', 0
               
file_buffer_empty               DB      1945d dup(' ')
file_buffer                     DB      1945d dup(0)   ; crea un buffer per la grafica
file_frame_size                 DW      1945d
line_scroll_size                DW      62d
line_chat_size                  DW      52d

line_chat_buffer                DB      52d dup(0)
line_empty_buffer               DB      52d dup(' ')
line_scroll_buffer              DB      62d dup(' ')

text_X                          DB      2d       ; column (Y)
text_Y                          DB      18d      ; row (X)

; -- game variables --
karma                           DB      0h 
color                           DB      0000_1110b
scelta                          DB      ?
current_checkpoint              DB      1

entity_guard                    DB      'Guardia'
entity_nicolas                  DB      'Sconosciuto' 
entity_muireach                 DB      'Muireach'
entity_dead_body                DB      'Cadavere'

game_saved                      DB      "La partita e' stata salvata", '$' 
game_loaded                     DB      "La partita e' stata caricata", '$' 


; tick (1s = 18tick)

error_file_notfound             DB      'Il file non e stato trovato!','$'
error_file_denied               DB      'Il programma non ha abbastanza permessi al file!','$'   
error_file_notauth              DB      'Il file non esiste piu per essere eliminato','$'
error_file_generic              DB      'Il file ha avuto problemi ad aprirsi!','$'
error_buffer_generic            DB      "C'e' stato un errore con il buffer grafico!",'$'
error_choice_currupt            DB      "C'e' stato un problema con la scelta fatta!", '$'
.code

;
; Entry point
;
main proc

; ---- Impostazioni di precaricamento del gioco ----
    mov ch, 20h                                               ; imposta il 5o bit a 1 per nascondere il cursore
    mov ah, 1h                                                ; nasconde la visibilita del cursore
    int 10h
      
; ---- Stampa l'intro del gioco ----
    
    ; -- apro il file dell'intro  --
    mov si, offset file_intro_path                            ; mette l'indirizzo del nome del file nel registro si
    mov di, 0h                                                ; mette la modalita di apertura del file nello stack
    call open_file                                            ; passandolo alla funzione per aprire il file
    
    ; -- carico il buffer --
    
    mov si, offset file_buffer                                ; sposta l'indirizzo del buffer per caricarlo in ram
    mov di, file_frame_size                                   ; mette in DI la grandezza del frame
    call load_frame                                           ; carica il file in ram
    
    ; -- stampa il buffer --  
    call print_frame                                          ; stampa il buffer a schermo 
    
    ; -- chiudo il file dell intro --
    call close_file                                           ; chiude il file 

    call gameload                                             ; carica tutte le finestre riguardanti il gioco nelle
                                                              ; varie pagine del DOS
    
; ---- Stampa il menu del gioco ----
    game_req:: 
        
        mov ah, 2h                                            ; resetta il cursore alla sua posizione iniziale
        mov dl, 0h                                            ; coordinate
        mov dh, 24h
        mov bh, 0h                                            ; numero pagina
        int 10h
        
        
        ; -- apre il file del menu principale --
        
        mov si, offset file_menu_path                         ; passa l'indirizzo del nome del file alla procedura
        mov di, 0h                                            ; mette la modalita di apertura del file nello stack
        call open_file                                        ; apre il file messo nello stack
        
        ; -- carico il buffer --                                          
        
        mov si, offset file_buffer                            ;  spsota il buffer del file in dx per stamparlo 
        mov di, file_frame_size
        call load_frame                                       ; carica il frame in ram
        
        ; -- chiudo il file del menu --
        call close_file                                       ; chiude il file
        
        ; -- cambia la pagina a quella usata nel menu (0)
        mov al, 0h
        call switchto
        
        ; -- stampo il buffer --
        call print_frame                                      ; stampa il buffer a schermo con animazione 
        
        
        ; -- scelta del menu --
                                                              ; inizio switch
        invalid_key:
            mov bx, 0h
            call getkey
                                                                  
            cmp al, 'e'                                           ; se la lettera = 'e' allora esci dal gioco
            je game_exit   
            inc bx                                                ; incrementa bx per controllare se il tasto e' uguale o no
            
            cmp al, 'g'                                           ; se la lettera = 'g' allora inizia una partita
            je game_play                                          
            inc bx
            
            cmp al, 'i'                                           ; se la lettera = 'i' allora va alle impostazioni
            je game_settings
            inc bx
            
            cmp al, 'c'                                           ; se la lettera = 'c' allora apre le impostazioni di gioco
            je game_htp                                           
            inc bx
            
            cmp bx, 4h
            je invalid_key                                        ; se l utente ha sbagliato x volte dove x e' il numero di
                                                                  ; scelte possibili, allora ripulisce il buffer della 
                                                                  ; tastiera e richiede il codice
            
        game_exit:
            
            ; -- apro il file --
            
            mov si, offset file_exit_path                         ; passo alla procedura l'indirizzo del path
            mov di, 0h                                            ; passo anche la modalita di lettura
            call open_file
            
            ; -- carica il frame in ram --
            
            mov si, offset file_buffer                            ; sposta l'indirizzo del buffer in si
            mov di, file_frame_size
            call load_frame                  
            
            ; -- chiudo il file del menu --
            call close_file
            
            ; -- stampa il frame a schermo --
            call print_frame                                      ; stampa il buffer a schermo con animazione
            
            mov si, 36d                                           ; il programma si chiude automaticamente dopo 2 secondi
                                                                  ; (36 tick)
            call timer
            
            int 20h                                               ; esce dal programma
            
        game_htp:
            
            ; -- apro il file --
            
            mov si, offset file_info_path                         ; passo alla procedura l'indirizzo del path
            mov di, 0h                                            ; passo anche la modalita di lettura
            call open_file
            
            ; -- carica il frame in ram --
            
            mov si, offset file_buffer                            ; sposta l'indirizzo del buffer in SI
            mov di, file_frame_size                               ; sposta in DI la grandezza del buffer
            call load_frame                  
            
            ; -- chiudo il file del menu --
            call close_file 
            
            ; -- stampa il frame a schermo --
            call print_frame                                      ; stampa il buffer a schermo con animazione
            
            call getkey                                           ; aspetta un input dell utente

            jmp game_req
        game_settings:
            
            ; -- apro il file --
            
            mov si, offset file_settings_path                     ; apre il file delle impostazioni
            mov di, 0h
            call open_file
            
            ; -- carica il frame del file -- 
            
            mov si, offset file_buffer                            ; sposta l'indirizzo del buffer in SI
            mov di, file_frame_size                               ; sposta in DI la grandezza del buffer
            call load_frame 
            
            ; -- chiude il file --
            call close_file                                       ; chiude il file
            
            ; -- stampa il frame a schermo --
            call print_frame 
            
            game_settings_choice:
                mov ah, 2h                                    ; ripristina il cursore all inizio del file
                mov dh, 0h 
                mov dl, 0h                                   
                int 10h
                    
                call getkey
                
                cmp al, 'r'
                je game_settings_colorchange
                cmp al, 'g'
                je game_settings_colorchange
                cmp al, 'b'
                je game_settings_colorchange
                cmp al, 'v'
                je game_settings_colorchange
                cmp al, 'e'
                je game_req
                cmp al, 's'
                je game_settings_save_exit
                jmp game_settings_choice
                
                game_settings_colorchange:
                    push ax
                    
                    mov ch, 6d                                    ; imposta la coordinata della colonna della prima scelta
                    mov cl, 8d                                    ; imposta la coordinata della riga della prima scelta
                    mov bl, ' '                                   ; imposta il carattere vuoto  
                    mov bh, 0h                                    ; imposta la prima pagina come target
                    call writecharat
                    
                    mov ch, 24d                                   ; imposta la coordinata della colonna della seconda scelta                                             
                    mov cl, 8d                                    ; imposta la coordinata della riga della seconda scelta
                    mov bl, ' '                                   ; imposta il carattere vuoto
                    mov bh, 0h                                    ; imposta la prima pagina come target
                    call writecharat
                    
                    mov ch, 45d                                   ; imposta la coordinata della colonna della terza scelta
                    mov cl, 8d                                    ; imposta la coordinata della riga della terza scelta
                    mov bl, ' '                                   ; imposta il carattere vuoto
                    mov bh, 0h                                    ; imposta la prima pagina come target
                    call writecharat
                    
                    mov ch, 61d                                   ; imposta la coordinata della colonna della quarta scelta
                    mov cl, 8d                                    ; imposta la coordinata della riga della quarta scelta
                    mov bl, ' '                                   ; imposta il carattere vuoto
                    mov bh, 0h                                    ; imposta la prima pagina come target
                    call writecharat
                    
                    pop ax
                    cmp al, 'r'                                   ; dopo aver pultio le scelte controlla quale scelta ha
                    je game_settings_magenta                      ; fatto l utente
                    cmp al, 'g'
                    je game_settings_yellow
                    cmp al, 'b'
                    je game_settings_blue
                    cmp al, 'v'
                    je game_settings_green
                    
                    game_settings_magenta:
                    
                        mov ch, 6d                                    ; imposta la coordinata della colonna della prima scelta
                        mov cl, 8d                                    ; imposta la coordinata della riga della prima scelta
                        mov bl, '>'                                   ; imposta la freccietta  
                        mov bh, 0h                                    ; imposta la prima pagina come target
                        call writecharat
                        
                        mov cl, 0dh
                        jmp game_settings_choice
                    game_settings_yellow:
                       
                        mov ch, 24d                                   ; imposta la coordinata della colonna della seconda scelta                                             
                        mov cl, 8d                                    ; imposta la coordinata della riga della seconda scelta
                        mov bl, '>'                                   ; imposta il carattere vuoto
                        mov bh, 0h                                    ; imposta la prima pagina come target
                        call writecharat
                    
                    
                        mov cl, 0eh
                        jmp game_settings_choice
                    game_settings_blue:
                    
                        mov ch, 45d                                   ; imposta la coordinata della colonna della terza scelta
                        mov cl, 8d                                    ; imposta la coordinata della riga della terza scelta
                        mov bl, '>'                                   ; imposta il carattere vuoto
                        mov bh, 0h                                    ; imposta la prima pagina come target
                        call writecharat
                       
                        mov cl, 9h
                        jmp game_settings_choice
                    game_settings_green:
                        
                        mov ch, 61d                                   ; imposta la coordinata della colonna della quarta scelta
                        mov cl, 8d                                    ; imposta la coordinata della riga della quarta scelta
                        mov bl, '>'                                   ; imposta il carattere vuoto
                        mov bh, 0h                                    ; imposta la prima pagina come target
                        call writecharat
                    
                        mov cl, 0ah
                        jmp game_settings_choice
                                              
                game_settings_save_exit:
                mov color, cl
                jmp game_req
                
        game_play:                                          

                                                              
            mov si, offset file_character_path                ; sposta l'indirizzo di memoria del nome del file in SI
            mov di, 0h                                        ; imposta la modalita lettura del file
            call open_file                                    ; apre il file
            
            mov si, offset file_buffer                        ; sposta in SI l'indirizzo del buffer 
            mov di, file_frame_size                           ; inserisce la grandezza del buffer
            call load_frame                                   ; carica DI caratteri nel buffer passato in SI
            
            ; -- chiudo il file del menu --
            call close_file 
            
            ; -- stampa il frame a schermo --            
            call print_frame                                  ; stampa il buffer utilizzando l'interrupt 21/9 per cui sembra
                                                              ; che sia animato
            
           ; jmp game_req
            game_face_choice:                                 ; richiede il tipo di faccia al giocatore
                                                              ; pulisce i possibili caratteri dello schermo con la frecca di
                                                              ; selezione
                mov karma, 0h                                 ; resetta il karma
                
                mov ch, 3d                                    ; imposta la coordinata della colonna della prima scelta
                mov cl, 4d                                    ; imposta la coordinata della riga della prima scelta
                mov bl, ' '                                   ; imposta il carattere vuoto  
                mov bh, 0h                                    ; imposta la prima pagina come target
                call writecharat
                
                mov ch, 21d                                   ; imposta la coordinata della colonna della seconda scelta                                             
                mov cl, 4d                                    ; imposta la coordinata della riga della seconda scelta
                mov bl, ' '                                   ; imposta il carattere vuoto
                mov bh, 0h                                    ; imposta la prima pagina come target
                call writecharat
                
                mov ch, 39d                                   ; imposta la coordinata della colonna della terza scelta
                mov cl, 4d                                    ; imposta la coordinata della riga della terza scelta
                mov bl, ' '                                   ; imposta il carattere vuoto
                mov bh, 0h                                    ; imposta la prima pagina come target
                call writecharat
                
                mov ch, 57d                                   ; imposta la coordinata della colonna della quarta scelta
                mov cl, 4d                                    ; imposta la coordinata della riga della quarta scelta
                mov bl, ' '                                   ; imposta il carattere vuoto
                mov bh, 0h                                    ; imposta la prima pagina come target
                call writecharat
                
                mov ah, 2h                                    ; ripristina il cursore all inizio del file
                mov dh, 0h 
                mov dl, 0h                                   
                int 10h
    
                call getkey                                   ; aspetta la scelta dell'utente
                                          
                cmp al, 31h
                je game_face_1
                
                cmp al, 32h
                je game_face_2 
                
                cmp al, 33h
                je game_face_3 
                
                cmp al, 34h
                je game_face_4
                
                cmp al, 8h                                    ; fa si che se si preme il tasto indietro o
                je game_req                                   ; il tast ESC torni nel menu principale
                cmp al, 27d
                je game_req
                
                jmp game_face_choice                          ; finche l utente non da una scelta valida continua a ciclare
               
                game_face_1:
                
                add karma, 1h                                 ; se scegli una persona tra 30-50 anni aumenta il
                mov dl, karma                                 ; karma di 1 punto e salva il karma in dl
                                                              
                                                              ; disegna la scelta che hai appena fatto
                mov ch, 3d                                    ; imposta il valore della riga
                mov cl, 4d                                    ; colonne
                mov bl, 'v'                                   ; carattere da scrivere
                call writecharat
  
                jmp game_face_end
                                                              
                game_face_2:
                
                add karma, 1h                                 ; se scegli una persona tra 30-50 anni aumenta il
                mov dl, karma                                 ; karma di 1 punto e salva il karma in dl

                mov ch, 21d                                   ; cancella tutte le altre possibili scelte                                              
                mov cl, 4d                                    ; colonne
                mov bl, 'v'
                call writecharat
                
                jmp game_face_end
                
                game_face_3:
                
                add karma, 2h                                 ; se scegli il vecchio aumenta il karma di 2 punti                
                mov dl, karma                                 ; salva il karma in dl
                
                mov ch, 39d 
                mov cl, 4d                                    ; colonne
                mov bl, 'v'
                call writecharat

                jmp game_face_end
                
                game_face_4:                                  ; nel caso tu scelga il giovane ( meno di 20 anni ) non 
                                                              ; ha nessuno punto karma in piu degli altri
                mov dl, karma                                 ; salva il karma in dl
                
                mov ch, 57d                                   ; colonne
                mov cl, 4d
                mov bl, 'v'                                   ; carattere da scrivere
                call writecharat
                
                game_face_end:
                
            game_alingment_choice:                            ; cancella tutte le scelte fatte in precedenza
                mov karma, dl                                 ; ripristina il karma a com'era evitando il karma-farming nel
                                                              ; menu
                mov ch, 3d                                    ; imposta le coordinate della prima riga
                mov cl, 14d                                   ; imposta le coordinate della pirma colonna da cancellare
                mov bl, ' '                                   ; carattere da scrivere
                call writecharat
                
                mov ch, 28d                                   ; imposta le coordinate della seconda riga                                               
                mov cl, 14d                                   ; imposta le coordinate della seconda colonna da cancellare
                mov bl, ' '                                   ; carattere da scrivere
                call writecharat
                
                mov ch, 56d                                   ; imposta le coordinate della terza riga
                mov cl, 14d                                   ; imposta le coordinate della terza colonna da cancellare
                mov bl, ' '                                   ; carattere da scrivere
                call writecharat
                
                call getkey
                                          
                cmp al, 31h
                je game_alingment_1
                cmp al, 32h
                je game_alingment_2
                cmp al, 33h
                je game_alingment_3 
                cmp al, 8h
                je game_face_choice
                
                game_alingment_1:
                mov ch, 3d                                    ; imposta le coordinate della prima riga
                mov cl, 14d                                   ; imposta le coordinate della pirma colonna da cancellare
                mov bl, 'v'                                   ; carattere da scrivere
                call writecharat
                
                add karma, 1h
                jmp game_alingment_choice_end
                
                game_alingment_2:
                mov ch, 28d                                   ; imposta le coordinate della seconda riga                                               
                mov cl, 14d                                   ; imposta le coordinate della seconda colonna da cancellare
                mov bl, 'v'                                   ; carattere da scrivere
                call writecharat
                
                add karma, 4
                jmp game_alingment_choice_end
                
                game_alingment_3:
                mov ch, 56d                                   ; imposta le coordinate della terza riga
                mov cl, 14d                                   ; imposta le coordinate della terza colonna da cancellare
                mov bl, 'v'                                   ; carattere da scrivere
                call writecharat
                
                add karma, 7h
                jmp game_alingment_choice_end
                
                game_alingment_choice_end:            
            
            game_confirm_character:
                
                call getkey    
                
                cmp al, 8h
                je game_alingment_choice
                
                cmp al, 'c'
                je game_confirm_character_end
                
                jmp game_confirm_character
                
           game_confirm_character_end:   
           
    ; -- Stampa pergamena Prologo --
    mov al, 5h    
    call switchto                                      ; va alla pagina 5 (vedi gameload)
    
    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_prologue_scroll_path           ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
    call print_frame_at
    
    mov cl, 0h
    call printstory                                    ; stampa la storia della pergamena 
    
    call getkey 
    
    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_prologue_scroll_path           ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
    call print_frame_at                                ; stampa il buffer nella pagina selezionata                                                      
    
    mov cl, 17d
    call printstory
       
    ; -- Stampa scena caricamento Prologo --
    
    call setloadingscreen                              ; mostra la schermata di caricamento
    
    ; -- Stampa scena Prologo (Capitolo 1) --

    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_scene1_bar_path                ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 3h                                         ; imposta 3h come pagina di destinazione per la stampa
    call print_frame_at                                ; stampa il buffer nella pagina selezionata                 
    
    mov dh, 8d                                         ; coloro il personaggio nel bar
    mov dl, 33d
    mov bl, color
    call colorchar   
    
    mov dh, 19d
    mov dl, 55d
    mov bl, color
    call colorchar
    
    mov al, 3d
    call switchto    
        
    mov di, 1d 
    mov si, 5d   
    call printchat      
    call getaction                                     ; getaction e' un manager dei tasti premuti, quindi si potra procedere
    call clearchat                                     ; con il codice solo quando si preme un tasto che non fa una funzione
                                                       ; speciale
    mov di, 5d 
    mov si, 9d   
    call printchat
    call getaction
    call clearchat
    
    ; -- Stampa scena Prologo --
    mov al, 3d
    call switchto
    
    mov di, 9d 
    mov si, 14d   
    call printchat
    call getkey
    call clearchat
    
    mov di, 14d 
    mov si, 17d   
    call printchat 
    call getkey 
     
    game_checkpoint1::
    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_scene1_outside_bar_path        ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 3h                                         ; imposta 5h come pagina di destinazione per la stampa
    call print_frame_at                                ; stampa il buffer nella pagina selezionata 
                              
    mov al, 3d
    call switchto                                      ; Tona alla UI principale (03)                                                      

    mov dh, 10d                                        ; coloro il personaggio nel bar
    mov dl, 20d
    mov bl, color
    call colorchar   
    
    mov dh, 19d
    mov dl, 55d
    mov bl, color
    call colorchar                                     ; colora il personaggio della legenda
    
    mov di, 17d 
    mov si, 22d   
    call printchat 
    
    game_scene1:
        call getaction
        cmp al, 'n'
        je game_scene1_hide
        cmp al, 'p'
        je game_scene1_wall
        cmp al, 'c'
        je game_scene1_horse
        cmp al, 'b'
        je game_scene1_drink
        jmp game_scene1
                             
    game_scene1_hide:
        
        mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
        mov si, offset file_scene1_corn_path               ; sposta in SI l'indirizzo del nome del file da aprire
        call open_file                                     ; apre il file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame                                    ; carica il buffer con i primi DI caratteri del file
        
        call close_file                                    ; chiude il file
        
        mov bh, 3h                                         ; imposta 5h come pagina di destinazione per la stampa
        call print_frame_at                                ; stampa il buffer nella pagina selezionata                                                      
        
        mov dh, 10d
        mov dl, 28d
        mov bl, color
        call colorchar                                     ; colora il personaggio
        
        mov dh, 19d
        mov dl, 55d
        mov bl, color
        call colorchar                                     ; colora il personaggio della legenda
        
        ; -- inizio stampa dialoghi capitolo 1 nascosto nel campo di grano --
        
        mov di, 22d 
        mov si, 24d   
        call printchat 
        
        call getaction
        call clearchat
        
        mov di, 25d 
        mov si, 28d   
        call printchat 
        
        call getaction  
        call clearchat
        
        mov di, 29d 
        mov si, 32d   
        call printchat 
        
        call getaction 
        call clearchat
        
        mov di, 32d 
        mov si, 35d   
        call printchat
        
        call getaction 
        
        mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
        mov si, offset file_you_died_path                  ; sposta in SI l'indirizzo del nome del file da aprire
        call open_file                                     ; apre il file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame                                    ; carica il buffer con i primi DI caratteri del file
        
        call close_file                                    ; chiude il file
        
        mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
        call print_frame_at                                ; stampa il buffer nella pagina selezionata                                                      
        
        mov al, 5d                                         ; cambia la pagina dopo aver stampato la schermata di morte
        call switchto
        
        mov cl, 33d
        call printstory 
        call getkey 
        
        mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
        mov si, offset file_play_again_path                  ; sposta in SI l'indirizzo del nome del file da aprire
        call open_file                                     ; apre il file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame                                    ; carica il buffer con i primi DI caratteri del file
        
        call close_file                                    ; chiude il file
        
        mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
        call print_frame_at
        
        
        game_scene1_req1:
            call getkey 
            cmp al, 'c'
            je game_checkpoint1
            cmp al, 'a'
            je game_req
            jmp game_scene1_req1
            
        jmp game_scene1_end                             
        
        
    game_scene1_wall:   
        mov scelta, 2h                                     ; salva nella variabile scelta la scelta fatta dall utente
        
        mov al, 3h
        call switchto
        mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
        mov si, offset file_scene1_wall_path               ; sposta in SI l'indirizzo del nome del file da aprire
        call open_file                                     ; apre il file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame                                    ; carica il buffer con i primi DI caratteri del file
        
        call close_file                                    ; chiude il file
        
        mov bh, 3h                                         ; imposta 5h come pagina di destinazione per la stampa 
        call print_frame_at                                                                                        
        
        
        mov dh, 8d                                         ; DH = riga, DL = colonna
        mov dl, 26d
        mov bl, color
        call colorchar                                     ; colora il personaggio
        
        mov dh, 19d                                        ; colora il personaggio nella legenda
        mov dl, 55d
        mov bl, color
        call colorchar
            

        mov di, 35d                                        ; inizia a stampare i dialoghi della scelta
        mov si, 37d                                        ; il registro DI continene la linea di inizio lettura dal file
        call printchat                                     ; mentre il registro SI contiene la riga di fine lettura (esclusa)
        call getaction                                     ; get action prende il tasto che preme l'utente e gestisce quello 
        call clearchat                                     ; che deve succedere se si premono i tasti speciali (;,.lm)
        
        ; -- sposta il giocatore sulle mura --
        
        mov ah, 2h                                         ; sposa il cursore dove e' ora il personaggio
        mov dh, 8d                                         ; per eliminarlo
        mov dl, 26d                              
        mov bh, 3h
        int 10h
        
        mov al, ' '                                        ; disegna il personaggio sulla cinta di mura
        mov bh, 3h
        mov cx, 1h
        mov bl, color
        mov ah, 9h 
        int 10h
        
        mov ah, 2h                                         ; sposa il cursore dove e' ora il personaggio
        mov dh, 10d                                        ; per eliminarlo
        mov dl, 12d
        mov bh, 3h
        int 10h
        
        mov al, 'X'                                        ; disegna il personaggio sulla cinta di mura
        mov bh, 3h
        mov cx, 1h
        mov bl, color
        mov ah, 9h 
        int 10h
        
        ; -- inizio stampa dialoghi capitolo 1 muro --
        
        mov di, 38d 
        mov si, 41d   
        call printchat 
        
        call getaction 
        call clearchat
    
        mov di, 42d 
        mov si, 46d   
        call printchat 
        
        call getaction 
        call clearchat       
        
        mov di, 48d 
        mov si, 50d   
        call printchat 
        
        call getaction 
        call clearchat
        
        ; -- sposta il giocatore oltre le mura --
        mov ah, 2h                                         ; cancella il vecchio personaggo
        mov dh, 10d                                          
        mov dl, 12d                              
        mov bh, 3h
        int 10h
        
        mov al, ' '                                        ; disegna il personaggio sulla cinta di mura
        mov bh, 3h
        mov cx, 1h
        mov bl, color
        mov ah, 9h 
        int 10h
         
        mov ah, 2h                                          ; sposa il cursore dove e' ora il personaggio
        mov dh, 8d                                          ; per eliminarlo
        mov dl, 26d
        mov cx, 1h
        int 10h                                             ; cancella il vecchio personaggio
        
        mov al, ' '                                         ; imposta il carattere da stampare
        mov bh, 3h                                          ; imposta la pagina in cui stampare
        mov ah, 9h                                          ; imposta il codice dell interrupt
        int 10h                                             ; stampa il carattere
        
        mov ah, 2h                                          ; sposa il personaggio dall'altra parte del muro
        mov dh, 9d                                          ; per disegnarlo li
        mov dl, 6d
        int 10h                                             
        
        mov al, 'X'                                         ; imposta il carattere da stampare
        mov bh, 3h                                          ; imposta la pagina in cui stampare
        mov ah, 9h                                          ; imposta il codice dell interrupt
        mov cx, 1h
        int 10h                                             ; stampa il carattere  
         
        mov ah, 2h                                          ; sposta il cursore per disegnare il sangue (una parte)
        mov dh, 9d                                           
        mov dl, 7d
        int 10h                                             
        
        mov al, ','                                         ; imposta il carattere da stampare
        mov bh, 3h                                          ; imposta la pagina in cui stampare
        mov bl, 0ch
        mov ah, 9h                                          ; imposta il codice dell interrupt
        mov cx, 1h
        int 10h 
        
        mov ah, 2h                                          ; sposta il cursore per disegnare il sangue (un altra parte)
        mov dh, 10d                                           
        mov dl, 6d
        int 10h                                             
        
        mov al, '.'                                         ; imposta il carattere da stampare
        mov bh, 3h                                          ; imposta la pagina in cui stampare
        mov bl, 0ch
        mov ah, 9h                                          ; imposta il codice dell interrupt
        mov cx, 1h
        int 10h
                                                           
        mov di, 51d 
        mov si, 54d   
        call printchat 
        
        call getaction 
        call clearchat 
        
        mov di, 55d 
        mov si, 58d   
        call printchat 
        
        call getaction 
        call clearchat 
        
        
        mov di, 58d 
        mov si, 60d   
        call printchat 
        
        call getaction 
        call clearchat

        jmp game_scene1_end
   
    
    game_scene1_horse:
        mov scelta, 3h                                     ; salva nella variabile scelta la scelta fatta dall utente
        
        mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
        mov si, offset file_scene1_horse_path              ; sposta in SI l'indirizzo del nome del file da aprire
        call open_file                                     ; apre il file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame                                    ; carica il buffer con i primi DI caratteri del file
        
        call close_file                                    ; chiude il file
        
        mov bh, 3h                                         ; imposta 5h come pagina di destinazione per la stampa 
        call print_frame_at                                                                                        
        
        ; -- colora personaggio --            
        
        mov dh, 12d                                        ; DH = riga, DL = colonna
        mov dl, 26d
        mov bl, color
        call colorchar                                     ; colora il personaggio
        
        ; -- colora personaggio legenda --
        mov dh, 19d
        mov dl, 55d
        mov bl, color
        call colorchar
        
        ; -- inizio stampa dialoghi capitolo 1 con il cavallo --
        
        mov di, 64d 
        mov si, 68d   
        call printchat 
        
        call getaction 
        
        mov si, offset file_scene1_entrance_path 
        mov di, 0h                                         ; apriamo il file in modalita lettura
        call open_file
        
        mov si, offset file_buffer                         ; carichiamo il buffer in ram
        mov di, file_frame_size
        call load_frame                                                                 
        
        call close_file                                    ; chiude il file
        
        mov bh, 3h
        call print_frame_at                                ;  stampa il buffer nella pagina corrente
        
        ; -- colora personaggio -- 
        mov dh, 9d                                         ; DH = riga, DL = colonna
        mov dl, 17d
        mov bl, color
        call colorchar
        
        mov dh, 9d                               
        mov dl, 18d
        mov bl, color
        call colorchar                                     ; colora il personaggio
        
        mov dh, 9d                             
        mov dl, 19d
        mov bl, color
        call colorchar
        
        ; -- colora personaggio legenda --
        mov dh, 19d
        mov dl, 55d
        mov bl, color
        call colorchar
        
        mov di, 69d 
        mov si, 70d   
        call printchat 
        
        call getaction 
        call clearchat
    
        mov di, 72d 
        mov si, 73d   
        call printchat 
        
        call getaction 
        call clearchat       
        
        mov di, 74d 
        mov si, 78d   
        call printchat 
        
        mov ah, 2h                                          ; sposa il cursore dove e' ora il personaggio
        mov dh, 9d                                          ; per eliminarlo
        mov dl, 17d
        mov cx, 1h
        int 10h                                             ; cancella il vecchio personaggio
        
        mov al, ' '                                         ; imposta il carattere da stampare
        mov bh, 3h                                          ; imposta la pagina in cui stampare
        mov ah, 9h                                          ; imposta il codice dell interrupt 
        mov cx, 3h                                          ; stampo 3 volte il carattere
        int 10h
        
        mov ah, 2h                                          ; sposa il cursore dove e' ora il personaggio
        mov dh, 9d                                          ; per eliminarlo
        mov dl, 63d                                                         
        mov cx, 1h
        int 10h 
        
        mov al, '['                                         ; imposta il carattere da stampare
        mov bh, 3h                                          ; imposta la pagina in cui stampare
        mov ah, 9h                                          ; imposta il codice dell interrupt 
        int 10h
        
        mov ah, 2h                                          ; sposa il cursore dove e' ora il personaggio
        mov dh, 9d                                          ; per eliminarlo
        mov dl, 64d                                                         
        mov cx, 1h
        int 10h
        
        mov al, 'X'                                         ; imposta il carattere da stampare
        mov bh, 3h                                          ; imposta la pagina in cui stampare
        mov ah, 9h                                          ; imposta il codice dell interrupt 
        int 10h
        
        mov ah, 2h                                          ; sposa il cursore dove e' ora il personaggio
        mov dh, 9d                                          ; per eliminarlo
        mov dl, 65d                                                         
        mov cx, 1h
        int 10h
        
        mov al, '>'                                         ; imposta il carattere da stampare
        mov bh, 3h                                          ; imposta la pagina in cui stampare
        mov ah, 9h                                          ; imposta il codice dell interrupt 
        int 10h
        
        ; -- colora personaggio --
        mov dh, 9d                                          ; DH = riga, DL = colonna
        mov dl, 64d                                         
        mov bl, color
        call colorchar                                      ; colora il personaggio
        
        
        call getaction
        call clearchat
        
        jmp game_scene1_end
    
    game_scene1_drink:
 
        mov al, 3d
        call switchto                                      ; Tona alla UI principale (03)                                                      

        mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
        mov si, offset file_scene1_drink_path              ; sposta in SI l'indirizzo del nome del file da aprire
        call open_file                                     ; apre il file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame                                    ; carica il buffer con i primi DI caratteri del file
        
        call close_file                                    ; chiude il file
        
        mov bh, 3h                                         ; imposta 5h come pagina di destinazione per la stampa 
        call print_frame_at                                                                                        
        
        
        mov dh, 8d                                         ; DH = riga, DL = colonna
        mov dl, 42d
        mov bl, color
        call colorchar                                     ; colora il personaggio
        
        mov dh, 19d
        mov dl, 55d
        mov bl, color
        call colorchar
        
        ; -- inizio stampa dialoghi capitolo 1 quando torna nel bar --     

        mov di, 78d 
        mov si, 82d   
        call printchat 
        
        call getaction 
        call clearchat 
        
        mov di, 82d 
        mov si, 86d   
        call printchat 
        
        call getaction 
        call clearchat
    
        mov di, 86d 
        mov si, 90d   
        call printchat 
        
        call getaction 
        call clearchat       
        
        mov di, 90d 
        mov si, 95d   
        call printchat 
        
        call getaction
                       
        ; -- disegna l uscita di Cassius dalla taverna
        
        mov si, offset file_scene1_outside_bar_path
        mov di, 0h
        call open_file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame
        
        mov bh, 3h                                         ; stampa l'esterno della taverna
        call print_frame_at                   
        
        mov ch, 30                                         ; cambia l'orario
        mov cl, 2
        mov bl, '6' 
        mov bh, 03h
        call writecharat     
        
        mov dh, 10d                                        ; coloro il personaggio nel bar
        mov dl, 20d
        mov bl, color
        call colorchar   
        
        mov dh, 19d
        mov dl, 55d
        mov bl, color
        call colorchar                                     ; colora il personaggio della legenda
       
   
        ; -- stampa le guardie fuori dalla taverna
        
        mov al, 0h                                         ; imposta la modalita di scrittura
        mov bh, 3h                                         ; imposta la pagina su cui scrivere
        mov bl, 0Fh                                        ; la stringa deve avere l'attributo sfondo nero con carattere bianco
        mov cx, 7h                                         ; coordinate x, y
        mov dl, 24d
        mov dh, 9d
        mov bp, offset entity_guard
        mov ah, 13h                                        ; imposta il codice dell interrupt
        int 10h
        
        mov al, 0h                                         ; imposta la modalita di scrittura
        mov bh, 3h                                         ; imposta la pagina su cui scrivere
        mov bl, 0Fh                                        ; la stringa deve avere l'attributo sfondo nero con carattere bianco
        mov cx, 7h                                         ; coordinate x, y
        mov dl, 16d
        mov dh, 8d
        mov bp, offset entity_guard
        mov ah, 13h                                        ; imposta il codice dell interrupt
        int 10h
        
        mov al, 0h                                         ; imposta la modalita di scrittura
        mov bh, 3h                                         ; imposta la pagina su cui scrivere
        mov bl, 0Fh                                        ; la stringa deve avere l'attributo sfondo nero con carattere bianco
        mov cx, 7h                                         ; coordinate x, y
        mov dl, 16d
        mov dh, 12d
        mov bp, offset entity_guard
        mov ah, 13h                                        ; imposta il codice dell interrupt
        int 10h
                       
        mov di, 96d 
        mov si, 101d   
        call printchat
        
        call getaction 
        call clearchat
        
        mov di, 101d 
        mov si, 105d   
        call printchat
        call getaction
                                                       
        mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
        mov si, offset file_you_died_path                  ; sposta in SI l'indirizzo del nome del file da aprire
        call open_file                                     ; apre il file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame                                    ; carica il buffer con i primi DI caratteri del file
        
        call close_file                                    ; chiude il file
        
        mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
        call print_frame_at                                ; stampa il buffer nella pagina selezionata                                                      
        
        mov al, 5d
        call switchto
        
        mov cl, 48d
        call printstory 
        call getkey 
        
        mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
        mov si, offset file_play_again_path                  ; sposta in SI l'indirizzo del nome del file da aprire
        call open_file                                     ; apre il file
        
        mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
        mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
        call load_frame                                    ; carica il buffer con i primi DI caratteri del file
        
        call close_file                                    ; chiude il file
        
        mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
        call print_frame_at
        
        game_scene_req4:
            call getkey 
            cmp al, 'c'
            je game_checkpoint1
            cmp al, 'a'
            je game_req
            jmp game_scene_req4
        
    game_scene1_end:
    
    mov si, offset file_scene1_end_path
    mov di, 0h
    call open_file
    
    mov si, offset file_buffer
    mov di, file_frame_size
    call load_frame
    
    mov bh, 3h
    call print_frame_at
    
    mov al, 3h                                              ; cambia la pagina dalla 6 alla 3
    call switchto
    
    call getkey      
    
    call setloadingscreen                                   ; fa vedere la schermata di caricamento
    
    mov al, 3h                                              ; cambia la pagina dalla 6 alla 3
    call switchto
    
    mov si, offset file_scene2_scroll_path                  ; disegna l'introduzione del capitolo 2
    mov di, 0h
    call open_file
    
    mov si, offset file_buffer
    mov di, file_frame_size
    call load_frame
    
    mov bh, 3h
    call print_frame_at
    
    call getkey
                                 
    game_checkpoint2::                                           ; crea l etichetta per il checkpoint
    mov current_checkpoint, 2h                                   ; salva il numero della scena a cui siamo arrivati
    
    mov al, 3h
    call switchto
     
    cmp scelta, 2h                                               ; in base alle scelte che hai fatto nel capitolo 1 la storia cambia
    je game_scene2_wall    
    
    cmp scelta, 3h
    je game_scene2_horse
    
    jmp error_choice_currupted
    
    game_scene2_wall:
        
        mov si, offset file_scene2_wall_path                     ; apre il file con la scena dopo che sei svenuto fuori dalle mura
        mov di, 0h                                               ; imposta la modalita di lettura
        call open_file                                           ; apre il file
        
        mov si, offset file_buffer                               ; carica il buffer
        mov di, file_frame_size
        call load_frame
        
        mov bh, 3h                                               ; lo stampa nella pagina corrente
        call print_frame_at
        
        ; -- colora personaggio --
        
        mov dh, 5d                                               ; coloro il personaggio nel bar
        mov dl, 68d
        mov bl, color
        call colorchar   
        
        mov dh, 18d
        mov dl, 55d
        mov bl, color
        call colorchar                                           ; colora il personaggio della legenda
        
        mov dl, 6d
        
        mov ah, 13h                                         ; stampa la figura del contadino vicino a te
        mov al, 0h                                          ; imposta la modalita
        mov bh, 3h                                          ; la pagina in cui stamparlo       
        mov bl, 0ch                                         ; colore da stampare
        mov cx, 11d                                         ; numero di caratteri
        mov dl, 6d                                         ; coordinate
        mov dh, 11d
        mov bp, offset entity_nicolas                       ; stringa da stampare
        int 10h 
                                                               
    ; -- inizio stampa dialoghi capitolo 2 mura --
        
        mov di, 108d 
        mov si, 113d   
        call printchat
        
        game_scene2_wall_choice1:
            call getaction                                        ; gestisce la prima scelta se si ha scelto questa storia
            cmp al, 'r'
            je game_scene2_giveup
            cmp al, 's'
            je game_scene2_house
    
            jmp game_scene2_wall_choice1

        game_scene2_giveup:
            call clearchat                                                    
            
            mov ah, 2h
            mov dl, 6d
            mov dh, 11d
            mov bh, 3h
            int 10h
                                                                ; fa avvicinare il personaggio
            mov al, ' '                                         ; imposta il carattere da stampare
            mov bh, 3h                                          ; imposta la pagina in cui stampare
            mov ah, 9h                                          ; imposta il codice dell interrupt 
            mov bl, 0fh
            mov cx, 11d                                         ; stampo 11 volte il carattere
            int 10h
            
            mov ah, 13h                                         ; stampa la figura del contadino vicino a te
            mov al, 0h                                          ; imposta la modalita
            mov bh, 3h                                          ; la pagina in cui stamparlo       
            mov bl, 0ch                                         ; colore da stampare
            mov cx, 11d                                         ; numero di caratteri
            mov dl, 58d                                         ; coordinate
            mov dh, 3h
            mov bp, offset entity_nicolas                       ; stringa da stampare
            int 10h
            
            mov di, 114d 
            mov si, 118d   
            call printchat 
            
            call getaction 
            call clearchat 
            
            mov di, 118d 
            mov si, 122d   
            call printchat 
            
            call getaction 
            call clearchat
            
            mov di, 122d 
            mov si, 128d   
            call printchat 
            
            call getaction 
            call clearchat
            
            mov di, 128d 
            mov si, 133d   
            call printchat 
            
            call getaction 
            call clearchat 
            
            mov di, 133d 
            mov si, 137d   
            call printchat 
            
            call getaction 
            call clearchat
            
            mov di, 137d 
            mov si, 142d   
            call printchat 
            
            call getaction 
            call clearchat
            
            ; -- percorso per la casa del tipo
            
            mov si, offset file_scene2_forest_path                   ; apre il file con la scena dopo che sei svenuto fuori dalle mura
            mov di, 0h                                               ; imposta la modalita di lettura
            call open_file                                           ; apre il file
            
            mov si, offset file_buffer                               ; carica il buffer
            mov di, file_frame_size
            call load_frame
            
            mov bh, 3h                                               ; lo stampa nella pagina corrente
            call print_frame_at
            
            ; -- colora il sangue e il personaggio --
            
            mov dh, 8d                                           
            mov dl, 36d
            mov bl, color
            call colorchar   
            
            mov dh, 19d                                           
            mov dl, 55d
            mov bl, color
            call colorchar
            
            mov dh, 16d                                           
            mov dl, 15d
            mov bl, 4h
            call colorchar   
            
            mov dh, 14d                                           
            mov dl, 16d
            mov bl, 0ch
            call colorchar
            
            mov dh, 14d                                               
            mov dl, 19d
            mov bl, 0ch
            call colorchar
            
            mov dh, 14d                                               
            mov dl, 23d
            mov bl, 04h
            call colorchar
            
            mov dh, 14d                                            
            mov dl, 24d
            mov bl, 0ch
            call colorchar
            
            mov dh, 13d                        
            mov dl, 30d
            mov bl, 04h
            call colorchar
            
            mov dh, 10d    
            mov dl, 35d
            mov bl, 0ch
            call colorchar
            
            
            ; -- dialoghi nel mentre --
            
            mov di, 143d 
            mov si, 148d   
            call printchat
            
            call getaction
            call clearchat
            
            ; -- arriva a casa del tipo --
            
            mov si, offset file_scene2_house_inside_path             ; apre il file con la scena dopo che sei svenuto fuori dalle mura
            mov di, 0h                                               ; imposta la modalita di lettura
            call open_file                                           ; apre il file
            
            mov si, offset file_buffer                               ; carica il buffer
            mov di, file_frame_size
            call load_frame
            
            mov bh, 3h                                               ; lo stampa nella pagina corrente
            call print_frame_at
            
            mov dh, 6d                                               ; coloro il personaggio nel bar
            mov dl, 17d
            mov bl, color
            call colorchar   
            
            mov dh, 18d
            mov dl, 55d
            mov bl, color
            call colorchar                                           ; colora il personaggio della legenda 
            
            mov di, 181d 
            mov si, 185d   
            call printchat 
            
            call getaction 
            call clearchat
            
            mov di, 186d 
            mov si, 187d   
            call printchat 
            
            call getaction 
            call clearchat
           
            mov di, 188d 
            mov si, 193d   
            call printchat 
            
            call getaction 
            call clearchat
            
            ; parte in cui sei in cucina con nicolas
            mov ah, 2h                                    ; sposta il cursore sulla parola di nicolas
            mov dl, 22d
            mov dh, 8d
            int 10h
            
            mov ah, 9h                                    ; cancella il suo nome
            mov al, ' '
            mov bh, 3h
            mov bl, 0fh
            mov cx, 8h
            int 10h
                                                          ; stampa nicolas in cucina
            mov ah, 13h
            mov al, 0h
            mov bl, 0fh
            mov bh, 3h
            mov dl, 10d
            mov dh, 10d
            mov cx, 8h
            mov bp, offset entity_muireach
            int 10h
             
            mov ah, 2h                                    ; sposta il cursore su di te a letto
            mov dl, 17d
            mov dh, 6d
            int 10h
            
            mov ah, 9h                                    ; cancella il suo nome
            mov al, ' '
            mov bh, 3h
            mov bl, 0fh
            mov cx, 1h
            int 10h
            
            mov ah, 2h                                    ; sposta il cursore sulla sedia
            mov dl, 17d
            mov dh, 12d
            int 10h
            
            mov ah, 9h                                    ; ti disegna sulla seedia
            mov al, 'X'
            mov bh, 3h
            mov bl, color
            mov cx, 1h
            int 10h
            
            mov di, 194d 
            mov si, 198d   
            call printchat 
            
            call getaction 
            call clearchat
            
            ; -- ridisegna cassius a letto --
            
            mov ah, 2h                                    ; sposta il cursore sulla sedia
            mov dl, 17d
            mov dh, 12d
            int 10h
            
            mov ah, 9h                                    ; ti disegna sulla seedia
            mov al, 'O'
            mov bh, 3h
            mov bl, 0fh
            mov cx, 1h
            int 10h
            
            mov ah, 2h                                    ; sposta il cursore di te a letto
            mov dl, 17d
            mov dh, 6d
            int 10h
            
            mov ah, 9h                                    ; cancella il suo nome
            mov al, 'X'
            mov bh, 3h
            mov bl, 0fh
            mov cx, 1h
            int 10h
            
            mov dh, 6d
            mov dl, 17d
            mov bl, color
            call colorchar 
            
            ; -- cambia l'ora e il giorno --
            
            mov ch, 9h
            mov cl, 2h
            mov bl, '5'
            mov bh, 3h
            call writecharat 
            
            mov ch, 29d
            mov cl, 2h
            mov bl, '0'
            mov bh, 3h
            call writecharat
            
            mov ch, 30d
            mov cl, 2h
            mov bl, '8'
            mov bh, 3h
            call writecharat     
            
            mov ch, 32d
            mov cl, 2h
            mov bl, '1'
            mov bh, 3h
            call writecharat
            
            mov ch, 33d
            mov cl, 2h
            mov bl, '2'
            mov bh, 3h
            call writecharat
            
            mov di, 199d 
            mov si, 203d   
            call printchat 
            
            call getaction 
            call clearchat
            
            ; tu esci dalla camera
            mov ah, 2h                                    ; sposta il cursore su di te a letto
            mov dl, 17d
            mov dh, 6d
            mov bh, 3h
            int 10h
            
            mov ah, 9h                                    ; cancella il suo nome
            mov al, ' '
            mov bh, 3h
            mov bl, 0fh
            mov cx, 1h
            int 10h
            
            mov ah, 2h                                    ; sposta il cursore sulla sedia
            mov dl, 17d
            mov dh, 12d
            int 10h
            
            mov ah, 9h                                    ; ti disegna sulla seedia
            mov al, 'X'
            mov bh, 3h
            mov bl, color
            mov cx, 1h
            int 10h
            
            mov di, 204d 
            mov si, 208d   
            call printchat 
            
            call getaction 
            call clearchat
            
            mov di, 207d                                     ; possibile bug se si mette da 208 a 213
            mov si, 212d   
            call printchat 
            
            call getaction 
            call clearchat
            
            mov di, 212d 
            mov si, 216d   
            call printchat 
            
            call getaction 
            call clearchat
             
            mov di, 216d 
            mov si, 219d   
            call printchat 
            
            call getaction 
            call clearchat
             
            mov di, 220d 
            mov si, 225d   
            call printchat 
            
            game_scene2_giveup_req1:
                call getaction
                
                cmp al, 's'
                je game_scene2_giveup_req1_yes
                cmp al, 'n'
                je game_scene2_giveup_req1_end
                jmp game_scene2_giveup_req1
                
            game_scene2_giveup_req1_yes:
                call clearchat
                
                mov di, 225d 
                mov si, 228d   
                call printchat 
                
                call getaction 
                
            game_scene2_giveup_req1_end:
            
            ; -- tu e nicolas in sala --                  ; sposta cassius dalla cucina alla sala
            
            mov ah, 2h                                    ; sposta il cursore sulla sedia con cassius
            mov dl, 17d
            mov dh, 12d
            int 10h
            
            mov ah, 9h                                    ; disegna la sedia
            mov al, 'O'
            mov bh, 3h
            mov bl, 0fh
            mov cx, 1h
            int 10h 
            
            mov ah, 2h                                    ; sposta il cursore in sala
            mov dl, 40d
            mov dh, 13d
            int 10h
            
            mov ah, 9h                                    ; ti disegna in sala
            mov al, 'X'
            mov bh, 3h
            mov bl, color
            mov cx, 1h
            int 10h
                                                          ; sposta nicolas dalla cucina alla sala
            mov ah, 2h                                    ; sposta il cursore sulla parola di nicolas
            mov dl, 10d
            mov dh, 10d
            int 10h
            
            mov ah, 9h                                    ; cancella il suo nome
            mov al, ' '
            mov bh, 3h
            mov bl, 0fh
            mov cx, 8h
            int 10h                                              
            
            mov ah, 13h
            mov al, 0h
            mov bl, 0fh
            mov bh, 3h
            mov dl, 36d
            mov dh, 11d
            mov cx, 8h
            mov bp, offset entity_muireach
            int 10h
            
            call clearchat
            mov di, 228d 
            mov si, 231d   
            call printchat 
            
            call getaction 
            call clearchat      
            
            mov di, 231d 
            mov si, 234d   
            call printchat 
            
            game_scene2_giveup_req2:                                ; chiede all utente se vuole uccidere l amico
                call getaction                                      ; contadino nicolas oppure se vuole risparmiargli la vita
                
                cmp al, 'r'
                je game_scene2_giveup_req2_trust
                cmp al, 'u'
                je game_scene2_giveup_req2_kill
                
                jmp game_scene2_giveup_req2
                
            game_scene2_giveup_req2_trust:
                
                add karma, 1d
                
                mov si, offset file_scene2_runswick_path            ; apre il file con la scena dopo che sei svenuto fuori dalle mura
                mov di, 0h                                          ; imposta la modalita di lettura
                call open_file                                      ; apre il file
                
                mov si, offset file_buffer                          ; carica il buffer
                mov di, file_frame_size
                call load_frame
                
                mov bh, 3h                                          ; lo stampa nella pagina corrente
                call print_frame_at
                
                mov di, 334d 
                mov si, 339d   
                call printchat 
                
                call getaction 
                jmp game_scene2_end 
                
            game_scene2_giveup_req2_kill:
                
                sub karma, 6d
                
                
                ; strage
                mov ah, 13h                                          ; stampo la parola cadavere al posto del
                mov al, 0h                                           ; nome di nicolas
                mov bl, 0fh
                mov bh, 3h
                mov dl, 36d
                mov dh, 11d
                mov cx, 8h
                mov bp, offset entity_dead_body
                int 10h
                
                ; -- disegno tutto il sangue per averlo ucciso --
                mov ah, 2h
                mov dh, 9d
                mov dl, 38d
                int 10h
                
                mov ah, 9h
                mov al, '.'
                mov bh, 3h
                mov bl, 0ch
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 9d
                mov dl, 45d
                int 10h
                
                mov ah, 9h
                mov al, '.'
                mov bh, 3h
                mov bl, 4h
                mov cx, 1h
                int 10h    
                    
                mov ah, 2h
                mov dh, 10d
                mov dl, 34d
                int 10h
                
                mov ah, 9h
                mov al, ','
                mov bh, 3h
                mov bl, 4h
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 10d
                mov dl, 36d
                int 10h
                
                mov ah, 9h
                mov al, '.'
                mov bh, 3h
                mov bl, 4h
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 10d
                mov dl, 37d
                int 10h
                
                mov ah, 9h
                mov al, '.'
                mov bh, 3h
                mov bl, 0ch
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 10d
                mov dl, 40d
                int 10h
                
                mov ah, 9h
                mov al, '.'
                mov bh, 3h
                mov bl, 0ch
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 10d
                mov dl, 43d
                int 10h
                
                mov ah, 9h
                mov al, '.'
                mov bh, 3h
                mov bl, 04h
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 11d
                mov dl, 33d
                int 10h
                
                mov ah, 9h
                mov al, ','
                mov bh, 3h
                mov bl, 0ch
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 11d
                mov dl, 45d
                int 10h
                
                mov ah, 9h
                mov al, ','
                mov bh, 3h
                mov bl, 4h
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 12d
                mov dl, 36d
                int 10h
                
                mov ah, 9h
                mov al, ','
                mov bh, 3h
                mov bl, 4h
                mov cx, 1h
                int 10h
                 
                mov ah, 2h
                mov dh, 12d
                mov dl, 40d
                int 10h
                
                mov ah, 9h
                mov al, ','
                mov bh, 3h
                mov bl, 0ch
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 12d
                mov dl, 42d
                int 10h
                
                mov ah, 9h
                mov al, '.'
                mov bh, 3h
                mov bl, 4h
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 12d
                mov dl, 48d
                int 10h
                
                mov ah, 9h
                mov al, ','
                mov bh, 3h
                mov bl, 4h
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 13d
                mov dl, 35d
                int 10h
                
                mov ah, 9h
                mov al, '.'
                mov bh, 3h
                mov bl, 0ch
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 13d
                mov dl, 44d
                int 10h
                
                mov ah, 9h
                mov al, ','
                mov bh, 3h
                mov bl, 4h
                mov cx, 1h
                int 10h
                
                ; -- stampa i dialoghi --
                call clearchat
                
                mov di, 325d 
                mov si, 329d   
                call printchat 
                
                call getaction
                
                ; -- stampa fuori della casa con cavallo -- 
                
                mov si, offset file_scene2_forest_house_path             ; apre il file con la scena dopo che sei svenuto fuori dalle mura
                mov di, 0h                                               ; imposta la modalita di lettura
                call open_file                                           ; apre il file
                
                mov si, offset file_buffer                               ; carica il buffer
                mov di, file_frame_size
                call load_frame
                
                mov bh, 3h                                               ; lo stampa nella pagina corrente
                call print_frame_at
                
                ; -- cancella il vecchio personaggio --
                
                mov ah, 2h
                mov dh, 15d
                mov dl, 29d
                mov bh, 3h
                int 10h
                
                mov ah, 9h
                mov al, ' '
                mov bh, 3h
                mov bl, 0fh
                mov cx, 1h
                int 10h
                
                mov ah, 2h
                mov dh, 4d
                mov dl, 35d
                mov bh, 3h
                int 10h
                
                mov ah, 9h
                mov al, 'X'
                mov bh, 3h
                mov bl, color
                mov cx, 1h
                int 10h
                
                call getaction
                
                jmp game_scene2_end
                       
        game_scene2_house:
        
        mov si, offset file_scene2_before_house_path             ; apre il file con la scena dopo che sei svenuto fuori dalle mura
        mov di, 0h                                               ; imposta la modalita di lettura
        call open_file                                           ; apre il file
        
        mov si, offset file_buffer                               ; carica il buffer
        mov di, file_frame_size
        call load_frame
        
        mov bh, 3h                                               ; lo stampa nella pagina corrente
        call print_frame_at
        
        ; -- colora il personaggio --
        
        mov dh, 10d                                               ; coloro il personaggio nel bar
        mov dl, 57d
        mov bl, color
        call colorchar   
        
        mov dh, 18d
        mov dl, 55d
        mov bl, color
        call colorchar                                           ; colora il personaggio della legenda 
        
        ; -- colora il sangue --
        
        mov dh, 10d
        mov dl, 58d
        mov bl, 4h
        call colorchar
        
        mov dh, 10d
        mov dl, 61d
        mov bl, 0ch
        call colorchar
        
        mov dh, 10d
        mov dl, 62d
        mov bl, 0ch
        call colorchar
        
        mov dh, 10d
        mov dl, 67d
        mov bl, 4h
        call colorchar
        
        mov dh, 10d
        mov dl, 68d
        mov bl, 0ch
        call colorchar
        
        mov dh, 10d
        mov dl, 71d
        mov bl, 4h
        call colorchar
        
        mov dh, 10d
        mov dl, 76d
        mov bl, 0ch
        call colorchar
        
        ; -- stampa dialoghi --
        
        mov di, 151d 
        mov si, 155d   
        call printchat 
           
        call getaction 
        call clearchat
       
        mov di, 156d 
        mov si, 160d       
        call printchat 
        
        game_scene2_house_req1:
            call getaction
            
            cmp al, 'f'
            je game_scene2_house_req1_medicate
            cmp al, 'p'
            je  game_scene2_house_req1_mushroom 
            
            jmp game_scene2_house_req1
                
        game_scene2_house_req1_medicate:
                
            call clearchat
                     
            mov di, 161d 
            mov si, 163d   
            call printchat 
               
            call getaction 
            call clearchat
            
            mov di, 167d 
            mov si, 169d   
            call printchat 
               
            call getaction 
            call clearchat
            
            ; -- disegna la nuova facciata --
            
            mov si, offset file_scene2_forest_house_path             ; apre il file con la scena dopo che sei svenuto fuori dalle mura
            mov di, 0h                                               ; imposta la modalita di lettura
            call open_file                                           ; apre il file
            
            mov si, offset file_buffer                               ; carica il buffer
            mov di, file_frame_size
            call load_frame
            
            mov bh, 3h                                               ; lo stampa nella pagina corrente
            call print_frame_at
            
             
            ; -- colora il personaggio --
            
            mov dh, 15d                                              ; coloro il personaggio nel bar
            mov dl, 29d
            mov bl, color
            call colorchar   
            
            mov dh, 19d
            mov dl, 55d
            mov bl, color
            call colorchar      
              
            mov di, 169d 
            mov si, 174d   
            call printchat 
            
            ; -- nasconde cassius in un cespuglio/albero --
            
            mov ch, 29d                                              ; cambia l'orario
            mov cl, 15d
            mov bl, ' ' 
            mov bh, 03h
            call writecharat
            
            mov ch, 47d                                              ; cambia l'orario
            mov cl, 12d
            mov bl, 'X' 
            mov bh, 03h
            call writecharat 
            
            mov dh, 12d
            mov dl, 47d
            mov bl, color
            call colorchar 
            
            ; -- stampa i dialoghi --
              
            call getaction 
            call clearchat
            
            mov di, 175d 
            mov si, 178d   
            call printchat 
               
            call getaction 
            call clearchat
            
            ; -- stampa il frame di cassius che cammina nella foresta per ore --
            
            mov al, 3d
            call switchto
            mov si, offset file_scene2_after_house_path              ; apre il file con la scena dopo che sei svenuto fuori dalle mura
            mov di, 0h                                               ; imposta la modalita di lettura
            call open_file                                           ; apre il file
            
            mov si, offset file_buffer                               ; carica il buffer
            mov di, file_frame_size
            call load_frame
            
            mov bh, 3h                                               ; lo stampa nella pagina corrente
            call print_frame_at
            
            ; -- colora il giocatore e il sangue --
            
            mov dh, 12d
            mov dl, 36d
            mov bl, color
            call colorchar 
            
            
            ; -- stampa i dialoghi --
            
            mov di, 236d 
            mov si, 239d   
            call printchat 
               
            call getaction 
            call clearchat
            
            mov di, 240d 
            mov si, 245d   
            call printchat 
                
            game_scene2_house_req2:
                call getaction
                
                cmp al, 'p'
                je game_scene2_house_req2_berrys
                cmp al, 's'
                je  game_scene2_house_req2_death
                
                jmp game_scene2_house_req2
                    
            game_scene2_house_req2_berrys:
                    
                call clearchat           
                
                ; -- sposto il player -- 
                
              
                mov ch, 36d                                              ; cancello il vecchio giocatore
                mov cl, 12d
                mov bl, ' ' 
                mov bh, 03h
                call writecharat 
                
                mov ch, 40d                                              ; disegno il nuovo giocatore alla nuova posizione
                mov cl, 5d
                mov bl, 'X' 
                mov bh, 03h
                call writecharat
                
                mov dh, 5d                                               ; lo colora
                mov dl, 40d
                mov bl, color
                call colorchar
                
                ; -- stampa i dialoghi -- 
                
                mov di, 249d 
                mov si, 252d   
                call printchat 
                
                call getaction 
                call clearchat
                
                ; -- disegna il sangue che sputa --
                
                mov ch, 39d                                              
                mov cl, 5d
                mov bl, '`' 
                mov bh, 03h
                call writecharat
                
                mov dh, 5d                                               
                mov dl, 39d
                mov bl, 0ch
                call colorchar
                
                mov ch, 41d                                               
                mov cl, 5d
                mov bl, ',' 
                mov bh, 03h
                call writecharat
                
                mov dh, 5d                                               
                mov dl, 41d
                mov bl, 0ch
                call colorchar 
                
                ; -- cambia il tempo (21:03) --
                mov ch, 29d                                              ; imposta l'ora
                mov cl, 2d
                mov bl, '2' 
                mov bh, 03h
                call writecharat
                
                mov ch, 30d                                          
                mov cl, 2d
                mov bl, '1' 
                mov bh, 03h
                call writecharat
                
                mov ch, 32d                                              ; imposta il minuto
                mov cl, 2d
                mov bl, '0' 
                mov bh, 03h
                call writecharat
                
                mov ch, 33d                                            
                mov cl, 2d
                mov bl, '3' 
                mov bh, 03h
                call writecharat
                
                mov di, 252d 
                mov si, 255d   
                call printchat 
                   
                call getaction 
                call clearchat
                
                ; -- scena di morte per il player --     
            
                mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
                mov si, offset file_you_died_path                  ; sposta in SI l'indirizzo del nome del file da aprire
                call open_file                                     ; apre il file
                
                mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
                mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
                call load_frame                                    ; carica il buffer con i primi DI caratteri del file
                
                call close_file                                    ; chiude il file
                
                mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
                call print_frame_at                                ; stampa il buffer nella pagina selezionata                                                      
                
                mov al, 5d
                call switchto                 
                
                mov cl, 64d
                call printstory 
                
                call getkey
                
                mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
                mov si, offset file_play_again_path                  ; sposta in SI l'indirizzo del nome del file da aprire
                call open_file                                     ; apre il file
                
                mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
                mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
                call load_frame                                    ; carica il buffer con i primi DI caratteri del file
                
                call close_file                                    ; chiude il file
                
                mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
                call print_frame_at
                
                game_scene2_req1:
                    call getkey 
                    cmp al, 'c'
                    je game_checkpoint2
                    cmp al, 'a'
                    je game_req
                    jmp game_scene2_req1
                    
            game_scene2_house_req2_death:
                    
                call clearchat
                 
                mov di, 330d 
                mov si, 335d   
                call printchat 
                   
                call getaction 
                call clearchat 
                 
                jmp game_scene2_end
                
        game_scene2_house_req1_mushroom:        
            
            call clearchat
               
            mov di, 163d 
            mov si, 167d   
            call printchat 
               
            call getaction
            
            ; -- scena di morte per il player --     
            
            mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
            mov si, offset file_you_died_path                  ; sposta in SI l'indirizzo del nome del file da aprire
            call open_file                                     ; apre il file
            
            mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
            mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
            call load_frame                                    ; carica il buffer con i primi DI caratteri del file
            
            call close_file                                    ; chiude il file
            
            mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
            call print_frame_at                                ; stampa il buffer nella pagina selezionata                                                      
            
            mov al, 5d
            call switchto                 
            
            call getkey
            
            mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
            mov si, offset file_play_again_path                ; sposta in SI l'indirizzo del nome del file da aprire
            call open_file                                     ; apre il file
            
            mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
            mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
            call load_frame                                    ; carica il buffer con i primi DI caratteri del file
            
            call close_file                                    ; chiude il file
            
            mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
            call print_frame_at
            
            game_scene2_req3:
                call getkey 
                cmp al, 'c'
                je game_checkpoint2
                cmp al, 'a'
                je game_req
                jmp game_scene2_req3
        
    game_scene2_horse: 
            
            mov scelta, 3h        
            mov si, offset file_scene2_horse_path                    ; apre il file con la scena dopo che sei svenuto fuori dalle mura
            mov di, 0h                                               ; imposta la modalita di lettura
            call open_file                                           ; apre il file
            
            mov si, offset file_buffer                               ; carica il buffer
            mov di, file_frame_size
            call load_frame
            
            mov bh, 3h                                               ; lo stampa nella pagina corrente
            call print_frame_at 
            
            mov dh, 15d                                               ; coloro il personaggio nel bar
            mov dl, 23d
            mov bl, color
            call colorchar 
            
            mov dh, 15d                                               ; coloro il personaggio nel bar
            mov dl, 24d
            mov bl, color
            call colorchar 
            
            mov dh, 15d                                               ; coloro il personaggio nel bar
            mov dl, 25d
            mov bl, color
            call colorchar   
            
            mov dh, 18d
            mov dl, 55d
            mov bl, color
            call colorchar  
   
    
            mov di, 255d 
            mov si, 257d   
            call printchat 
            
            call getaction 
            call clearchat 
            
            
            mov si, offset file_scene2_cap_path                    ; apre il file con la scena dopo che sei svenuto fuori dalle mura
            mov di, 0h                                               ; imposta la modalita di lettura
            call open_file                                           ; apre il file
            
            mov si, offset file_buffer                               ; carica il buffer
            mov di, file_frame_size
            call load_frame
            
            mov bh, 3h                                               ; lo stampa nella pagina corrente
            call print_frame_at   
            
            mov dh, 1d                                               ; coloro il personaggio nel bar
            mov dl, 60d
            mov bl, color
            call colorchar
            
            mov dh, 1d                                               ; coloro il personaggio nel bar
            mov dl, 61d
            mov bl, color
            call colorchar 
            
            mov dh, 1d                                               ; coloro il personaggio nel bar
            mov dl, 62d
            mov bl, color
            call colorchar
            
            mov dh, 19d
            mov dl, 55d
            mov bl, color
            call colorchar  
            
            
            
            mov di, 258d 
            mov si, 260d   
            call printchat 
            
            call getaction 
            call clearchat   
            
            mov al, 3h    
            call switchto
            
            
            mov ch, 60                                              ; cambia l'orario
            mov cl, 1
            mov bl, ' ' 
            mov bh, 03h
            call writecharat 
                    
            mov ch, 61                                               ; cambia l'orario
            mov cl, 1
            mov bl, ' ' 
            mov bh, 03h
            call writecharat 
                    
            mov ch, 62                                               ; cambia l'orario
            mov cl, 1
            mov bl, ' ' 
            mov bh, 03h
            call writecharat 
            
            mov ch, 69                                               ; cambia l'orario
            mov cl, 1
            mov bl, '[' 
            mov bh, 03h
            call writecharat
            
            mov dh, 1d                                               ; coloro il personaggio nel bar
            mov dl, 69d
            mov bl, color
            call colorchar

            mov ch, 70                                               ; cambia l'orario
            mov cl, 1
            mov bl, 'X' 
            mov bh, 03h
            call writecharat  
            
            mov dh, 1d                                               ; coloro il personaggio nel bar
            mov dl, 70d
            mov bl, color
            call colorchar                      
                          
            mov ch, 71                                               ; cambia l'orario
            mov cl, 1
            mov bl, '>' 
            mov bh, 03h
            call writecharat
            
            mov dh, 1d                                               ; coloro il personaggio nel bar
            mov dl, 71d
            mov bl, color
            call colorchar
            
            mov di, 260d 
            mov si, 264d   
            call printchat 
            
            call getaction 
            call clearchat 
    
            mov di, 265d 
            mov si, 267d   
            call printchat 
            
            
            call getaction
            call clearchat 
            
            mov di, 268d 
            mov si, 272d   
            call printchat 
            
            game_scene2_horse_req1:
                call getaction                                        ; gestisce la prima scelta se si ha scelto questa storia
                cmp al, 'a'
                je game_scene2_req1_closer
                cmp al, 'c'
                je game_scene2_req1_away
    
                jmp game_scene2_horse_req1  
            
                game_scene2_req1_away:
                    call clearchat
                    
                    ; -- cancella il cavallo e lo sposta fuori dalla scena --
                    mov ch, 69d                                          
                    mov cl, 1d
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat 
                    
                    mov ch, 70d                                          
                    mov cl, 1d
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat 
                    
                    mov ch, 71d                                         
                    mov cl, 1d
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat
                    
                    mov di, 322d 
                    mov si, 325d   
                    call printchat 
                        
                    call getaction 
                    call clearchat 
                    
                    
                    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
                    mov si, offset file_you_died_path                  ; sposta in SI l'indirizzo del nome del file da aprire
                    call open_file                                     ; apre il file
                    
                    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
                    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
                    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
                    
                    call close_file                                    ; chiude il file
                    
                    mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
                    call print_frame_at                                ; stampa il buffer nella pagina selezionata                                                      
                    
                    mov al, 5d
                    call switchto 
                    
                    ; -- stampa la causa della morte --
                                         
                    mov cl, 80d
                    call printstory 
                    call getkey 
                    
                    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
                    mov si, offset file_play_again_path                ; sposta in SI l'indirizzo del nome del file da aprire
                    call open_file                                     ; apre il file
                    
                    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
                    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
                    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
                    
                    call close_file                                    ; chiude il file
                    
                    mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
                    call print_frame_at
                    
                    game_scene2_req2:
                        call getkey
                         
                        cmp al, 'c'                        
                        je game_checkpoint2  
                        
                        cmp al, 'a'
                        je game_req
                        jmp game_scene2_req2
                        
                game_scene2_req1_closer:
                    call clearchat 
                    
                    ; disegnio Cassius vicino alla guardia che dorme
                    

                    mov dh, 1d                                               ; coloro il personaggio nel bar
                    mov dl, 69d
                    mov bl, 1111b
                    call colorchar
                    
                    mov ch, 70                                         ; cambia l'orario
                    mov cl, 1
                    mov bl, '=' 
                    mov bh, 03h
                    call writecharat
                    
                    mov dh, 1d                                               ; coloro il personaggio nel bar
                    mov dl, 70d
                    mov bl, 1111b
                    call colorchar
                    
                    mov dh, 1d                                               ; coloro il personaggio nel bar
                    mov dl, 71d
                    mov bl, 1111b
                    call colorchar
                    
                    
                    mov ch, 71                                         ; cambia l'orario
                    mov cl, 6
                    mov bl, 'X' 
                    mov bh, 03h
                    call writecharat
                    
                    mov dh, 6d                                               ; coloro il personaggio nel bar
                    mov dl, 71d
                    mov bl, color
                    call colorchar
                 
                    
                    mov di, 273d 
                    mov si, 275d   
                    call printchat 
                    
                    call getaction 
                    call clearchat   
                    
                    mov di, 276d 
                    mov si, 279d   
                    call printchat 
                
                    game_scene2_horse_req2:
                        call getaction                                        ; gestisce la prima scelta se si ha scelto questa storia
                        cmp al, 'a'
                        je game_scene2_req2_kill
                        cmp al, 's'
                        je game_scene2_req2_knock
            
                        jmp game_scene2_horse_req2
                    
                        game_scene2_req2_kill:
                            call clearchat 
                            ; -- ucide la guardia che riposa --
                            
                            mov ah, 13h                                          ; stampo la parola cadavere al posto del
                            mov al, 0h                                           ; nome di nicolas
                            mov bl, 0fh
                            mov bh, 3h
                            mov dl, 70d
                            mov dh, 7d
                            mov cx, 8h
                            mov bp, offset entity_dead_body
                            int 10h
                
                            mov ah, 2h
                            mov dh, 8d
                            mov dl, 72d
                            int 10h
                            
                            mov ah, 9h
                            mov al, '.'
                            mov bh, 3h
                            mov bl, 0ch
                            mov cx, 1h
                            int 10h
                            
                            mov ah, 2h
                            mov dh, 8d
                            mov dl, 75d
                            int 10h
                            
                            mov ah, 9h
                            mov al, '.'
                            mov bh, 3h
                            mov bl, 4h
                            mov cx, 1h
                            int 10h    
                                
                            mov ah, 2h
                            mov dh, 6d
                            mov dl, 76d
                            int 10h
                            
                            mov ah, 9h
                            mov al, ','
                            mov bh, 3h
                            mov bl, 4h
                            mov cx, 1h
                            int 10h
                            
                            
                            ; abbasare karma
                            sub karma, 2h
                            
                            mov di, 280d 
                            mov si, 282d   
                            call printchat 
                            
                            call getaction 
                            call clearchat
                            
                            jmp  game_scene2_req2_end  
                       
                        game_scene2_req2_knock:
                            call clearchat 
                            
                            ; alzare karma
                            mov di, 283d 
                            mov si, 284d   
                            call printchat 
                            
                            call getaction 
                            call clearchat
                            
                            jmp  game_scene2_req2_end
                   
                        game_scene2_req2_end:    
                        
                    ; -- stampa dialoghi --
                    
                    mov di, 285d 
                    mov si, 287d   
                    call printchat 
                    
                    call getaction 
                    call clearchat 
                    
                    
                    mov ch, 71                                          
                    mov cl, 6
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat 
                    
                    
                    mov ch, 53                                         
                    mov cl, 13
                    mov bl, 'X' 
                    mov bh, 03h
                    call writecharat
                    
                    mov dh, 13d                                               ; coloro il personaggio nel bar
                    mov dl, 53d
                    mov bl, color
                    call colorchar
                    
                    mov di, 288d 
                    mov si, 292d   
                    call printchat 
                    
                    call getaction 
                    call clearchat
                    
                    mov di, 293d 
                    mov si, 297d   
                    call printchat 
                    
                    call getaction 
                    call clearchat 
                    
                    mov di, 297d 
                    mov si, 301d   
                    call printchat 
                    
                    call getaction 
                    call clearchat
                    
                    
                    mov dh, 1d                                               ; coloro il personaggio nel bar
                    mov dl, 69d
                    mov bl, color
                    call colorchar 
                    
                    mov dh, 1d                                               ; coloro il personaggio nel bar
                    mov dl, 70d
                    mov bl, color
                    call colorchar
                    
                    mov dh, 1d                                               ; coloro il personaggio nel bar
                    mov dl, 71d
                    mov bl, color
                    call colorchar 
                    
                    mov ch, 53                                        ; cambia l'orario
                    mov cl, 13
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat 
                    
                    mov ch, 70                                         ; cambia l'orario
                    mov cl, 1
                    mov bl, 'X' 
                    mov bh, 03h
                    call writecharat
                    
                    mov di, 303d 
                    mov si, 306d   
                    call printchat 
                    
                    call getaction 
                    call clearchat
                    
                    
                    ;sposti il cavallo e cassius alla fine del traggito
                    
                    mov ch, 69                                          
                    mov cl, 1
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat
                    
                    mov ch, 70                                          
                    mov cl, 1
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat 
                    
                    mov ch, 71                                          
                    mov cl, 1
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat
                    
                    mov ch, 23                                         
                    mov cl, 15
                    mov bl, '<' 
                    mov bh, 03h
                    call writecharat 
                    
                    mov dh, 15d                                               ; coloro il personaggio nel bar
                    mov dl, 23d
                    mov bl, color
                    call colorchar        
                    
                    mov ch, 24                                          
                    mov cl, 15
                    mov bl, 'X' 
                    mov bh, 03h
                    call writecharat 
                    
                    mov dh, 15d                                                
                    mov dl, 24d
                    mov bl, color
                    call colorchar
                    
                    mov ch, 25                                          
                    mov cl, 15
                    mov bl, ']' 
                    mov bh, 03h
                    call writecharat
                    
                    mov dh, 15d                                                
                    mov dl, 25d
                    mov bl, color
                    call colorchar
                    
                    
                    mov di, 308d 
                    mov si, 310d   
                    call printchat 
                    
                    call getaction 
                    call clearchat
                    
                    ; Arrivi nel regnio di Ruswick  
                     
                    mov si, offset file_scene2_runswick_path                  ; apre il file con la scena dopo che sei svenuto fuori dalle mura
                    mov di, 0h                                               ; imposta la modalita di lettura
                    call open_file                                           ; apre il file
                    
                    mov si, offset file_buffer                               ; carica il buffer
                    mov di, file_frame_size
                    call load_frame
                    
                    mov bh, 3h                                               ; lo stampa nella pagina corrente
                    call print_frame_at 
                    
                    
                    mov dh, 11d                                              
                    mov dl, 74d
                    mov bl, color
                    call colorchar 
                    
                    
                    mov dh, 11d                                                
                    mov dl, 73d
                    mov bl, color
                    call colorchar
                    
                    mov dh, 11d                                                
                    mov dl, 72d
                    mov bl, color
                    call colorchar
                    
                    
                    
                    mov di, 311d 
                    mov si, 312d   
                    call printchat 
                    
                    call getaction 
                    call clearchat 
                    
                    
                    mov di, 312d 
                    mov si, 315d   
                    call printchat 
                    
                    call getaction 
                    call clearchat
                    
                    ; -- sposta il cavallo davanti alla porta --
                    
                    
                    mov ch, 72                                          
                    mov cl, 11
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat 
                    
                    mov ch, 73                                      
                    mov cl, 11
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat
                    
                    mov ch, 74                                       
                    mov cl, 11
                    mov bl, ' ' 
                    mov bh, 03h
                    call writecharat  
                    
                    
                    mov ch, 8                                         
                    mov cl, 10
                    mov bl, '<' 
                    mov bh, 03h
                    call writecharat 
                    
                    mov dh, 10d                                                
                    mov dl, 8d
                    mov bl, color
                    call colorchar
                    
                    
                    mov ch, 9                                          
                    mov cl, 10
                    mov bl, 'X' 
                    mov bh, 03h
                    call writecharat  
                    
                    mov dh, 10d                                                
                    mov dl, 9d
                    mov bl, color
                    call colorchar
                    
                    mov ch, 10                                          
                    mov cl, 10
                    mov bl, ']' 
                    mov bh, 03h
                    call writecharat
                    
                    mov dh, 10d                                               
                    mov dl, 10d
                    mov bl, color
                    call colorchar 
                    
                    
                    mov di, 316d 
                    mov si, 318d   
                    call printchat 
                    
                    call getaction 
                    call clearchat  
                    
                    mov di, 319d 
                    mov si, 321d   
                    call printchat 
                    
                    call getaction 
                    call clearchat   
                    
                    jmp game_scene2_end
    game_scene2_end:
    
    mov si, offset file_scene2_end_path                       ; stampa la fine del secondo capitolo
    mov di, 0h
    call open_file
    
    mov si, offset file_buffer
    mov di, file_frame_size
    call load_frame
    
    mov bh, 3h
    call print_frame_at
    
    mov al, 3d
    call switchto
    
    call getkey
    
    jmp game_req                                              ; torna al menu principale quando la demo del gioco finisce
        
    jmp end_error_handler
            
; ---- Gestisce ogni tipo di errore nel programma ----
    
    ; -- gestisce errori riguardanti i file --   
    error_file::
                                                              ; dichiarare le etichette globalmente (::)
        cmp ax, 2h                                            ; controlla il codice di errore in ax e stampa il messaggio
        je error_file_fnf                                     ; opportuno ad esso
        
        cmp ax, 5h
        je error_file_fad
        
        cmp ax, 6h
        jmp error_file_nau
        
        error_file_fnf:
            mov dx, offset error_file_notfound
            jmp error_file_end
               
        error_file_fad:
            mov dx, offset error_file_denied
            jmp error_file_end
        
        error_file_nau:
            mov dx, offset error_file_notauth
            jmp error_file_end
            
        error_file_unk:
            mov dx, offset error_file_generic
        
        error_file_end:
        mov ah, 9h
        int 21h 
                  
        jmp end_error_handler
    
    ; -- gestisce gli errori relativi ai buffer di output --    
    error_buffer::                                            ; per il buffer ci sono errori troppo generici, quindi si stampa
                                                              ; un unico messaggio
        mov dx, offset error_buffer_generic
        mov ah, 9h
        int 21h
        
        jmp end_error_handler
        
    error_choice_currupted::
        
        mov dx, offset error_choice_currupt
        mov ah, 9h
        int 21h
        
        jmp end_error_handler    
    end_error_handler:
    
    jmp __end__    
endp    

;
; Salva la partita attuale nel file
; 
save_game proc
    
    pusha    
    
    mov si, offset file_saving
    mov di, 1h                                         
    call open_file
    
    ; salva il karma nel file                                                                                      
    mov dx, 0h
    mov dl, karma
    mov cx, 1h
    mov bx, file_handle
    mov ah, 40h
    int 21h
    
    ; salva la scena in cui sei nel file
    mov dx, 0h
    mov dl, current_checkpoint                            
    mov cx, 1h
    mov bx, file_handle
    mov ah, 40h
    int 21h                            
                                                                                                 
    
    ; salva il colore del menu
    mov dx, 0h                                            ; essendo che color e karma sono a 8 bit resetto il registro intero
    mov dl, color                                         ; e scrivo solo sulla parte bassa
    mov cx, 1h
    mov bx, file_handle
    mov ah, 40h
    int 21h
    
    call close_file
    
    ; -- stampa a schermo la scritta della partita salvata --
    mov bp, offset game_saved
    mov ah, 13h
    mov al, 0h
    mov bh, 3h
    mov bl, 0ah
    mov dl, 26d
    mov dh, 24d
    mov cx, 27d
    int 10h
    
    call getkey
    
    mov ah, 2h
    mov dl, 26d
    mov dh, 24d
    int 10h
    
    mov ah, 9h
    mov al, ' '
    mov bh, 3h
    mov bl, 0fh
    mov cx, 27d
    int 10h
    popa
    ret    
endp

;
; Gestisce la logica quando l'utente preme il pulsante di pausa
;
pause proc
    
    pusha
    
    mov al, 4d                                                  ; cambia la pagina corrente alla pagina di pausa
    call switchto
    pause_invalid_key:   
        call getkey                                             ; chiede cosa vuole fare l'utente nel menu di pausa
        
        cmp al, 'r'                                             ; premere 'r' se vuole riprendere la partita
        je pause_end
        cmp al, 1bh                                             ; in caso l'utente prema il pulsante esc o il tasto
        je pause_exit                                           ; 'e' esce al menu principale
        cmp al, 'e' 
        je pause_exit
        jmp pause_invalid_key
        
    pause_exit:
    
    jmp game_req                                                ; va al menu
    
    pause_end:                                                  ; la funzione finisce senza problemi
    mov al, 3d                                                  ; cambia la pagina mettendola a quella del gioco (3)
    call switchto
    popa
    
    ret    
endp  

;
; Carica una partita precedentemente salvata
;
load_game proc
    
    pusha
    
    mov si, offset file_saving
    mov di, 0h
    call open_file
    
    mov dx, offset file_buffer
    mov bx, file_handle
    mov cx, 2h
    mov ah, 3Fh
    int 21h    
    
    call close_file
    
    ; -- ripristina i valori salvati nel file
    mov al, [file_buffer]
    mov karma, al

    load_game_setcolor:
            
    mov al, [file_buffer + 2]   
    mov color, al        
    
    ; -- stampa a schermo la scritta della partita caricata --
    mov bp, offset game_loaded
    mov ah, 13h
    mov al, 0h                                     ; attributi
    mov bh, 3h                                     ; pagina
    mov bl, 6h                                     ; colore arancione
    mov dl, 26d                                    ; coordinate
    mov dh, 24d
    mov cx, 28d                                    ; byte da scrivere
    int 10h
    
    call getkey
    
    mov ah, 2h
    mov dl, 26d
    mov dh, 24d
    int 10h
    
    mov ah, 9h
    mov al, ' '
    mov bh, 3h
    mov bl, 0fh
    mov cx, 28d
    int 10h
    
    popa
                     
    ; controlli dove l ultimo salvataggio e salti al capitolo dove hai eseuito il salvataggio
    mov dx, 0h
    mov dl, [file_buffer + 1] 
    
    mov ax, 0h
    
    mov al, 1h
    cmp dx, ax
    je load_game_goto_checkpoint1
    
    mov al, 2h
    cmp dx, ax
    je load_game_goto_checkpoint2
    jmp error_choice_currupted
    
    load_game_goto_checkpoint1:
        pop ax                                       ; pop ax serve a togliere l'indirizzo dell IP con la chiamata a funzione
        jmp game_checkpoint1                         ; di load_game
    load_game_goto_checkpoint2:
        pop ax
        jmp game_checkpoint2
    
    ret
endp

;
; Carica nelle varie finestre tutti i requisiti del gioco come schermate di caricamento, mappe, menu, ecc...
;
; Descrizione pagine:
; S0 - menu e correlati
; S1 - mappa della citta in cui ti trovi
; S2 - mappa del mondo
; S3 - principale UI di gioco
; S4 - menu di pausa
; S5 - pergamena delle storie / schermata caricamento frame 1
; S6 - animazione caricamento frame 2
; S7 - animazione caricamento frame 3
;
gameload proc
    
    pusha
    
    ; caricamento pagina 1 (Mappa locale) 
    
    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_local_map_lerwick_path         ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 1h                                         ; imposta 1h come pagina di destinazione per la stampa
    call print_frame_at                                ; stampa il buffer nella pagina selezionata                 
    
     
    ; caricamento pagina 2 (Mappa del mondo)    
                    
    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_global_map_path                ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 2h                                         ; imposta 2h come pagina di destinazione per la stampa
    call print_frame_at                                ; stampa il buffer nella pagina selezionata                 
    
    
    ; caricamento pagina 3 (UI del gioco) 
    
    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_scene1_bar_path                ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 3h                                         ; imposta 3h come pagina di destinazione per la stampa
    call print_frame_at                                ; stampa il buffer nella pagina selezionata                 
    
    mov dh, 8d                                        ; coloro il personaggio nel bar
    mov dl, 33d
    mov bl, color
    call colorchar   
    
    mov dh, 19d
    mov dl, 55d
    mov bl, color
    call colorchar                                     ; colora il personaggio della legenda
    
    
    ; caricamento pagina 4 (Menu di pausa)
          
    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_pause_path                     ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 4h                                         ; imposta 4h come pagina di destinazione per la stampa
    call print_frame_at                                ; stampa il buffer nella pagina selezionata
                    
    ; caricamento pagina 5 (Pergamena)
    
    mov di, 0h                                         ; imposta la modalita di apertura del file (lettura = 0)
    mov si, offset file_prologue_scroll_path           ; sposta in SI l'indirizzo del nome del file da aprire
    call open_file                                     ; apre il file
    
    mov si, offset file_buffer                         ; sposta in SI l'indirizzo del buffer 
    mov di, file_frame_size                            ; sposta la grandezza del buffer in DI
    call load_frame                                    ; carica il buffer con i primi DI caratteri del file
    
    call close_file                                    ; chiude il file
    
    mov bh, 5h                                         ; imposta 5h come pagina di destinazione per la stampa
    call print_frame_at                                ; stampa il buffer nella pagina selezionata                                                      
    
    ; caricamento pagina 6 (vuota)
                                                       
    ; caricamento pagina 7 (vuota)
    

    popa
    
    ret    
endp   
 
;
; Colora un carattere ad una data posizione con un certo colore.
; Stampa sempre alla 3a pagina.
;
; Parametri:
; DX - Coordinate del carattere (DH = riga, DL = colonna)
; BL - Colore in binario (0000_0000b) primi 4 bit background e ultimi 4 colore carattere
;
colorchar proc
    pusha
    
    mov ah, 2h                                         ; Colora la mappa
    mov bh, 3h                                         ; DX e' gia impostata dal parametro
    int 10h
    
    mov ah, 8h                                         ; legge il carattere alla posizione del cursore
    mov bh, 3h                                         ; e salva il carattere in AL
    int 10h
    
    mov ah, 9h                                         ; inserisce codice dell'interrupt
    mov bh, 3h                                         ; inserisce la pagina su cui stampare
    mov cx, 1h
    int 10h
        
    popa    
    ret    
endp
;
; Stampa dalla linea si alla linea di nella pergamena partendo
; dalla linea piu in alto.
;
; Parametri:
; CL - linea di inizio lettura (compresa)
;
printstory proc
    
    pusha
    
           
    ; apre il file
    mov si, offset file_scroll_text_path               ; apre il file dove c'e' il testo della prima storia
    mov di, 0h
    call open_file
   
    mov bx, file_handle                                ; sposta l'handle del file in BX
    
    ; imposta il valore dell'offset per le righe (n righe * grandezza riga)
    mov ax, 0h                                         ; imposta AX a 0
    mov al, cl                                         ; sposta il numero di linee da saltare a inizio file
    mul line_scroll_size                               ; moltiplica ogni linea per la grandezza di essa (60)
    mov dx, ax                                         ; sposta il valore ottenuto in dx
    mov ah, 42h                                        ; imposta il codice dell'interrupt
    mov al, 0h                                         ; imposta AL a 0 per l'origine dell offset
    mov cx, 0h                                         ; CX dovrebbe indicare anch'esso l inizio dell offset
    int 21h                                            ; sposta il file pointer alla posizione desiderata
    
    mov dh, 3d                                         ; imposta la distanza nel DOS dall'alto (y)
    
    printstory_load:                                   ; stampa il buffer lentamente calcolando l'offset
                                                       ; nell immagine della pergamena
         
        ; carica il buffer
        mov si, offset file_buffer                     ; carica una linea della storia nel buffer 
        mov di, line_scroll_size                       ; imposta la grandezza da leggere
        call load_frame 
         
        cmp ax, 0h                                     ; se AX e' 0 allora siamo arrivati alla fine del file e
        je printstory_end                              ; interrompe il ciclo
        
        ; imposta la posizione del cursore
        mov ah, 02h                                    ; codice dell'interrupt
        
        mov dl, 10d                                    ; imposta la distanza iniziale da sinistra (x)
        mov bh, 5h                                     ; imposta la pagina (vedi gameload per le pagine)
        int 10h 
        
        mov bx, offset file_buffer                     ; sposta in BX il buffer da stampare carattere per carattere
        mov cx, bx                                     ; sposta l'indirizzo del buffer in CX e gli aggiunge la grandezza
        add cx, line_scroll_size                       ; di una riga in modo da avere l'indirizzo di inizio e di fine del buffer
        
        mov ah, 0eh                                    ; imposta il codice per il teletype output (stampa un carattere alla
                                                       ; volta e aggiorna la posizione del cursore
        
        printstory_print:
            cmp [bx], '$'                              ; controlla se il valore puntato da BX e' un $, in quel caso la linea e'
            je printstory_print_end                    ; finita e passa direttamente a stampare la prossima linea
            
            mov al, [bx]                               ; sposta in AL il valore puntato da BX e lo stampa a schermo
            int 10h
            inc bx                                     ; incrementa il puntatore di BX
            cmp bx, cx                                 ; controlla che il valore non sfori la grandezza del buffer
            jb printstory_print                        ; se non sfora continua a stampare
                    
    printstory_print_end: 
    
    inc dh                                             ; incrementa la riga che si trova in DH e controlla che non sia 
    cmp dh, 19d                                        ; arrivata alla fine della pergamena a 19, se siamo arrivati a
    jb printstory_load                                 ; 19 allora significa che non abbiamo piu spazio nella pegamena
                                                       ; quindi finisce di stampare
    printstory_end:
        
    popa
    
    ret    
endp

;
; Scrive una lettera alla posizione (x:CH,y:CL)
; 
; Parametri:
; CH - coordinata x
; CL - coordinata y
; BL - lettera da scrivere
; BH - pagina in cui scrivere il carattere
;
writecharat proc
    
    pusha                                                     ; fa un backup di tutti i registri
        
    mov ah, 2h                                                ; sposta il cursore a quella posizione
    mov dh, cl 
    mov dl, ch                                                ; incrementa i registri dh e dl
    int 10h
    
    mov ah, 0ah                                               ; stampa il carattere a quella posizione
    mov al, bl
    mov cx, 1h
    int 10h
    
    popa                                                      ; ripristina i registri
    
    ret
endp

;
; Gestisce i vari input dell utente durante la storia. Input base + tasti speciali
;
getaction proc
    
    getaction_input:
    mov al, 3d                                                ; cambia la pagina mettendola a quella di deafult della scena (3)
    call switchto
    mov ah, 0h                                                ; impsota il valore dell interrupt
    int 16h                                                   ; l'interrupt ritorna il valore inserito in AL
    
    cmp al, ';'
    je getaction_pause
    cmp al, 'm'
    je getaction_show_global_map
    cmp al, 'l'
    je getaction_show_local_map
    cmp al, '.'
    je getaction_save
    cmp al, ','
    je getaction_load
    jmp getaction_end
    getaction_pause:
        call pause
        
        jmp getaction_input 
    
    getaction_show_global_map:
        mov al, 2d                                            ; cambia la pagina mettendola a quella della mappa del mondo (2)
        call switchto                                         ; e dopodiche aspetta un nuovo input dell utente
        mov ah, 0h
        int 16h
        
        jmp getaction_input
    
    getaction_show_local_map:
        mov al, 1d                                            ; cambia la pagina mettendola a quella della mappa locale (1)
        call switchto                                         ; e dopodiche aspetta un nuovo input dell utente
        
        mov ah, 0h
        int 16h
        
        jmp getaction_input
    getaction_save:                                           ; salva la partita in un file (non ancora implementata)
        call save_game
        
        jmp getaction_input
    
    getaction_load:                                           ; carica una partita dal file di salvataggio (non ancora implementata)
        call load_game
        
        jmp getaction_input    
    
    getaction_end:
    ret
endp

;
; Aspetta l'input dalla keyboard
;
getkey proc
                                                              ; salva tutti i registri
    mov ah, 0h                                                ; impsota il valore dell interrupt
    int 16h                                                   ; l'interrupt ritorna il valore inserito in AL
                                                              ; per quello utilizzo pusha/popa        
    ret
endp   

;
; Cambia la pagina corrente   
;
; Parametri:
; AL - numero di pagina da andare
;
switchto proc
    
    pusha                                                      ; salva i registri nello stack
    
    cmp al, 8h                                                 ; controlla se il valore di input non sia maggiore o uguale a 8
    jae switchto_end
    
    mov ah, 5h                                                 ; cambia la pagina in base al parametro passato
    int 10h
    
    switchto_end:
    
    popa                                                       ; ripristina i registri dallo stack
    
    ret
endp

;
; Aspetta x secondi (Verificata)
; 
; Parametri:
; SI - tick da aspettare (1s = 18 tick)
;
timer proc          
    
    pusha                                                      ; salva i registri
            
    mov ah, 0h                                                 ; chiama una volta l'interrupt del tempo per controllare il
    int 1ah                                                    ; numero di tick correnti
    
    mov bx, dx                                                 ; salva il tempo in cui inizia l'interrupt in bx
    time:
                                                               ; continua a chiamare l interrupt finche il tempo di inizio - il
                                                               ; tempo corrente < di x secondi
        int 1ah
        
        sub dx, bx
        
        cmp dx, si                                             ; cx/18 secondi 
        jbe time                                               
        
    popa                                                       ; ripristina i registri e ritorna
    ret
endp

;
; Fa vedere la schermata di caricamento con l'animazione
; 
setloadingscreen proc
    
    pusha
    
    mov cx, 3h                                                 ; calcolo il numero random della scena
    call getrandom
                                                               ; in base alla scelta si vedra una scena diversa ogni
    cmp dl, 00h                                                ; volta
    je animation1
    cmp dl, 01h
    je animation2
    cmp dl, 02h
    je animation3
      
    animation1: 
        
        ; -- stampa prima scena --
        
                                                                    ; stampa prima i frame nelle pagine non attive cosi
        mov si, offset file_loading1_frm1_path                      ; stampa ora il frame sulla pagina attiva
        mov di, 0h                                                  ; apre il file del seconda animazione primo frame
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file
        
        mov bh, 5h
        call print_frame_at                                         ; stampa il file nella pagina attiva
       
        ; -- stampa primo consiglio --
        
        mov cx, 7h                                                  ; calcolo il numero random per il tip del giorno
        call getrandom                                              ; salva il risultato nello stack
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        push dx                                                     ; salvo il valore generato a caso nello stack
        mov cx, dx
        cmp cx, 0h
        je end1offset1
        
        set1offset1:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop set1offset1
        end1offset1:
            
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 5h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 5h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h
        
        ; -- stampa seconda scena --
         
       
        call close_file                                             ; chiude il file delle frasi
        
        
        mov si, offset file_loading1_frm2_path                      ; apre il file della seconda animazione secondo frame
        mov di, 0h
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file 
        
        mov bh, 6h                                                  ; stampa il frame sulla sesta pagina
        call print_frame_at
        
        ; -- stampa secondo consiglio --
        
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        
        pop cx                                                      ; ripristina dx e lo salva nuovamente
        push cx                                                     ; salvo il valore generato a caso nello stack
        cmp cx, 0h
        je end1offset2
        
        set1offset2:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop set1offset2
        end1offset2:
        
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 6h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 6h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h  
        
        ; -- stampa terza scena --
        
        
        mov al, 6h                                                  ; cambia la pagina e va nell'animazione successiva
        call switchto
        
        mov si, offset file_loading1_frm3_path                      ; apre il file della seconda animazione terzo frame
        mov di, 0h
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file
        
        mov bh, 7h                                                  ; stampa il frame sulla settima pagina
        call print_frame_at

        ; -- stampa terzo consiglio --
        
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        pop cx                                                      ; ripristina dx e lo salva nuovamente                              
        cmp cx, 0h
        je endoffset3
        
        setoffset3:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop setoffset3
        endoffset3:
        
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 7h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 7h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h
       
        mov al, 7h                                                  ; cambia la pagina e va nell'animazione successiva
        call switchto
        
        jmp animation_end
    animation2:       
        
        ; -- stampa prima scena --
        
        mov si, offset file_loading2_frm1_path                      ; stampa ora il frame sulla pagina attiva
        mov di, 0h                                                  ; apre il file del seconda animazione primo frame
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file
   
        mov bh, 5h
        call print_frame_at                                         ; stampa il file nella pagina attiva
                                                                    ; stampa prima i frame nelle pagine non attive cosi
                                                                    ; l utente non dovra aspettare tanto
        ; -- stampa primo consiglio --
        
        mov cx, 6h                                                  ; calcolo il numero random per il tip del giorno
        call getrandom                                              ; salva il risultato nello stack
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        push dx                                                     ; salvo il valore generato a caso nello stack
        mov cx, dx
        cmp cx, 0h
        je end2offset1
        
        set2offset1:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop set2offset1
        end2offset1:
            
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 5h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 5h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h

        ; -- stampa seconda scena --
        
        
        mov si, offset file_loading2_frm2_path                      ; apre il file della seconda animazione secondo frame
        mov di, 0h
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file 
        
        mov bh, 6h                                                  ; stampa il frame sulla sesta pagina
        call print_frame_at
        
        ; -- stampa secondo consiglio  --
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        
        pop cx                                                      ; ripristina dx e lo salva nuovamente
        push cx                                                     ; salvo il valore generato a caso nello stack
        cmp cx, 0h
        je end2offset2
        
        set2offset2:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop set2offset2
        end2offset2:
        
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 6h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 6h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h
        
        ; -- stampa terza scena --

        
        mov al, 6h                                                  ; cambia la pagina e va nell'animazione successiva
        call switchto
        
        mov si, offset file_loading2_frm3_path                      ; apre il file della seconda animazione terzo frame
        mov di, 0h
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file
        
        mov bh, 7h                                                  ; stampa il frame sulla settima pagina
        call print_frame_at
        
        ; -- stampa terzo consiglio  --
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        pop cx                                                      ; ripristina dx e lo salva nuovamente                              
        cmp cx, 0h
        je end2offset3
        
        set2offset3:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop set2offset3
        end2offset3:
        
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 7h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 7h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h
       
        
        mov al, 7h                                                  ; cambia la pagina e va nell'animazione successiva
        call switchto
                                                                    
                                                                    
        jmp animation_end
    animation3:   
        ; -- stampa prima scena --
        mov si, offset file_loading3_frm1_path                      ; stampa ora il frame sulla pagina attiva
        mov di, 0h                                                  ; apre il file del seconda animazione primo frame
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file
        
        mov bh, 5h
        call print_frame_at                                         ; stampa il file nella pagina attiva
                                                                    ; stampa prima i frame nelle pagine non attive cosi
                                                                    ; l utente non dovra aspettare tanto                                                            
        ; -- stampa primo consiglio --
        
        mov cx, 6h                                                  ; calcolo il numero random per il tip del giorno
        call getrandom                                              ; salva il risultato nello stack
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        push dx                                                     ; salvo il valore generato a caso nello stack
        mov cx, dx
        cmp cx, 0h
        je end3offset1
        
        set3offset1:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop set3offset1
        end3offset1:
            
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 5h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 5h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h

        ; -- stampa seconda scena --

        mov si, offset file_loading3_frm2_path                      ; apre il file della seconda animazione secondo frame
        mov di, 0h
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file 
        
        mov bh, 6h                                                  ; stampa il frame sulla sesta pagina
        call print_frame_at
        
        ; -- stampa secondo consiglio --
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        
        pop cx                                                      ; ripristina dx e lo salva nuovamente
        push cx                                                     ; salvo il valore generato a caso nello stack
        cmp cx, 0h
        je end3offset2
        
        set3offset2:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop set3offset2
        end3offset2:
        
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 6h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 6h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h          
        
        ; -- stampa terza scena --

        mov al, 6h                                                  ; cambia la pagina e va nell'animazione successiva
        call switchto
        
        mov si, offset file_loading3_frm3_path                      ; apre il file della seconda animazione terzo frame
        mov di, 0h
        call open_file         
        
        mov si, offset file_buffer                                  ; carica il contenuto nel file_buffer
        mov di, file_frame_size
        call load_frame
        
        call close_file                                             ; chiude il file
        
        mov bh, 7h                                                  ; stampa il frame sulla settima pagina
        call print_frame_at
        
        ; -- stampa terzo consiglio --
        
        mov si, offset file_sentence_path                           ; apre il file per la frase random del giorno
        mov di, 0h
        call open_file
        
        pop cx                                                      ; ripristina dx e lo salva nuovamente                              
        cmp cx, 0h
        je end3offset3
        
        set3offset3:
            mov si, offset file_buffer                              ; carica il buffer con la prima riga
            mov di, 86d
            call load_frame
            loop set3offset3
        end3offset3:
        
        mov si, offset file_buffer                                   ; carica il buffer con la prima riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 7h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d                                                 
        mov dl, 18d
        mov dh, 20d
        mov bp, offset file_buffer
        int 10h                  
        
        mov si, offset file_buffer                                   ; carica il buffer con la seconda riga
        mov di, 43d
        call load_frame
        
        mov ah, 13h
        mov al, 1h
        mov bl, 0F0h                                                 ; imposta lo sfondo della stringa chiaro
        mov bh, 7h                                                   ; stampa nella pagina corrente e nelle altre pagine
        mov cx, 43d
        mov dl, 18d
        mov dh, 21d
        mov bp, offset file_buffer
        int 10h       
        
        mov al, 7h                                                  ; cambia la pagina e va nell'animazione successiva
        call switchto
        
    animation_end:
        
    mov cx, 3h
    loading_timer:
        
        mov si, 12d
        call timer
        
        mov al, 5h 
        call switchto
        
        mov si, 12d
        call timer
        
        mov al, 6h 
        call switchto
        
        mov si, 12d
        call timer
        
        mov al, 7h 
        call switchto     
        
        loop loading_timer
    setloadingscreen_end:
    popa
    
    ret    
endp 

;
; Carica il contenuto di un frame (80x25) da file in una variabile
; 
; Parametri:
; SI - indirizzo del buffer dove caricare il frame
; DI - grandezza da leggere
;
load_frame proc
               
    pusha                                                     ; salva tutti i registri nello stack
    
    mov ah, 03fh                                              ; imposta il tipo di interrupt
    mov bx, file_handle                                       ; inizializza bx con l'handle del file
    mov cx, di                                                ; imposta la grandezza del buffer (~2kb)
    mov dx, si                                                ; sposta il parametro in dx
    int 21h
    
    cmp ax, 0h                                                ; controlla se siamo alla fine del file
    je load_frame_error                                      
    
    popa                                                      ; ripristina i registri e ritorna 
    mov ax, 01h                                               ; inserisce un valore diverso da 0 per non far sembrare
                                                              ; di essere arrivati alla fine del file
    jmp load_frame_end
    
    load_frame_error:                                         ; se il file e' alla fine del file (EOF) allora imposta AX
    popa                                                      ; a 0
    mov ax, 0h

    load_frame_end:
    
    ret    
endp

;
; Scrive in Al un valore random compreso tra 0 e CX
;
; Parametri:
; CX - valore limite 
;
getrandom proc 
    
    push cx 
    mov ah, 00h                                                     ; salva in CX e DX il tempo in quel momento
    int 1aH        
    
    mov ax, dx                                                      ; sposta il valore di DX in AX (quindi parte del numero)
    mov dx, 0h                                                      ; resetta DX (futuro registro del valore random)
    
    pop cx
    div cx                                                          ; divide il valore in AX per il registro CX passato
                                                                    ; dall'utente
    ret   
endp   


;
; Stampa il buffer a schermo nella pagina selezionata in BH
;
; Parametri:
; BH - indirizzo del buffer da stampare 
;
print_frame_at proc                                                                 
    
    cmp bh, 7h                                                      ; controlla se il valore della pagina e' minore di 8
    ja print_frame_end                                              
                                                                    ; il parametro BH indica in quale delle 8 pagine stampare il
                                                                    ; buffer. Cio molto utile durante i caricamenti.
    pusha                                                           ; salva tutti i registri
    
    mov ah, 13h                                                     ; imposta il codice dell'interrupt
    mov al, 1h                                                      ; imposta la modalita con attributi
    mov bl, 0Fh                                                     ; dice che la scritta dovra' essere stampata con un background
                                                                    ; nero (0x0) e carattere bianco (0xF)
    mov cx, offset file_frame_size - offset file_buffer             ; imposta la grandezza del buffer
    dec cx                                                          ; IMPORTANTE: decrementa CX dato che print_frame utilizza un
                                                                    ; interrupt diverso ha bisogno dell ultimo carattere ($) che
                                                                    ; pero' l'utente non deve vedere, quindi calcolo la lunghezza
                                                                    ; del file e sottraggo l'ultimo carattere
    mov dx, 0h                                                      ; imposta l'inizio della stampa del buffer (dl=0,dh=0)
    mov bp, offset file_buffer                                      ; imposta l'indirizzo del buffer per la grafica
    int 10h                                                         ; chiama l'interrupt per stampare il buffer (BP) alla posizione
                                                                    ; DX nella pagina BH
    popa                                                            ; ripristina tutti i registri
    print_frame_end:
    
    ret    
endp

;
; Stampa il buffer nella pagina attuale con un animazione dal basso verso l'alto.
; Utilizza il buffer default (file_buffer) Stampa il frame alla pagina 0.
;
print_frame proc                                                                 
    pusha                                                           ; salva tutti i registri
    
    mov dx, offset file_buffer                                      ; stampa il buffer utilizzando un 'limite' dell'emulatore
    mov ah, 9h                                                      ; per cui sembra che ci sia un animazione ma in realta e'
    int 21h                                                         ; solo l'emulatore che cerca di non crashare...
    
    popa                                                            ; ripristna tutti i registri
    
    ret    
endp


;
; Apre un file
; 
; Parametri:
; DI - modalita di apertura del file
; SI - indirizzo del nome del file da aprire
; 
open_file proc
    
    pusha                                                     ; salva tutti i registri nello stack  
    
    mov dx, si                                                ; salva l'indirizzo del file in dx
    mov ax, di                                                ; salva la modalita di apertura nel file
    mov ah, 3dh                                               ; apre il file dx in modalita al
    int 21h
    
    jc error_file                                             ; se qualcosa va male, salta all'error handler
    
    mov file_handle, ax                                       ; salva l'handle del file in variabile
    popa
    
    ret
endp

;
; Elimina la variabile dell handle
;
close_file proc
    
    pusha
    
    mov bx, file_handle                                       ; spsoto il file handle in bx
    mov ah, 3eh                                               ; chiudo il file
    int 21h
    
    jc error_file                                             ; in caso di errori va all'error handler
    
    popa
    
    ret
endp

;
; Pulisce la chat
; 
clearchat proc
    
    pusha
    
    mov dh, 18d
     
    clear:
        mov ah, 13h
        mov al, 0h
        mov bh, 3h
        mov bl, 0000_1111b
        mov cx, line_chat_size
        mov dl, 1h
        mov bp, offset line_empty_buffer
        int 10h
        
        inc dh
        cmp dh, 23d
        jb clear  
    
    popa
    
    ret    
endp
;
; Legge una linea dal file e la stampa
;
; Parametri:
; DI - linea di inizio stampa
; SI - linea di fine stampa
;
printchat proc
    
    ; controlla i parametri
    cmp di, si                                                ; controlla se la linea di inizio non e' piu grande della
    jae printchat_end                                         ; linea di fine, se lo e' termina la funzione 
    
    pusha                                                     ; salva tutti i registri nello stack
    
                                                              ; salva nuovamente i parametri per utilizzarlo dopo che
    push di                                                   ; abbiamo aperto il file
    push si
    
    mov di, 0h                                                ; apre il file dove ci sono i vari dialoghi in modalita solo
    mov si, offset file_dialogue_path                         ; lettura (DI = 0)
    call open_file
    
    pop si                                                    ; ripristino parametri della procedura
    pop di
    
    sub si, di                                                ; calcola quante righe stampare e salva il risultato in SI
    
    mov bx, file_handle
    dec di                                                    ; calola l'offset in byte tra l'inizio del file e la
    mov ax, di                                                ; riga da stampare
    mul line_chat_size
    mov dx, ax
    
    mov cx, 0h                                                ; cx e' l'inizio dell offset
    mov ah, 42h                                               ; dopo aver calcolato l'offset sposta il file pointer di x byte
    mov al, 0h                                                ; imposta la modalita dell' interrupt  (0 = parte da inizio file)
    int 21h
    
    mov di, 0h                                                ; una volta calcolato l'offset DI non ci serve piu per il valore che
                                                              ; ha, quindi verra utilizzato come counter per il numero di linee da
                                                              ; stampare
    mov bp, si                                                ; copia SI, ovvero il numero di linee da stampare, e lo sposta in BP
    printchat_read:                                               
        
        push di
        
        mov si, offset file_buffer                            ; carica il buffer con una linea del file di testo
        mov di, line_chat_size                              ; inserisce la grandezza della linea                      
        call load_frame
        
        pop di
        
        inc di                                                ; incrementa DI, ovvero il numero di linea in cui stampare il
        call printat                                          ; buffer. Da 1 (linea piu in alto) a 5 (linea piu bassa)
        
        cmp di, bp                                            ; controlla se il counter e' arrivato fino alla linea massima da stampare
        jb printchat_read
    
    call close_file                                           ; quando ha finito di stampare tutte le linee chiude il file
    popa                                                      ; e ripristina tutti i registri
    
    printchat_end:                                            ; etichetta in caso di errori della procedura
    
    ret    
endp

;
; Stampa una linea della chat ad una certa posizione
;
; Parametri:
; DI - numero linea (1 - 5)
;
printat proc
    
    pusha
    
    cmp di, 0h                                                ; controlla se DI si trova tra 0 e 6 esclusi, se il valore 
    jbe printat_end                                           ; non e' in questo range allora significa che e' stato richiesto
    cmp di, 6h                                                ; di scrivere in una parte di schermo che contiene parte della 
    jae printat_end                                           ; grafica, quindi termina la procedura
    
    mov ah, 02h                                               ; calcola l'offset del cursore (02h = imposta posizione del cursore)
    mov bh, 3h                                                ; seleziona la terza pagina (quella in cui la UI di gioco si trova
    mov dh, text_Y    ; row
    mov dl, text_X    ; column
    
    cmp di, 1h                                                ; incrementa dh di x volte, dove x e' il numero di linea da sovra-
    je printat_inc_end                                        ; scrivere. Dato che la variabile numerica e' 16bit non posso spostarla
                                                              ; in registro da 8bit, ho usato un ciclo per farlo quindi
    printat_inc:
        inc dh
        dec di
        cmp di, 1h
        ja printat_inc
        
    printat_inc_end:    
    int 10h                                                   ; chiama l'interrupt per spostare il cursore una volta calcolate le
                                                              ; coordinate nuove del cursore
                                                              
                                                              ; imposta dati costanti del loop: ah (tipo di int) e indirizzo di
                                                              ; memoria in cui finira il buffer
    mov bx, offset file_buffer                                ; sposta l'indirizzo di memoria del buffer della linea
    mov cx, bx                                                ; copia l'indirizzo in CX, aggiunge la grandezza del buffer a CX
    add cx, line_chat_size                                    
   
    mov ah, 0eh                                               ; imposta il tipo di interrupt
    
    printat_print:                                            ; sposta in AL il carattere puntato da BX
        mov al, [bx]                                          ; controlla se il valore puntato e' un '$', in quel caso significa
        cmp al, '$'                                           ; che la linea e' finita e termina la procedura
        je printat_end
        
        int 10h                                               ; chiama l'interrupt per stampare un singolo carattere preso da AL
        inc bx                                                ; incrementa il puntatore del buffer
        cmp bx, cx                                            ; controlla se il puntatore del buffer e' minore del puntatore + la
        jb printat_print                                      ; lunghezza del buffer, se lo e' fa un altro ciclo
    
    printat_end:
    
    popa                                                      ; ripristina i registri
    
    ret  
endp

__end__:
end