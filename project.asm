INCLUDE Irvine32.inc

; har class ka record store karne ke liye structure
classrecord STRUCT
    course BYTE 20 DUP(?)
    teacher BYTE 30 DUP(?)
    room BYTE 10 DUP(?)
    section BYTE 10 DUP(?)
    day DWORD ?
    slot DWORD ?
    credit DWORD ?
    breakAfter DWORD ?
    kind DWORD ?
    students DWORD ?
classrecord ENDS

; structure fields ke offsets
courseoff EQU 0
teacheroff EQU 20
roomoff EQU 50
sectionoff EQU 60
dayoff EQU 70
slotoff EQU 74
creditoff EQU 78
breakoff EQU 82
kindoff EQU 86
studentsoff EQU 90
recordsize EQU SIZEOF classrecord

.data

tmessage BYTE "========== UNISLOT ==========",0
op1 BYTE "1. Admin Panel",0
op2 BYTE "2. Student Panel",0
op3 BYTE "3. Exit",0
emessage BYTE "Enter your choice: ",0

amsg BYTE "Admin Panel Selected",0
smsg BYTE "Student Panel Selected",0
imsg BYTE "Invalid Choice. Try Again.",0
xmsg BYTE "Thank you for using UniSlot!",0

password BYTE "admin123",0
passinput BYTE 30 DUP(0)

pmsg BYTE "Enter Admin Password: ",0
wmsg BYTE "Incorrect Password!",0
smsg2 BYTE "Login Successful!",0
lmsg BYTE "Access Denied! Maximum Attempts Reached.",0

attempts DWORD 3

adminmsg BYTE "========== ADMIN PANEL ==========",0
aop1 BYTE "1. Add Class",0
aop2 BYTE "2. Edit Class",0
aop3 BYTE "3. Delete Class",0
aop4 BYTE "4. Back to Main Menu",0

cmsg BYTE "Enter Course Name: ",0
tmsg BYTE "Enter Teacher Name: ",0
rmsg BYTE "Enter Room: ",0
secmsg BYTE "Enter Section: ",0
dmsg BYTE "Enter Day (1: Monday - 5: Friday) : ",0
slmsg BYTE "Enter Slot (1-8): ",0
crmsg BYTE "Enter Credit Hours: ",0
kindmsg BYTE "Enter Type (1 Core, 2 Normal, 3 Lab): ",0
studentsmsg BYTE "Enter Students in Section (1-40): ",0
breakmsg BYTE "Enter Break After Slot (3, 4, or 5): ",0

nmsg BYTE "Class Added Successfully!",0
emsg BYTE "Class Updated Successfully!",0
dmsg2 BYTE "Class Deleted Successfully!",0
fmsg BYTE "Maximum Record Limit Reached!",0
nomsg BYTE "No Records Available!",0
imsg2 BYTE "Invalid Record Number!",0
clashmsg BYTE "Schedule clash! Another class is using this time.",0
breakerr BYTE "Break position must be the same for all classes that day.",0
sectionerr BYTE "Student count for this section must stay the same (max 40).",0
dailyfull BYTE "Maximum 8 classes allowed per day.",0
crediterr BYTE "Invalid credit hours for selected class type.",0

rtitle BYTE "========== CLASS RECORDS ==========",0
rnum BYTE "Record Number: ",0
rcourse BYTE "Course: ",0
rsection BYTE "Section: ",0
rday BYTE "Day: ",0
rslot BYTE "Slot: ",0
rtime BYTE "Start Time: ",0
rkind BYTE "Class Type: ",0
rstudents BYTE "Students in Section: ",0
coremsg BYTE "Core",0
normalmsg BYTE "Normal",0
labmsg BYTE "Lab",0
rchoose BYTE "Enter Record Number: ",0
timecolon BYTE ":",0
timezero BYTE "0",0
tempminute DWORD 0

dayname BYTE "Monday",0
dayname2 BYTE "Tuesday",0
dayname3 BYTE "Wednesday",0
dayname4 BYTE "Thursday",0
dayname5 BYTE "Friday",0

recordcount DWORD 0
records BYTE 100 * recordsize DUP(0)
breakByDay DWORD 5 DUP(0)
editingIndex DWORD 0FFFFFFFFh
validationPtr DWORD 0
fileName BYTE "unislot.dat",0
fileBuffer BYTE 4 + 100 * recordsize DUP(0)
fileBytes DWORD 0

; --- Student Panel ke variables aur messages ---
stitle BYTE "========== STUDENT PANEL ==========",0
sop1 BYTE "1. View All Timetable",0
sop2 BYTE "2. Search by Course",0
sop3 BYTE "3. Search by Section",0
sop4 BYTE "4. Filter Classes by Day",0
sop5 BYTE "5. Back to Main Menu",0

