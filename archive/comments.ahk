


;*****************************************************************
;     EXAMPLE OF MIDI TO KEYPRESS -
;*****************************************************************
;if  (type = "NoteOn" And number  = "36")  ; Example - if  msg is midi noteOn AND note# 36 - trigger msg box - could trigger keycommands
;{
; MsgBox, 0, , Note %number%, 1          ; show the msgbox with the note# for 1 sec


;msgbox,,,rules %CC_num%,1


;UNCOMMENT LINE BELOW TO SEND A KEYPRESS WHEN NOTE 36 IS RECEIVED
;send , {NumLock} ; send a keypress when note number 20 is received.
;  }

;*****************************************************************
; Compare statusbyte of recieved midi msg to determine type of
; You could write your methods under which ever type of  midi you want to convert

; RETHINK HOW THESE ARE ORGANIZED AND MAYBE TO IT BY LINE
;*****************************************************************

; =============== Is midi input a Note On or Note off message?  ===============
; If statusbyte between 128 and 159 ; see range of values for notemsg var defined in autoexec section. "in" used because ranges of note on and note off
;	{ ; beginning of note block



if statusbyte between 144 and 159 ; detect if note message is "note on"
;*****************************************************************
;    PUT ALL "NOTE ON" TRANSFORMATIONS HERE
;*****************************************************************
ifequal, number, 57  ;  if the note number coming in is note # 20
{
  ;MsgBox, 64, Note on Note = %number%, Note %number%, 1
  ;number := (number +1) ; transpose that note up 1 note number
  gosub, RelayNote ; send the note out.
}

if statusbyte between 128 and 143 ; detect if note message is "note off"

;gosub, ShowMidiInMessage
;GuiControl,12:, MidiMsOut, noteOff:%statusbyte% %chan% %number% %value%  ; display note off in gui

; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! above  end of no edit

; =============== add your note rules here ==; ===============



/*
      Write your own note filters and put them in this section.
      Remember number for a noteon/off is the note number, value is the velocity of that note.
      example
      ifequal, number, 20 ; if the note number coming in is note # 20
        {
          number := (do something in here) ; could be do something to the velocity(value)
          gosub, SendNote ; send the note out.
        }
  */
; ++++++++++++++++++++++++++++++++ examples of note rules ++++++++++ feel free to add more.

/*
      ;*****************************************************************
      ; ANOTHER MIDI TO KEYPRESS EXAMPLE
      ;*****************************************************************

      ifequal, number, 30 ; if the note number coming in is note # 30
        {
          send , {NumLock} ; send a keypress when note number 20 is received.
        }

      ; a little more complex filter two notes
      if ((number != 60) and (number != 62)) ; if note message is not(!) 60 and not(!) 62 send the note out - ie - do nothing except statements above (note 20 and 30 have things to do) to it.
        {
            gosub, SendNote ; send it out the selected output midi port
            ;msgbox, ,straight note, note %number% message, 1 ; this messagebox for testing only.
        }

      IfEqual, number, 60 ; if the note number is middle C (60) (you can change this)
        {
            number := (number + 5) ;transpost up 5 steps
            gosub, SendNote ;(h_midiout, note) ;send a note transposed up 5 notes.
            ;msgbox, ,transpose up 5, note on %number% message, 1 ; for testing only - show msgbox for 1 sec
        }

      IfEqual, number, 62 ; if note on is note number 62 (just another example of note detection)
        {
            number := (number -5) ;transpose down 5 steps
            gosub, SendNote
            ;msgbox, ,transpose down 5, note on %number% message, 1 ; for testing only, uncomment if you need it.
        }
    ; ++++++++++++++++++++++++++++++++ End of examples of note rules  ++++++++++
    ;}
*/

; =============== IS INCOMING MIDI MESSAGE A CC?  ----
;*****************************************************************
;   IS INCOMING MSG IS A CC?
;*****************************************************************


/*
     IfEqual, number, 7
      {
     ;  msgbox, ,,7,1
       CC_num := (number + 3) ; Will change all cc#'s up 3 for a different controller number
        ;CCintVal = value
         gosub, RelayCC
      return
      }
    ifEqual, number, 20
    {
      CC_num := 60
    ;  MsgBox,,,20,1
       gosub, RelayCC
       return
    }
    Else
    {
    CC_num := number
    gosub, RelayCC ; relay message unchanged
   ; MsgBox,,,else %number%,1
    return
    }

; ++++++++++++++++++++++++++++++++ examples of cc rules ends ++++++++++++
   }

  ;*****************************************************************
  ; IS INCOMING MSG A PROGRAM CHANGE MESSAGE?
  ;*****************************************************************
  if statusbyte between 192 and 208  ; check if message is in range of program change messages for number values. ; !!!!!!!!!!!! no edit
    {
      ;*****************************************************************
      ; PUT ALL PC TRANSFORMATIONS HERE
      ;*****************************************************************

    ; ++++++++++++++++++++++++++++++++ examples of program change rules ++++++++++
      ; Sorry I have not created anything for here nor for pitchbends....

      ;GuiControl,12:, MidiMsOut, ProgC:%statusbyte% %chan% %number% %value%
          ;gosub, ShowMidiInMessage
      gosub, sendPC
          ; need something for it to do here, could be converting to a cc or a note or changing the value of the pc
          ; however, at this point the only thing that happens is the gui change, not midi is output here.
          ; you may want to make a SendPc: label below
    ; ++++++++++++++++++++++++++++++++ examples of program change rules ++++++++++
    }
  ;msgbox filter triggered
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  end of edit section
*/



/* =============================

THIS SECTION MOVED

;*************************************************
;*          MIDI OUTPUT LABELS TO CALL
;*************************************************

SendNote:   ;(h_midiout,Note) ; send out note messages ; this should probably be a funciton but... eh.
  ;{
    ;GuiControl,12:, MidiMsOutSend, NoteOut:%statusbyte% %chan% %number% %value%
    ;global chan, EventType, NoteVel
    ;MidiStatus := 143 + chan
    note = %number%                                      ; this var is added to allow transpostion of a note
    midiOutShortMsg(h_midiout, statusbyte, note, value) ; call the midi funcitons with these params.
     gosub, ShowMidiOutMessage
Return

SendCC: ; not sure i actually did anything changing cc's here but it is possible.


  ;GuiControl,12:, MidiMsOutSend, CCOut:%statusbyte% %chan% %cc% %value%
    midiOutShortMsg(h_midiout, statusbyte, cc, value)

     ;MsgBox, 0, ,sendcc triggered , 1
 Return

SendPC:
    gosub, ShowMidiOutMessage
  ;GuiControl,12:, MidiMsOutSend, ProgChOut:%statusbyte% %chan% %number% %value%
    midiOutShortMsg(h_midiout, statusbyte, pc, value)

  ;COULD BE TRANSLATED TO SOME OTHER MIDI MESSAGE IF NEEDED.

Return
;==========================================
*/


;}
