.model small
.stack 100h

.data
; Data Segment
currentTemp db 75             ; Current temperature (modifiable for testing)
tempThreshold db 70           ; Temperature threshold
alarmMessage db 10, 13, 'ALARM: Temperature is too high!$', 0
normalMessage db 10, 13, 'Temperature is normal.$', 0
menuMessage db 10, 13, "Heater Alarm Menu", 10, 13, "1. Check Temperature", 10, 13, "2. Exit$", 0
invalidInputMessage db 10, 13, 'Invalid option. Please try again.$', 0
checkingMessage db 10, 13, 'Checking temperature, please wait...$', 0
input db 0

.code
; Code Segment
Main:
    ; Initialize Data Segment
    mov ax, @data
    mov ds, ax

Menu:
    ; Display Menu Options
    mov ah, 09h                 ; DOS interrupt to display string
    lea dx, menuMessage         ; Load address of menu message
    int 21h                     ; Call DOS interrupt

    ; Get User Input
    mov ah, 01h                 ; DOS interrupt to accept single character input
    int 21h                     ; Call DOS interrupt
    sub al, '0'                 ; Convert ASCII to numeric
    mov input, al               ; Store input

    cmp input, 1                ; Check if input is 1 (Check Temperature)
    je CheckTemperature         ; Jump if equal
    cmp input, 2                ; Check if input is 2 (Exit)
    je Exit                     ; Jump if equal

InvalidInput:
    ; Display Invalid Input Message
    mov ah, 09h                 ; DOS interrupt to display string
    lea dx, invalidInputMessage ; Load address of invalid input message
    int 21h                     ; Call DOS interrupt
    jmp Menu                    ; Redisplay menu

CheckTemperature:
    ; Display Checking Message
    mov ah, 09h                 ; DOS interrupt to display string
    lea dx, checkingMessage     ; Load address of checking message
    int 21h                     ; Call DOS interrupt

    ; Introduce 5-Second Delay
    call Delay5Sec              ; Call 5-second delay subroutine

    ; Load current temperature and compare with threshold
    mov al, currentTemp
    cmp al, tempThreshold       ; Compare current temperature with threshold
    jg TriggerAlarm             ; If temp > threshold, jump to TriggerAlarm

DisplayNormal:
    ; Display Normal Status Message
    mov ah, 09h                 ; DOS interrupt to display string
    lea dx, normalMessage       ; Load address of normal message
    int 21h                     ; Call DOS interrupt
    jmp Menu                    ; Return to menu

TriggerAlarm:
    ; Display Alarm Message
    mov ah, 09h                 ; DOS interrupt to display string
    lea dx, alarmMessage        ; Load address of alarm message
    int 21h                     ; Call DOS interrupt
    jmp Menu                    ; Return to menu

Delay5Sec:
    ; Use BIOS timer interrupt (INT 1Ah) to create a 5-second delay
    mov ah, 00h                 ; Function 0: Get system time
    int 1Ah                     ; Call BIOS interrupt
    mov bx, dx                  ; Store current clock ticks in BX

WaitLoop:
    mov ah, 00h                 ; Function 0: Get system time
    int 1Ah                     ; Call BIOS interrupt
    sub dx, bx                  ; Calculate elapsed ticks
    cmp dx, 91                  ; Compare with 91 ticks (approximately 5 seconds)
    jb WaitLoop                 ; If less than 91 ticks, continue waiting
    ret                         ; Return from subroutine
                 ; Return from subroutine

Exit:
    ; Exit Program
    mov ah, 4Ch                 ; DOS interrupt to terminate program
    int 21h

end Main