rteacher BYTE "Teacher: ",0
rroom BYTE "Room: ",0
rcredit BYTE "Credit Hours: ",0
totcr_msg BYTE "Total Credit Hours for this Section: ",0
notfound_msg BYTE "No matching class found!",0
sep_line BYTE "-------------------------------------",0
gridtitle BYTE "========== WEEKLY TIMETABLE =========",0
griddayheader BYTE "Day",0
emptycell BYTE "--",0
gridbar BYTE " | ",0
slotHeader1 BYTE "1",0
slotHeader2 BYTE "2",0
slotHeader3 BYTE "3",0
slotHeader4 BYTE "4",0
slotHeader5 BYTE "5",0
slotHeader6 BYTE "6",0
slotHeader7 BYTE "7",0
slotHeader8 BYTE "8",0
gridKeyTitle BYTE "Record # = Class details below",0
gridKeyCourse BYTE " | Course: ",0
gridKeySection BYTE " | Section: ",0
gridKeyTeacher BYTE " | Teacher: ",0
gridKeyRoom BYTE " | Room: ",0
cellWidth DWORD 12
cellCount DWORD 0
gridDay DWORD 0
gridSlot DWORD 0
gridIndex DWORD 0
gridFound DWORD 0
gridRecordNumber DWORD 0

search_str BYTE 30 DUP(0)
day_filter DWORD 0
total_cr DWORD 0
found_flag DWORD 0

; Default sample data taake program chalte hi Student Panel khali na rahe
sample1_c BYTE "COAL",0
sample1_t BYTE "Muhammad Adeel",0
sample1_r BYTE "C-301",0
sample1_s BYTE "BCS-3A",0

sample2_c BYTE "Data Structures",0
sample2_t BYTE "Zainab Asif",0
sample2_r BYTE "E-102",0
sample2_s BYTE "BCS-3A",0

sample3_c BYTE "Linear Algebra",0
sample3_t BYTE "Mairaj Ahmed",0
sample3_r BYTE "B-204",0
sample3_s BYTE "BCS-3B",0

.code

main PROC

    ; program start hote hi 3 sample classes load kar rahe hain
    call loadData

menu:

    call Clrscr

    mov edx, OFFSET tmessage
    call WriteString
    call Crlf
    call Crlf

    mov edx, OFFSET op1
    call WriteString
    call Crlf

    mov edx, OFFSET op2
    call WriteString
    call Crlf

    mov edx, OFFSET op3
    call WriteString
    call Crlf
    call Crlf

    mov edx, OFFSET emessage
    call WriteString

    call ReadInt

    cmp eax, 1
    je admin

    cmp eax, 2
    je student

    cmp eax, 3
    je finish

    jmp invalid

admin:

    call adminLogin

    cmp eax, 1
    jne menu

    call adminMenu
    jmp menu

student:

    call studentMenu
    jmp menu

invalid:

    call Clrscr

    mov edx, OFFSET imsg
    call WriteString
    call Crlf

    call WaitMsg
    jmp menu

finish:

    call Clrscr

    mov edx, OFFSET xmsg
    call WriteString
    call Crlf

    exit

main ENDP


; helper jo string ko struct mein copy kare (esi = source, edi = dest)
copyStr PROC USES esi edi eax
cp_loop:
    mov al, [esi]
    mov [edi], al
    cmp al, 0
    je cp_done
    inc esi
    inc edi
    jmp cp_loop
cp_done:
    ret
copyStr ENDP


; 3 default records memory mein daalne ke liye
loadSampleData PROC USES esi edi ebx
    ; Record 0: COAL
    mov ebx, OFFSET records
    mov esi, OFFSET sample1_c
    lea edi, [ebx+courseoff]
    call copyStr
    mov esi, OFFSET sample1_t
    lea edi, [ebx+teacheroff]
    call copyStr
    mov esi, OFFSET sample1_r
    lea edi, [ebx+roomoff]
    call copyStr
    mov esi, OFFSET sample1_s
    lea edi, [ebx+sectionoff]
    call copyStr
    mov DWORD PTR [ebx+dayoff], 1      ; Monday
    mov DWORD PTR [ebx+slotoff], 2     ; Slot 2
    mov DWORD PTR [ebx+creditoff], 3   ; 3 Credits
    mov DWORD PTR [ebx+breakoff], 4
    mov DWORD PTR [ebx+kindoff], 1
    mov DWORD PTR [ebx+studentsoff], 40

    ; Record 1: Data Structures
    add ebx, recordsize
    mov esi, OFFSET sample2_c
    lea edi, [ebx+courseoff]
    call copyStr
    mov esi, OFFSET sample2_t
    lea edi, [ebx+teacheroff]
    call copyStr
    mov esi, OFFSET sample2_r
    lea edi, [ebx+roomoff]
    call copyStr
    mov esi, OFFSET sample2_s
    lea edi, [ebx+sectionoff]
    call copyStr
    mov DWORD PTR [ebx+dayoff], 3      ; Wednesday
    mov DWORD PTR [ebx+slotoff], 4     ; Slot 4
    mov DWORD PTR [ebx+creditoff], 3   ; 3 Credits
    mov DWORD PTR [ebx+breakoff], 4
    mov DWORD PTR [ebx+kindoff], 1
    mov DWORD PTR [ebx+studentsoff], 40

    ; Record 2: Linear Algebra
    add ebx, recordsize
    mov esi, OFFSET sample3_c
    lea edi, [ebx+courseoff]
    call copyStr
    mov esi, OFFSET sample3_t
    lea edi, [ebx+teacheroff]
    call copyStr
    mov esi, OFFSET sample3_r
    lea edi, [ebx+roomoff]
    call copyStr
    mov esi, OFFSET sample3_s
    lea edi, [ebx+sectionoff]
    call copyStr
    mov DWORD PTR [ebx+dayoff], 5      ; Friday
    mov DWORD PTR [ebx+slotoff], 1     ; Slot 1
    mov DWORD PTR [ebx+creditoff], 3   ; 3 Credits
    mov DWORD PTR [ebx+breakoff], 4
    mov DWORD PTR [ebx+kindoff], 2
    mov DWORD PTR [ebx+studentsoff], 30

    mov recordcount, 3
    mov breakByDay[0], 4
    mov breakByDay[8], 4
    mov breakByDay[16], 4
    ret
loadSampleData ENDP


; admin password check karne ka procedure
adminLogin PROC USES esi edi

    mov attempts, 3

loginLoop:

    mov edx, OFFSET pmsg
    call WriteString

    mov edx, OFFSET passinput
    mov ecx, 29
    call ReadString

    mov esi, OFFSET password
    mov edi, OFFSET passinput

compareLoop:

    mov al, [esi]
    cmp al, [edi]
    jne wrongPass

    cmp al, 0
    je correctPass

    inc esi
    inc edi

    jmp compareLoop

wrongPass:

    dec attempts

    mov edx, OFFSET wmsg
    call WriteString
    call Crlf

    cmp attempts, 0
    je loginFailed

    jmp loginLoop

correctPass:

    mov edx, OFFSET smsg2
    call WriteString
    call Crlf

    call WaitMsg

    mov eax, 1
    ret

loginFailed:

    mov edx, OFFSET lmsg
    call WriteString
    call Crlf

    call WaitMsg

    mov eax, 0
    ret

adminLogin ENDP


; admin menu options handle karne ke liye
adminMenu PROC

adminloop:

    call Clrscr

    mov edx, OFFSET adminmsg
    call WriteString
    call Crlf
    call Crlf

    mov edx, OFFSET aop1
    call WriteString
    call Crlf

    mov edx, OFFSET aop2
    call WriteString
    call Crlf

    mov edx, OFFSET aop3
    call WriteString
    call Crlf

    mov edx, OFFSET aop4
    call WriteString
    call Crlf
    call Crlf

    mov edx, OFFSET emessage
    call WriteString

    call ReadInt

    cmp eax, 1
    je addclass

    cmp eax, 2
    je editclass

    cmp eax, 3
    je deleteclass

    cmp eax, 4
    je adminexit

    jmp admininvalid

addclass:

    call addRecord
    jmp adminloop

editclass:

    call editRecord
    jmp adminloop

deleteclass:

    call deleteRecord
    jmp adminloop

admininvalid:

    mov edx, OFFSET imsg
    call WriteString
    call Crlf

    call WaitMsg
    jmp adminloop

adminexit:

    ret

adminMenu ENDP


; user se ek class ka data input lene ke liye
readRecord PROC USES esi

    mov edx, OFFSET cmsg
    call WriteString

    mov BYTE PTR [esi+courseoff], 0
    lea edx, [esi+courseoff]
    mov ecx, 19
    call ReadString

    mov edx, OFFSET tmsg
    call WriteString

    mov BYTE PTR [esi+teacheroff], 0
    lea edx, [esi+teacheroff]
    mov ecx, 29
    call ReadString

    mov edx, OFFSET rmsg
    call WriteString

    mov BYTE PTR [esi+roomoff], 0
    lea edx, [esi+roomoff]
    mov ecx, 9
    call ReadString

    mov edx, OFFSET secmsg
    call WriteString

    mov BYTE PTR [esi+sectionoff], 0
    lea edx, [esi+sectionoff]
    mov ecx, 9
    call ReadString

dayinput:

    mov edx, OFFSET dmsg
    call WriteString

    call ReadInt

    cmp eax, 1
    jl dayinput

    cmp eax, 5
    jg dayinput

    mov [esi+dayoff], eax

slotinput:

    mov edx, OFFSET slmsg
    call WriteString

    call ReadInt

    cmp eax, 1
    jl slotinput

    cmp eax, 8
    jg slotinput

    mov [esi+slotoff], eax

breakinput:
    mov edx, OFFSET breakmsg
    call WriteString
    call ReadInt
    cmp eax, 3
    jl breakinput
    cmp eax, 5
    jg breakinput
    mov [esi+breakoff], eax

kindinput:
    mov edx, OFFSET kindmsg
    call WriteString
    call ReadInt
    cmp eax, 1
    jl kindinput
    cmp eax, 3
    jg kindinput
    mov [esi+kindoff], eax

creditinput:

    mov edx, OFFSET crmsg
    call WriteString

    call ReadInt

    cmp eax, 1
    jl creditinput

    cmp DWORD PTR [esi+kindoff], 1
    jne normalcredit
    cmp eax, 3
    jg creditinput
    jmp creditok
normalcredit:
    cmp DWORD PTR [esi+kindoff], 2
    jne labcredit
    cmp eax, 2
    jg creditinput
    jmp creditok
labcredit:
    cmp eax, 1
    jne creditinput

creditok:
    mov [esi+creditoff], eax

studentinput:
    mov edx, OFFSET studentsmsg
    call WriteString
    call ReadInt
    cmp eax, 1
    jl studentinput
    cmp eax, 40
    jg studentinput
    mov [esi+studentsoff], eax

    ret

readRecord ENDP


; new record array ke end mein add karna
addRecord PROC USES esi

    cmp recordcount, 100
    jae recordFull

    mov eax, recordcount
    imul eax, recordsize

    mov esi, OFFSET records
    add esi, eax

    mov editingIndex, 0FFFFFFFFh

    call readRecord
    call validateRecord
    cmp eax, 1
    jne addRejected

    inc recordcount
    call saveData

    mov edx, OFFSET nmsg
    call WriteString
    call Crlf

    call WaitMsg
    ret

addRejected:
    call WaitMsg
    ret

recordFull:

    mov edx, OFFSET fmsg
    call WriteString
    call Crlf

    call WaitMsg

    ret

addRecord ENDP


; admin ke liye basic list show karne ka procedure
listRecords PROC USES ebx esi

    call Clrscr

    mov edx, OFFSET rtitle
    call WriteString
    call Crlf
    call Crlf

    cmp recordcount, 0
    je noRecords

    mov ebx, 0

listLoop:

    cmp ebx, recordcount
    jge listDone

    mov edx, OFFSET rnum
    call WriteString

    mov eax, ebx
    inc eax
    call WriteDec
    call Crlf

    mov eax, ebx
    imul eax, recordsize

    mov esi, OFFSET records
    add esi, eax

    mov edx, OFFSET rcourse
    call WriteString

    lea edx, [esi+courseoff]
    call WriteString
    call Crlf

    mov edx, OFFSET rsection
    call WriteString

    lea edx, [esi+sectionoff]
    call WriteString
    call Crlf

    mov edx, OFFSET rday
    call WriteString

    mov eax, [esi+dayoff]
    call WriteDec
    call Crlf

    mov edx, OFFSET rslot
    call WriteString

    mov eax, [esi+slotoff]
    call WriteDec
    call Crlf

    mov edx, OFFSET rtime
    call WriteString
    call printStartTime
    call Crlf

    mov edx, OFFSET rkind
    call WriteString
    mov eax, [esi+kindoff]
    cmp eax, 1
    je kind_core
    cmp eax, 2
    je kind_normal
    mov edx, OFFSET labmsg
    jmp kind_print
kind_core:
    mov edx, OFFSET coremsg
    jmp kind_print
kind_normal:
    mov edx, OFFSET normalmsg
kind_print:
    call WriteString
    call Crlf

    mov edx, OFFSET rstudents
    call WriteString
    mov eax, [esi+studentsoff]
    call WriteDec
    call Crlf
    call Crlf

    inc ebx
    jmp listLoop

listDone:

    ret

noRecords:

    mov edx, OFFSET nomsg
    call WriteString
    call Crlf

    ret

listRecords ENDP


; kisi existing record ko edit karna
editRecord PROC USES esi

    cmp recordcount, 0
    je editEmpty

    call listRecords

    mov edx, OFFSET rchoose
    call WriteString

    call ReadInt

    cmp eax, 1
    jl editInvalid

    cmp eax, recordcount
    jg editInvalid

    dec eax
    mov editingIndex, eax
    imul eax, recordsize

    mov esi, OFFSET records
    add esi, eax

    call readRecord
    call validateRecord
    cmp eax, 1
    jne editRejected
    call saveData

    mov edx, OFFSET emsg
    call WriteString
    call Crlf

    call WaitMsg
    ret

editRejected:
    call WaitMsg
    ret

editInvalid:

    mov edx, OFFSET imsg2
    call WriteString
    call Crlf

    call WaitMsg
    ret

editEmpty:

    mov edx, OFFSET nomsg
    call WriteString
    call Crlf

    call WaitMsg
    ret

editRecord ENDP


; record delete karke baaki records ko peeche shift karna
deleteRecord PROC USES ebx esi edi

    cmp recordcount, 0
    je deleteEmpty

    call listRecords

    mov edx, OFFSET rchoose
    call WriteString

    call ReadInt

    cmp eax, 1
    jl deleteInvalid

    cmp eax, recordcount
    jg deleteInvalid

    dec eax
    mov ebx, eax

    mov eax, recordcount
    sub eax, ebx
    dec eax

    cmp eax, 0
    je deleteLast

    mov ecx, eax
    imul ecx, recordsize

    mov eax, ebx
    imul eax, recordsize

    mov edi, OFFSET records
    add edi, eax

    mov esi, edi
    add esi, recordsize

    cld
    rep movsb

deleteLast:

    dec recordcount
    call saveData

    mov edx, OFFSET dmsg2
    call WriteString
    call Crlf

    call WaitMsg
    ret

deleteInvalid:

    mov edx, OFFSET imsg2
    call WriteString
    call Crlf

    call WaitMsg
    ret

deleteEmpty:

    mov edx, OFFSET nomsg
    call WriteString
    call Crlf

    call WaitMsg
    ret

deleteRecord ENDP


; ==========================================================
; STUDENT PANEL AUR HELPER PROCEDURES
; ==========================================================

; ESI points to the new/edited record. Validate section size consistency,
; one 50-minute break position, daily limit, and campus-wide time clashes.
validateRecord PROC USES ebx ecx esi edi
    mov validationPtr, esi
    xor ebx, ebx
    xor ecx, ecx
vr_loop:
    cmp ebx, recordcount
    jae vr_day_done
    cmp ebx, editingIndex
    je vr_next
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov edi, validationPtr
    lea esi, [esi+sectionoff]
    lea edi, [edi+sectionoff]
    call compareStr
    cmp eax, 1
    jne vr_check_day
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov edi, validationPtr
    mov eax, [esi+studentsoff]
    cmp eax, [edi+studentsoff]
    je vr_check_day
    mov edx, OFFSET sectionerr
    call WriteString
    call Crlf
    xor eax, eax
    ret

vr_check_day:
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov edi, validationPtr
    mov eax, [esi+dayoff]
    cmp eax, [edi+dayoff]
    jne vr_next
    inc ecx
    mov eax, [esi+breakoff]
    cmp eax, [edi+breakoff]
    je vr_check_slot
    mov edx, OFFSET breakerr
    call WriteString
    call Crlf
    xor eax, eax
    ret
vr_check_slot:
    mov eax, [esi+slotoff]
    cmp eax, [edi+slotoff]
    jne vr_next
    mov edx, OFFSET clashmsg
    call WriteString
    call Crlf
    xor eax, eax
    ret
vr_next:
    inc ebx
    jmp vr_loop

vr_day_done:
    cmp ecx, 8
    jb vr_ok
    mov edx, OFFSET dailyfull
    call WriteString
    call Crlf
    xor eax, eax
    ret
vr_ok:
    mov eax, 1
    ret
validateRecord ENDP

printDayName PROC USES edx
    cmp eax, 1
    je d1
    cmp eax, 2
    je d2
    cmp eax, 3
    je d3
    cmp eax, 4
    je d4
    mov edx, OFFSET dayname5
    jmp print_it
d1:
    mov edx, OFFSET dayname
    jmp print_it
d2:
    mov edx, OFFSET dayname2
    jmp print_it
d3:
    mov edx, OFFSET dayname3
    jmp print_it
d4:
    mov edx, OFFSET dayname4
print_it:
    call WriteString
    ret
printDayName ENDP


showFullRecord PROC USES edx eax
    mov edx, OFFSET rcourse
    call WriteString
    lea edx, [esi+courseoff]
    call WriteString
    call Crlf

    mov edx, OFFSET rteacher
    call WriteString
    lea edx, [esi+teacheroff]
    call WriteString
    call Crlf

    mov edx, OFFSET rroom
    call WriteString
    lea edx, [esi+roomoff]
    call WriteString
    call Crlf

    mov edx, OFFSET rsection
    call WriteString
    lea edx, [esi+sectionoff]
    call WriteString
    call Crlf

    mov edx, OFFSET rday
    call WriteString
    mov eax, [esi+dayoff]
    call printDayName
    call Crlf

    mov edx, OFFSET rslot
    call WriteString
    mov eax, [esi+slotoff]
    call WriteDec
    call Crlf

    mov edx, OFFSET rcredit
    call WriteString
    mov eax, [esi+creditoff]
    call WriteDec
    call Crlf

    mov edx, OFFSET sep_line
    call WriteString
    call Crlf
    ret
showFullRecord ENDP

printStartTime PROC USES ebx ecx edx
    mov eax, [esi+slotoff]
    dec eax
    imul eax, 55
    add eax, 480
    mov ebx, [esi+breakoff]
    cmp [esi+slotoff], ebx
    jbe pst_convert
    add eax, 45            ; 50-minute break replaces a 5-minute gap
pst_convert:
    xor edx, edx
    mov ecx, 60
    div ecx
    mov tempminute, edx
    call WriteDec
    mov edx, OFFSET timecolon
    call WriteString
    mov eax, tempminute
    cmp eax, 10
    jae pst_minutes
    push eax
    mov edx, OFFSET timezero
    call WriteString
    pop eax
pst_minutes:
    call WriteDec
    ret
printStartTime ENDP


compareStr PROC USES esi edi ebx
str_loop:
    mov al, [esi]
    mov bl, [edi]

    cmp al, 'a'
    jl check_bl
    cmp al, 'z'
    jg check_bl
    sub al, 32

check_bl:
    cmp bl, 'a'
    jl do_cmp
    cmp bl, 'z'
    jg do_cmp
    sub bl, 32

do_cmp:
    cmp al, bl
    jne not_same

    cmp al, 0
    je is_same

    inc esi
    inc edi
    jmp str_loop

is_same:
    mov eax, 1
    ret

not_same:
    mov eax, 0
    ret
compareStr ENDP


studentMenu PROC
st_loop:
    call Clrscr

    mov edx, OFFSET stitle
    call WriteString
    call Crlf
    call Crlf

    mov edx, OFFSET sop1
    call WriteString
    call Crlf

    mov edx, OFFSET sop2
    call WriteString
    call Crlf

    mov edx, OFFSET sop3
    call WriteString
    call Crlf

    mov edx, OFFSET sop4
    call WriteString
    call Crlf

    mov edx, OFFSET sop5
    call WriteString
    call Crlf
    call Crlf

    mov edx, OFFSET emessage
    call WriteString
    call ReadInt

    cmp eax, 1
    je view_all
    cmp eax, 2
    je search_course
    cmp eax, 3
    je search_sec
    cmp eax, 4
    je filter_day
    cmp eax, 5
    je st_exit

    mov edx, OFFSET imsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp st_loop

view_all:
    call viewAllStudent
    jmp st_loop

search_course:
    call searchByCourse
    jmp st_loop

search_sec:
    call searchBySection
    jmp st_loop

filter_day:
    call filterByDay
    jmp st_loop

st_exit:
    ret
studentMenu ENDP


; Print each weekday on one row and each of its eight slots in a column.
showTimetableGrid PROC USES eax ebx ecx edx esi edi
    call Clrscr
    mov edx, OFFSET gridtitle
    call WriteString
    call Crlf
    call Crlf
    cmp recordcount, 0
    je grid_empty

    mov esi, OFFSET griddayheader
    mov ecx, 12
    call gridPrintCell
    mov edx, OFFSET gridbar
    call WriteString
    mov gridSlot, 1
grid_header_loop:
    cmp gridSlot, 9
    jae grid_header_done
    mov eax, gridSlot
    call getSlotName
    mov esi, edx
    mov ecx, 5
    call gridPrintCell
    mov edx, OFFSET gridbar
    call WriteString
    inc gridSlot
    jmp grid_header_loop
grid_header_done:
    call Crlf

    mov gridDay, 1
grid_day_loop:
    cmp gridDay, 6
    jae grid_done
    mov eax, gridDay
    call getDayName
    mov esi, edx
    mov ecx, 12
    call gridPrintCell
    mov edx, OFFSET gridbar
    call WriteString
    mov gridSlot, 1
grid_slot_loop:
    cmp gridSlot, 9
    jae grid_row_done
    mov gridFound, 0
    mov gridIndex, 0
grid_find_loop:
    mov eax, gridIndex
    cmp eax, recordcount
    jae grid_print_cell
    mov eax, gridIndex
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    mov eax, [esi+dayoff]
    cmp eax, gridDay
    jne grid_find_next
    mov eax, [esi+slotoff]
    cmp eax, gridSlot
    jne grid_find_next
    mov eax, gridIndex
    inc eax
    mov gridRecordNumber, eax
    mov gridFound, 1
    jmp grid_print_cell
grid_find_next:
    inc gridIndex
    jmp grid_find_loop
grid_print_cell:
    cmp gridFound, 1
    je grid_cell_ready
    mov esi, OFFSET emptycell
grid_cell_ready:
    cmp gridFound, 1
    jne grid_print_empty
    call gridPrintRecordNumber
    jmp grid_after_cell
grid_print_empty:
    mov esi, OFFSET emptycell
    mov ecx, 5
    call gridPrintCell
grid_after_cell:
    mov edx, OFFSET gridbar
    call WriteString
    inc gridSlot
    jmp grid_slot_loop
grid_row_done:
    call Crlf
    inc gridDay
    jmp grid_day_loop

grid_done:
    call Crlf
    mov edx, OFFSET gridKeyTitle
    call WriteString
    call Crlf
    mov gridIndex, 0
grid_key_loop:
    mov eax, gridIndex
    cmp eax, recordcount
    jae grid_key_done
    mov eax, gridIndex
    inc eax
    call WriteDec
    mov edx, OFFSET gridKeyCourse
    call WriteString
    mov eax, gridIndex
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea edx, [esi+courseoff]
    call WriteString
    mov edx, OFFSET gridKeySection
    call WriteString
    lea edx, [esi+sectionoff]
    call WriteString
    mov edx, OFFSET gridKeyTeacher
    call WriteString
    lea edx, [esi+teacheroff]
    call WriteString
    mov edx, OFFSET gridKeyRoom
    call WriteString
    lea edx, [esi+roomoff]
    call WriteString
    call Crlf
    inc gridIndex
    jmp grid_key_loop
grid_key_done:
    ret
grid_empty:
    mov edx, OFFSET nomsg
    call WriteString
    call Crlf
    ret
showTimetableGrid ENDP

; The grid stays narrow: one class record number in each occupied slot.
gridPrintRecordNumber PROC USES eax ecx
    mov eax, gridRecordNumber
    call WriteDec
    cmp gridRecordNumber, 10
    jae gprn_two_digits
    mov ecx, 4
    jmp gprn_spaces
gprn_two_digits:
    cmp gridRecordNumber, 100
    jae gprn_three_digits
    mov ecx, 3
    jmp gprn_spaces
gprn_three_digits:
    mov ecx, 2
gprn_spaces:
    mov al, ' '
gprn_space_loop:
    call WriteChar
    loop gprn_space_loop
    ret
gridPrintRecordNumber ENDP

; ESI=string, ECX=cell width. Long course names are clipped to the cell.
gridPrintCell PROC USES eax ecx esi
    mov cellWidth, ecx
    mov cellCount, 0
gpc_text:
    mov eax, cellCount
    cmp eax, cellWidth
    jae gpc_pad_start
    mov al, [esi]
    test al, al
    jz gpc_pad_start
    call WriteChar
    inc esi
    inc cellCount
    jmp gpc_text
gpc_pad_start:
    mov eax, cellWidth
    sub eax, cellCount
    mov ecx, eax
    jecxz gpc_done
gpc_pad:
    mov al, ' '
    call WriteChar
    loop gpc_pad
gpc_done:
    ret
gridPrintCell ENDP

; EAX=day number, returns EDX=day name.
getDayName PROC
    cmp eax, 1
    je gdn_mon
    cmp eax, 2
    je gdn_tue
    cmp eax, 3
    je gdn_wed
    cmp eax, 4
    je gdn_thu
    mov edx, OFFSET dayname5
    ret
gdn_mon:
    mov edx, OFFSET dayname
    ret
gdn_tue:
    mov edx, OFFSET dayname2
    ret
gdn_wed:
    mov edx, OFFSET dayname3
    ret
gdn_thu:
    mov edx, OFFSET dayname4
    ret
getDayName ENDP

getSlotName PROC
    cmp gridSlot, 1
    je gsn1
    cmp gridSlot, 2
    je gsn2
    cmp gridSlot, 3
    je gsn3
    cmp gridSlot, 4
    je gsn4
    cmp gridSlot, 5
    je gsn5
    cmp gridSlot, 6
    je gsn6
    cmp gridSlot, 7
    je gsn7
    mov edx, OFFSET slotHeader8
    ret
gsn1: mov edx, OFFSET slotHeader1
    ret
gsn2: mov edx, OFFSET slotHeader2
    ret
gsn3: mov edx, OFFSET slotHeader3
    ret
gsn4: mov edx, OFFSET slotHeader4
    ret
gsn5: mov edx, OFFSET slotHeader5
    ret
gsn6: mov edx, OFFSET slotHeader6
    ret
gsn7: mov edx, OFFSET slotHeader7
    ret
getSlotName ENDP

viewAllStudent PROC
    call showTimetableGrid
    call WaitMsg
    ret
viewAllStudent ENDP


searchByCourse PROC USES ebx esi edi
    call Clrscr
    cmp recordcount, 0
    je sc_empty

sc_read:
    mov edx, OFFSET cmsg
    call WriteString
    mov edx, OFFSET search_str
    mov ecx, 19
    call ReadString
    cmp eax, 0
    je sc_read
    call Crlf

    mov found_flag, 0
    mov ebx, 0

sc_loop:
    cmp ebx, recordcount
    jge sc_done

    mov eax, ebx
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax

    push esi
    lea esi, [esi+courseoff]
    mov edi, OFFSET search_str
    call compareStr
    pop esi

    cmp eax, 1
    jne sc_next

    call showFullRecord
    mov found_flag, 1

sc_next:
    inc ebx
    jmp sc_loop

sc_done:
    cmp found_flag, 0
    jne sc_wait
    mov edx, OFFSET notfound_msg
    call WriteString
    call Crlf

sc_wait:
    call WaitMsg
    ret

sc_empty:
    mov edx, OFFSET nomsg
    call WriteString
    call Crlf
    call WaitMsg
    ret
searchByCourse ENDP


searchBySection PROC USES ebx esi edi
    call Clrscr
    cmp recordcount, 0
    je ss_empty

ss_read:
    mov edx, OFFSET secmsg
    call WriteString
    mov edx, OFFSET search_str
    mov ecx, 9
    call ReadString
    cmp eax, 0
    je ss_read
    call Crlf

    mov found_flag, 0
    mov total_cr, 0
    mov ebx, 0

ss_loop:
    cmp ebx, recordcount
    jge ss_done

    mov eax, ebx
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax

    push esi
    lea esi, [esi+sectionoff]
    mov edi, OFFSET search_str
    call compareStr
    pop esi

    cmp eax, 1
    jne ss_next

    call showFullRecord
    mov found_flag, 1

    mov eax, [esi+creditoff]
    add total_cr, eax

ss_next:
    inc ebx
    jmp ss_loop

ss_done:
    cmp found_flag, 0
    je ss_notfound

    mov edx, OFFSET totcr_msg
    call WriteString
    mov eax, total_cr
    call WriteDec
    call Crlf
    jmp ss_wait

ss_notfound:
    mov edx, OFFSET notfound_msg
    call WriteString
    call Crlf

ss_wait:
    call WaitMsg
    ret

ss_empty:
    mov edx, OFFSET nomsg
    call WriteString
    call Crlf
    call WaitMsg
    ret
searchBySection ENDP


filterByDay PROC USES ebx esi
    call Clrscr
    cmp recordcount, 0
    je fd_empty

fd_input:
    mov edx, OFFSET dmsg
    call WriteString
    call ReadInt

    cmp eax, 1
    jl fd_input
    cmp eax, 5
    jg fd_input

    mov day_filter, eax
    call Crlf

    mov found_flag, 0
    mov ebx, 0

fd_loop:
    cmp ebx, recordcount
    jge fd_done

    mov eax, ebx
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax

    mov eax, [esi+dayoff]
    cmp eax, day_filter
    jne fd_next

    call showFullRecord
    mov found_flag, 1

fd_next:
    inc ebx
    jmp fd_loop

fd_done:
    cmp found_flag, 0
    jne fd_wait
    mov edx, OFFSET notfound_msg
    call WriteString
    call Crlf

fd_wait:
    call WaitMsg
    ret

fd_empty:
    mov edx, OFFSET nomsg
    call WriteString
    call Crlf
    call WaitMsg
    ret
filterByDay ENDP

; Load saved binary records. If no valid data file exists, use the three
; built-in sample classes and create the data file on first run.
loadData PROC USES eax ebx ecx edx esi edi
    mov edx, OFFSET fileName
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je ld_seed
    mov ebx, eax
    mov edx, OFFSET fileBuffer
    mov ecx, SIZEOF fileBuffer
    mov eax, ebx
    call ReadFromFile
    jc ld_bad_file
    mov fileBytes, eax
    mov eax, ebx
    call CloseFile
    mov eax, DWORD PTR fileBuffer
    cmp eax, 100
    ja ld_seed
    mov recordcount, eax
    mov ecx, recordcount
    imul ecx, recordsize
    add ecx, 4
    cmp ecx, fileBytes
    jne ld_seed
    lea esi, fileBuffer+4
    mov edi, OFFSET records
    mov ecx, recordcount
    imul ecx, recordsize
    cld
    rep movsb
    xor ebx, ebx
ld_break_loop:
    cmp ebx, recordcount
    jae ld_done
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov eax, [esi+dayoff]
    dec eax
    mov edx, [esi+breakoff]
    mov breakByDay[eax*4], edx
    inc ebx
    jmp ld_break_loop
ld_bad_file:
    mov eax, ebx
    call CloseFile
ld_seed:
    call loadSampleData
    call saveData
ld_done:
    ret
loadData ENDP

saveData PROC USES eax ebx ecx edx esi edi
    mov eax, recordcount
    mov DWORD PTR fileBuffer, eax
    mov esi, OFFSET records
    lea edi, fileBuffer+4
    mov ecx, recordcount
    imul ecx, recordsize
    cld
    rep movsb
    mov edx, OFFSET fileName
    call CreateOutputFile
    cmp eax, INVALID_HANDLE_VALUE
    je sd_done
    mov ebx, eax
    mov edx, OFFSET fileBuffer
    mov ecx, 4
    mov eax, ebx
    call WriteToFile
    mov edx, OFFSET fileBuffer+4
    mov ecx, recordcount
    imul ecx, recordsize
    mov eax, ebx
    call WriteToFile
    mov eax, ebx
    call CloseFile
sd_done:
    ret
saveData ENDP

END main
