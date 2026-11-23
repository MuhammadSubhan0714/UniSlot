INCLUDE Irvine32.inc

MAX_RECORDS EQU 1000
MAX_SECTIONS EQU 50
MAX_COURSES EQU 100

; har class ka record store karne ke liye structure
classrecord STRUCT
    course BYTE 30 DUP(?)
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
teacheroff EQU 30
roomoff EQU 60
sectionoff EQU 70
dayoff EQU 80
slotoff EQU 84
creditoff EQU 88
breakoff EQU 92
kindoff EQU 96
studentsoff EQU 100
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
studentsReusedMsg BYTE "Existing section enrollment reused: ",0
breakmsg BYTE "Enter Break After Slot (3, 4, or 5): ",0
breakReusedMsg BYTE "Existing break position reused (after slot): ",0

nmsg BYTE "Class Added Successfully!",0
emsg BYTE "Class Updated Successfully!",0
dmsg2 BYTE "Class Deleted Successfully!",0
fmsg BYTE "Maximum Record Limit Reached!",0
nomsg BYTE "No Records Available!",0
imsg2 BYTE "Invalid Record Number!",0
clashmsg BYTE "Schedule clash! Another class is using this time.",0
breakerr BYTE "Break position must match other classes for the same section and day.",0
sectionerr BYTE "Student count for this section must stay the same (max 40).",0
dailyfull BYTE "Maximum 8 classes allowed per day.",0
sectionLimitErr BYTE "Maximum unique section limit reached.",0
courseLimitErr BYTE "Maximum unique course limit reached.",0
crediterr BYTE "Invalid credit hours for selected class type.",0
weeklyMeetingErr BYTE "This course already has its weekly meeting limit based on credits.",0
dayerr BYTE "Invalid day! Enter a value from 1 to 5.",0
sloterr BYTE "Invalid slot! Enter a value from 1 to 8.",0
breakinputerr BYTE "Invalid break! Enter 3, 4, or 5 so neither class run exceeds 5.",0
kinderr BYTE "Invalid type! Enter 1 for Core, 2 for Normal, or 3 for Lab.",0
studentserr BYTE "Invalid student count! Enter a value from 1 to 40.",0
findsectionmsg BYTE "Enter Section: ",0
findcoursemsg BYTE "Enter Course Name: ",0
finddaymsg BYTE "Enter Day (1 Monday - 5 Friday): ",0
findslotmsg BYTE "Enter Slot (1-8; class time is calculated from slot): ",0
emptysectionerr BYTE "Section cannot be blank.",0
emptycourseerr BYTE "Course name cannot be blank.",0
requiredfielderr BYTE "This field is required and cannot be blank.",0

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
records BYTE MAX_RECORDS * recordsize DUP(0)
editBuffer BYTE recordsize DUP(0)
breakByDay DWORD 5 DUP(0)
editingIndex DWORD 0FFFFFFFFh
validationPtr DWORD 0
sectionMatch DWORD 0
courseMatch DWORD 0
breakLookupPtr DWORD 0
sectionLookupPtr DWORD 0
courseMeetingCount DWORD 0
currentRecordPtr DWORD 0
currentRecordIndex DWORD 0
creditScanIndex DWORD 0
lookupCourseBuf BYTE 30 DUP(0)
lookupDay DWORD 0
lookupSlot DWORD 0
fileName BYTE "unislot.dat",0
fileBuffer BYTE 4 + MAX_RECORDS * recordsize DUP(0)
fileBytes DWORD 0

; --- Student Panel ke variables aur messages ---
stitle BYTE "========== STUDENT PANEL ==========",0
sop1 BYTE "1. View All Timetable",0
sop2 BYTE "2. Search by Course",0
sop3 BYTE "3. Search by Section",0
sop4 BYTE "4. Filter Classes by Day",0
sop5 BYTE "5. Search by Teacher",0
sop6 BYTE "6. Back to Main Menu",0
teacherSearchMsg BYTE "Enter Teacher Name: ",0
availableCoursesTitle BYTE "Available Courses:",0
availableSectionsTitle BYTE "Available Sections:",0
availableTeachersTitle BYTE "Available Teachers:",0
sectionStatusLabel BYTE "Sections in use / maximum: ",0
courseStatusLabel BYTE "Unique courses in use / maximum: ",0
sectionFormatInfo BYTE "Section format: up to 9 characters (example: S001).",0
slashText BYTE " / ",0
availableOuter DWORD 0
availableInner DWORD 0
availablePtr DWORD 0
availableDuplicate DWORD 0
uniqueOffset DWORD 0
uniqueOuter DWORD 0
uniqueInner DWORD 0
uniquePtr DWORD 0
uniqueDuplicate DWORD 0
uniqueCount DWORD 0
newSectionFound DWORD 0
newCourseFound DWORD 0

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
gridKeyTitle BYTE "Course ID = Course details (each course appears once)",0
gridSectionPrompt BYTE "Enter Section Name to View: ",0
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
gridSection BYTE 10 DUP(0)
gridSectionFound DWORD 0
courseIds DWORD MAX_RECORDS DUP(0)
gridCourseCount DWORD 0
gridCourseID DWORD 0
gridFindIndex DWORD 0
gridInner DWORD 0
gridMatchedCourseID DWORD 0

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

    ; program start hote hi saved data ya 3 sample classes load kar rahe hain
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
    call showAdminStatus
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
courseinput:
    mov edx, OFFSET cmsg
    call WriteString

    mov BYTE PTR [esi+courseoff], 0
    lea edx, [esi+courseoff]
    mov ecx, 29
    call ReadString
    cmp eax, 0
    jne teacherinput
    mov edx, OFFSET requiredfielderr
    call WriteString
    call Crlf
    jmp courseinput

teacherinput:
    mov edx, OFFSET tmsg
    call WriteString

    mov BYTE PTR [esi+teacheroff], 0
    lea edx, [esi+teacheroff]
    mov ecx, 29
    call ReadString
    cmp eax, 0
    jne roominput
    mov edx, OFFSET requiredfielderr
    call WriteString
    call Crlf
    jmp teacherinput

roominput:
    mov edx, OFFSET rmsg
    call WriteString

    mov BYTE PTR [esi+roomoff], 0
    lea edx, [esi+roomoff]
    mov ecx, 9
    call ReadString
    cmp eax, 0
    jne sectioninput
    mov edx, OFFSET requiredfielderr
    call WriteString
    call Crlf
    jmp roominput

sectioninput:
    mov edx, OFFSET secmsg
    call WriteString

    mov BYTE PTR [esi+sectionoff], 0
    lea edx, [esi+sectionoff]
    mov ecx, 9
    call ReadString
    cmp eax, 0
    jne dayinput
    mov edx, OFFSET requiredfielderr
    call WriteString
    call Crlf
    jmp sectioninput

dayinput:

    mov edx, OFFSET dmsg
    call WriteString

    call ReadInt

    cmp eax, 1
    jge dayminok
    mov edx, OFFSET dayerr
    call WriteString
    call Crlf
    jmp dayinput

dayminok:
    cmp eax, 5
    jle dayvalid
    mov edx, OFFSET dayerr
    call WriteString
    call Crlf
    jmp dayinput

dayvalid:
    mov [esi+dayoff], eax

slotinput:

    mov edx, OFFSET slmsg
    call WriteString

    call ReadInt

    cmp eax, 1
    jge slotminok
    mov edx, OFFSET sloterr
    call WriteString
    call Crlf
    jmp slotinput

slotminok:
    cmp eax, 8
    jle slotvalid
    mov edx, OFFSET sloterr
    call WriteString
    call Crlf
    jmp slotinput

slotvalid:
    mov [esi+slotoff], eax

breakinput:
    mov breakLookupPtr, esi
    call findSectionDayBreak
    cmp eax, 0
    jne breakreuse
    mov edx, OFFSET breakmsg
    call WriteString
    call ReadInt
    cmp eax, 3
    jge breakminok
    mov edx, OFFSET breakinputerr
    call WriteString
    call Crlf
    jmp breakinput
breakminok:
    cmp eax, 5
    jle breakvalid
    mov edx, OFFSET breakinputerr
    call WriteString
    call Crlf
    jmp breakinput
breakvalid:
    mov [esi+breakoff], eax
    jmp kindinput

breakreuse:
    mov [esi+breakoff], eax
    mov edx, OFFSET breakReusedMsg
    call WriteString
    call WriteDec
    call Crlf

kindinput:
    mov edx, OFFSET kindmsg
    call WriteString
    call ReadInt
    cmp eax, 1
    jge kindminok
    mov edx, OFFSET kinderr
    call WriteString
    call Crlf
    jmp kindinput
kindminok:
    cmp eax, 3
    jle kindvalid
    mov edx, OFFSET kinderr
    call WriteString
    call Crlf
    jmp kindinput
kindvalid:
    mov [esi+kindoff], eax

creditinput:

    mov edx, OFFSET crmsg
    call WriteString

    call ReadInt

    cmp eax, 1
    jge creditminok
    mov edx, OFFSET crediterr
    call WriteString
    call Crlf
    jmp creditinput
creditminok:

    cmp DWORD PTR [esi+kindoff], 1
    jne normalcredit
    cmp eax, 3
    jle creditok
    mov edx, OFFSET crediterr
    call WriteString
    call Crlf
    jmp creditinput
normalcredit:
    cmp DWORD PTR [esi+kindoff], 2
    jne labcredit
    cmp eax, 2
    jle creditok
    mov edx, OFFSET crediterr
    call WriteString
    call Crlf
    jmp creditinput
labcredit:
    cmp eax, 1
    je creditok
    mov edx, OFFSET crediterr
    call WriteString
    call Crlf
    jmp creditinput

creditok:
    mov [esi+creditoff], eax

studentinput:
    mov sectionLookupPtr, esi
    call findSectionEnrollment
    cmp eax, 0
    jne studentreuse
    mov edx, OFFSET studentsmsg
    call WriteString
    call ReadInt
    cmp eax, 1
    jge studentminok
    mov edx, OFFSET studentserr
    call WriteString
    call Crlf
    jmp studentinput
studentminok:
    cmp eax, 40
    jle studentsvalid
    mov edx, OFFSET studentserr
    call WriteString
    call Crlf
    jmp studentinput
studentsvalid:
    mov [esi+studentsoff], eax
    ret

studentreuse:
    mov [esi+studentsoff], eax
    mov edx, OFFSET studentsReusedMsg
    call WriteString
    mov esi, sectionLookupPtr
    mov eax, [esi+studentsoff]
    call WriteDec
    call Crlf

    ret

readRecord ENDP

; Find a saved break for the same section and weekday. Skip the record being edited.
findSectionDayBreak PROC USES ebx esi edi
    xor ebx, ebx
fsdb_loop:
    cmp ebx, recordcount
    jae fsdb_not_found
    cmp ebx, editingIndex
    je fsdb_next
    mov eax, ebx
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    mov edi, breakLookupPtr
    lea esi, [esi+sectionoff]
    lea edi, [edi+sectionoff]
    call compareStr
    cmp eax, 1
    jne fsdb_next
    mov eax, ebx
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    mov edi, breakLookupPtr
    mov eax, [esi+dayoff]
    cmp eax, [edi+dayoff]
    jne fsdb_next
    mov eax, [esi+breakoff]
    ret
fsdb_next:
    inc ebx
    jmp fsdb_loop
fsdb_not_found:
    xor eax, eax
    ret
findSectionDayBreak ENDP

; Return a section's saved enrollment, or zero when the section is new.
findSectionEnrollment PROC USES ebx esi edi
    xor ebx, ebx
fse_loop:
    cmp ebx, recordcount
    jae fse_not_found
    mov eax, ebx
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    mov edi, sectionLookupPtr
    lea esi, [esi+sectionoff]
    lea edi, [edi+sectionoff]
    call compareStr
    cmp eax, 1
    je fse_found
    inc ebx
    jmp fse_loop
fse_found:
    mov eax, ebx
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    mov eax, [esi+studentsoff]
    ret
fse_not_found:
    xor eax, eax
    ret
findSectionEnrollment ENDP


; new record array ke end mein add karna
addRecord PROC USES esi

    cmp recordcount, MAX_RECORDS
    jae recordFull

    mov eax, recordcount
    imul eax, recordsize

    mov esi, OFFSET records
    add esi, eax

    mov editingIndex, 0FFFFFFFFh

    call showAvailableCourses
    call showAvailableSections
    mov edx, OFFSET sectionFormatInfo
    call WriteString
    call Crlf

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

; Count distinct strings at uniqueOffset. editingIndex is excluded during edits.
countUniqueValues PROC USES ebx ecx esi edi
    mov uniqueCount, 0
    mov uniqueOuter, 0
cuv_outer:
    mov eax, uniqueOuter
    cmp eax, recordcount
    jae cuv_done
    mov eax, uniqueOuter
    cmp eax, editingIndex
    je cuv_next_outer
    mov eax, uniqueOuter
    imul eax, recordsize
    add eax, OFFSET records
    add eax, uniqueOffset
    mov uniquePtr, eax
    mov uniqueInner, 0
    mov uniqueDuplicate, 0
cuv_inner:
    mov eax, uniqueInner
    cmp eax, uniqueOuter
    jae cuv_count
    cmp eax, editingIndex
    je cuv_next_inner
    mov eax, uniqueInner
    imul eax, recordsize
    add eax, OFFSET records
    add eax, uniqueOffset
    mov esi, eax
    mov edi, uniquePtr
    call compareStr
    cmp eax, 1
    je cuv_is_duplicate
cuv_next_inner:
    inc uniqueInner
    jmp cuv_inner
cuv_is_duplicate:
    mov uniqueDuplicate, 1
cuv_count:
    cmp uniqueDuplicate, 1
    je cuv_next_outer
    inc uniqueCount
cuv_next_outer:
    inc uniqueOuter
    jmp cuv_outer
cuv_done:
    mov eax, uniqueCount
    ret
countUniqueValues ENDP

showAdminStatus PROC USES eax edx
    mov edx, OFFSET sectionStatusLabel
    call WriteString
    mov uniqueOffset, sectionoff
    call countUniqueValues
    call WriteDec
    mov edx, OFFSET slashText
    call WriteString
    mov eax, MAX_SECTIONS
    call WriteDec
    call Crlf

    mov edx, OFFSET courseStatusLabel
    call WriteString
    mov uniqueOffset, courseoff
    call countUniqueValues
    call WriteDec
    mov edx, OFFSET slashText
    call WriteString
    mov eax, MAX_COURSES
    call WriteDec
    call Crlf

    mov edx, OFFSET sectionFormatInfo
    call WriteString
    call Crlf
    ret
showAdminStatus ENDP

; Find a record by section, course, day, and slot (slot determines its time).
findRecordByKeys PROC USES ebx esi edi
fr_section:
    mov edx, OFFSET findsectionmsg
    call WriteString
    mov edx, OFFSET search_str
    mov ecx, 9
    call ReadString
    cmp eax, 0
    jne fr_course
    mov edx, OFFSET emptysectionerr
    call WriteString
    call Crlf
    jmp fr_section
fr_course:
    mov edx, OFFSET findcoursemsg
    call WriteString
    mov edx, OFFSET lookupCourseBuf
    mov ecx, 29
    call ReadString
    cmp eax, 0
    jne fr_day
    mov edx, OFFSET emptycourseerr
    call WriteString
    call Crlf
    jmp fr_course
fr_day:
    mov edx, OFFSET finddaymsg
    call WriteString
    call ReadInt
    cmp eax, 1
    jl fr_day_error
    cmp eax, 5
    jg fr_day_error
    mov lookupDay, eax
    jmp fr_slot
fr_day_error:
    mov edx, OFFSET dayerr
    call WriteString
    call Crlf
    jmp fr_day
fr_slot:
    mov edx, OFFSET findslotmsg
    call WriteString
    call ReadInt
    cmp eax, 1
    jl fr_slot_error
    cmp eax, 8
    jg fr_slot_error
    mov lookupSlot, eax
    jmp fr_search
fr_slot_error:
    mov edx, OFFSET sloterr
    call WriteString
    call Crlf
    jmp fr_slot
fr_search:
    xor ebx, ebx
fr_loop:
    cmp ebx, recordcount
    jae fr_not_found
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov eax, [esi+dayoff]
    cmp eax, lookupDay
    jne fr_next
    mov eax, [esi+slotoff]
    cmp eax, lookupSlot
    jne fr_next
    lea esi, [esi+sectionoff]
    mov edi, OFFSET search_str
    call compareStr
    cmp eax, 1
    jne fr_next
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    lea esi, [esi+courseoff]
    mov edi, OFFSET lookupCourseBuf
    call compareStr
    cmp eax, 1
    je fr_found
fr_next:
    inc ebx
    jmp fr_loop
fr_found:
    mov eax, ebx
    ret
fr_not_found:
    mov eax, 0FFFFFFFFh
    ret
findRecordByKeys ENDP

; Edit without printing the entire 1,000-record table. Input is validated in
; a temporary record so a rejected edit cannot damage the saved record.
editRecord PROC USES esi edi ecx
    cmp recordcount, 0
    je editEmpty
    call showAvailableCourses
    call showAvailableSections
    mov edx, OFFSET sectionFormatInfo
    call WriteString
    call Crlf
    call findRecordByKeys
    cmp eax, 0FFFFFFFFh
    je editNotFound
    mov editingIndex, eax
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    call showFullRecord
    mov esi, OFFSET editBuffer
    call readRecord
    mov esi, OFFSET editBuffer
    call validateRecord
    cmp eax, 1
    jne editRejected
    mov edi, OFFSET records
    mov eax, editingIndex
    imul eax, recordsize
    add edi, eax
    mov esi, OFFSET editBuffer
    mov ecx, recordsize
    cld
    rep movsb
    mov editingIndex, 0FFFFFFFFh
    call saveData
    mov edx, OFFSET emsg
    call WriteString
    call Crlf
    call WaitMsg
    ret
editRejected:
    mov editingIndex, 0FFFFFFFFh
    call WaitMsg
    ret
editNotFound:
    mov edx, OFFSET notfound_msg
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
deleteRecord PROC USES ebx ecx esi edi
    cmp recordcount, 0
    je deleteEmpty
    call showAvailableCourses
    call showAvailableSections
    mov edx, OFFSET sectionFormatInfo
    call WriteString
    call Crlf
    call findRecordByKeys
    cmp eax, 0FFFFFFFFh
    je deleteNotFound
    mov ebx, eax
    mov eax, recordcount
    dec eax
    sub eax, ebx
    jz deleteLast
    mov ecx, eax
    imul ecx, recordsize
    mov edi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add edi, eax
    mov esi, edi
    add esi, recordsize
    cld
    rep movsb
deleteLast:
    dec recordcount
    mov editingIndex, 0FFFFFFFFh
    call saveData
    mov edx, OFFSET dmsg2
    call WriteString
    call Crlf
    call WaitMsg
    ret
deleteNotFound:
    mov edx, OFFSET notfound_msg
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

; ESI points to the new/edited record. Different sections may run in parallel;
; a section, teacher, or room cannot be double-booked at the same time.
validateRecord PROC USES ebx ecx esi edi
    mov validationPtr, esi
    xor ebx, ebx
    xor ecx, ecx
    mov courseMeetingCount, 0
    mov newSectionFound, 0
    mov newCourseFound, 0
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
    lea esi, [esi+courseoff]
    lea edi, [edi+courseoff]
    call compareStr
    cmp eax, 1
    jne vr_section_check
    mov newCourseFound, 1
vr_section_check:
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov edi, validationPtr
    mov sectionMatch, 0
    mov courseMatch, 0
    lea esi, [esi+sectionoff]
    lea edi, [edi+sectionoff]
    call compareStr
    cmp eax, 1
    jne vr_check_day
    mov sectionMatch, 1
    mov newSectionFound, 1
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov edi, validationPtr
    mov eax, [esi+studentsoff]
    cmp eax, [edi+studentsoff]
    jne vr_section_bad
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov edi, validationPtr
    lea esi, [esi+courseoff]
    lea edi, [edi+courseoff]
    call compareStr
    cmp eax, 1
    jne vr_check_day
    mov courseMatch, 1
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov edi, validationPtr
    mov eax, [esi+creditoff]
    cmp eax, [edi+creditoff]
    jne vr_credit_bad
    inc courseMeetingCount
    jmp vr_check_day
vr_section_bad:
    mov edx, OFFSET sectionerr
    call WriteString
    call Crlf
    xor eax, eax
    ret
vr_credit_bad:
    mov edx, OFFSET crediterr
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
    cmp sectionMatch, 1
    jne vr_check_slot
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
    cmp sectionMatch, 1
    je vr_clash
    ; Check teacher conflict.
    lea esi, [esi+teacheroff]
    lea edi, [edi+teacheroff]
    call compareStr
    cmp eax, 1
    je vr_clash
    ; Rebuild pointers and check room conflict.
    mov esi, OFFSET records
    mov eax, ebx
    imul eax, recordsize
    add esi, eax
    mov edi, validationPtr
    lea esi, [esi+roomoff]
    lea edi, [edi+roomoff]
    call compareStr
    cmp eax, 1
    jne vr_next
vr_clash:
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
    jae vr_daily_bad
    mov esi, validationPtr
    mov eax, [esi+creditoff]
    cmp courseMeetingCount, eax
    jae vr_meeting_bad
    cmp newSectionFound, 1
    je vr_course_limit_check
    mov uniqueOffset, sectionoff
    call countUniqueValues
    cmp eax, MAX_SECTIONS
    jae vr_section_limit_bad
vr_course_limit_check:
    cmp newCourseFound, 1
    je vr_ok
    mov uniqueOffset, courseoff
    call countUniqueValues
    cmp eax, MAX_COURSES
    jae vr_course_limit_bad
    jmp vr_ok
vr_section_limit_bad:
    mov edx, OFFSET sectionLimitErr
    call WriteString
    call Crlf
    xor eax, eax
    ret
vr_course_limit_bad:
    mov edx, OFFSET courseLimitErr
    call WriteString
    call Crlf
    xor eax, eax
    ret
vr_meeting_bad:
    mov edx, OFFSET weeklyMeetingErr
    call WriteString
    call Crlf
    xor eax, eax
    ret
vr_daily_bad:
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

    mov edx, OFFSET rtime
    call WriteString
    call printStartTime
    call Crlf

    mov edx, OFFSET rcredit
    call WriteString
    mov eax, [esi+creditoff]
    call WriteDec
    call Crlf

    mov edx, OFFSET rkind
    call WriteString
    mov eax, [esi+kindoff]
    cmp eax, 1
    je sfr_core
    cmp eax, 2
    je sfr_normal
    mov edx, OFFSET labmsg
    jmp sfr_kind_done
sfr_core:
    mov edx, OFFSET coremsg
    jmp sfr_kind_done
sfr_normal:
    mov edx, OFFSET normalmsg
sfr_kind_done:
    call WriteString
    call Crlf

    mov edx, OFFSET rstudents
    call WriteString
    mov eax, [esi+studentsoff]
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
    mov edx, OFFSET sop6
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
    je search_teacher
    cmp eax, 6
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

search_teacher:
    call searchByTeacher
    jmp st_loop

st_exit:
    ret
studentMenu ENDP


; Assign one ID per unique course in the selected section. Repeated weekly
; meetings of the same course reuse that ID in every timetable slot.
buildSectionCourseIDs PROC USES eax ebx ecx edx esi edi
    mov gridCourseCount, 0
    mov gridIndex, 0
bsc_outer:
    mov eax, gridIndex
    cmp eax, recordcount
    jae bsc_done
    mov eax, gridIndex
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea esi, [esi+sectionoff]
    mov edi, OFFSET gridSection
    call compareStr
    cmp eax, 1
    jne bsc_not_section

    mov gridInner, 0
    mov gridMatchedCourseID, 0
bsc_inner:
    mov eax, gridInner
    cmp eax, gridIndex
    jae bsc_assign
    mov ebx, gridInner
    mov eax, courseIds[ebx*4]
    test eax, eax
    jz bsc_inner_next
    mov eax, gridIndex
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea esi, [esi+courseoff]
    mov eax, gridInner
    imul eax, recordsize
    mov edi, OFFSET records
    add edi, eax
    lea edi, [edi+courseoff]
    call compareStr
    cmp eax, 1
    jne bsc_inner_next
    mov ebx, gridInner
    mov eax, courseIds[ebx*4]
    mov gridMatchedCourseID, eax
    jmp bsc_assign
bsc_inner_next:
    inc gridInner
    jmp bsc_inner
bsc_assign:
    mov ebx, gridIndex
    cmp gridMatchedCourseID, 0
    jne bsc_use_existing
    inc gridCourseCount
    mov eax, gridCourseCount
    mov courseIds[ebx*4], eax
    jmp bsc_outer_next
bsc_use_existing:
    mov eax, gridMatchedCourseID
    mov courseIds[ebx*4], eax
    jmp bsc_outer_next
bsc_not_section:
    mov ebx, gridIndex
    mov DWORD PTR courseIds[ebx*4], 0
bsc_outer_next:
    inc gridIndex
    jmp bsc_outer
bsc_done:
    ret
buildSectionCourseIDs ENDP

; Print each weekday on one row and each of its eight slots in a column.
showTimetableGrid PROC USES eax ebx ecx edx esi edi
    call Clrscr
    mov edx, OFFSET gridtitle
    call WriteString
    call Crlf
    call Crlf
    cmp recordcount, 0
    je grid_empty

    call showAvailableSections

grid_read_section:
    mov edx, OFFSET gridSectionPrompt
    call WriteString
    mov edx, OFFSET gridSection
    mov ecx, 9
    call ReadString
    cmp eax, 0
    jne grid_section_ok
    mov edx, OFFSET emptysectionerr
    call WriteString
    call Crlf
    jmp grid_read_section
grid_section_ok:
    call Crlf
    mov gridSectionFound, 0
    call buildSectionCourseIDs

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
    lea esi, [esi+sectionoff]
    mov edi, OFFSET gridSection
    call compareStr
    cmp eax, 1
    jne grid_find_next
    mov eax, gridIndex
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    mov ebx, gridIndex
    mov eax, courseIds[ebx*4]
    mov gridRecordNumber, eax
    mov gridFound, 1
    inc gridSectionFound
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
    mov gridCourseID, 1
grid_key_loop:
    mov eax, gridCourseID
    cmp eax, gridCourseCount
    ja grid_key_done
    mov gridFindIndex, 0
grid_find_key:
    mov eax, gridFindIndex
    cmp eax, recordcount
    jae grid_next_key_id
    mov ebx, gridFindIndex
    mov eax, courseIds[ebx*4]
    cmp eax, gridCourseID
    je grid_key_found
    inc gridFindIndex
    jmp grid_find_key
grid_key_found:
    mov eax, gridCourseID
    call WriteDec
    mov edx, OFFSET gridKeyCourse
    call WriteString
    mov eax, gridFindIndex
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea edx, [esi+courseoff]
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
grid_next_key_id:
    inc gridCourseID
    jmp grid_key_loop
grid_key_done:
    cmp gridSectionFound, 0
    jne grid_key_return
    mov edx, OFFSET notfound_msg
    call WriteString
    call Crlf
grid_key_return:
    ret
grid_empty:
    mov edx, OFFSET nomsg
    call WriteString
    call Crlf
    ret
showTimetableGrid ENDP

; The grid stays narrow: one course ID in each occupied slot. Repeated meetings
; of the same weekly course use the same ID.
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
    cmp gridRecordNumber, 1000
    jae gprn_four_digits
    mov ecx, 2
    jmp gprn_spaces
gprn_four_digits:
    mov ecx, 1
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

    call showAvailableCourses

sc_read:
    mov edx, OFFSET cmsg
    call WriteString
    mov edx, OFFSET search_str
    mov ecx, 29
    call ReadString
    cmp eax, 0
    jne sc_input_ok
    mov edx, OFFSET emptycourseerr
    call WriteString
    call Crlf
    jmp sc_read
sc_input_ok:
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

showAvailableCourses PROC USES eax ebx ecx edx esi edi
    mov edx, OFFSET availableCoursesTitle
    call WriteString
    call Crlf
    mov availableOuter, 0
avc_outer:
    mov eax, availableOuter
    cmp eax, recordcount
    jae avc_done
    mov eax, availableOuter
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea esi, [esi+courseoff]
    mov availablePtr, esi
    mov availableInner, 0
    mov availableDuplicate, 0
avc_inner:
    mov eax, availableInner
    cmp eax, availableOuter
    jae avc_print
    mov eax, availableInner
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea esi, [esi+courseoff]
    mov edi, availablePtr
    call compareStr
    cmp eax, 1
    je avc_is_duplicate
    inc availableInner
    jmp avc_inner
avc_is_duplicate:
    mov availableDuplicate, 1
avc_print:
    cmp availableDuplicate, 1
    je avc_next
    mov esi, availablePtr
    mov edx, esi
    call WriteString
    call Crlf
avc_next:
    inc availableOuter
    jmp avc_outer
avc_done:
    call Crlf
    ret
showAvailableCourses ENDP

searchByTeacher PROC USES ebx esi edi
    call Clrscr
    cmp recordcount, 0
    je st_empty
    call showAvailableTeachers
st_read:
    mov edx, OFFSET teacherSearchMsg
    call WriteString
    mov edx, OFFSET search_str
    mov ecx, 29
    call ReadString
    cmp eax, 0
    jne st_input_ok
    mov edx, OFFSET requiredfielderr
    call WriteString
    call Crlf
    jmp st_read
st_input_ok:
    call Crlf
    mov found_flag, 0
    mov ebx, 0
st_loop_records:
    cmp ebx, recordcount
    jge st_done
    mov eax, ebx
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    push esi
    lea esi, [esi+teacheroff]
    mov edi, OFFSET search_str
    call compareStr
    pop esi
    cmp eax, 1
    jne st_next
    call showFullRecord
    mov found_flag, 1
st_next:
    inc ebx
    jmp st_loop_records
st_done:
    cmp found_flag, 0
    jne st_wait
    mov edx, OFFSET notfound_msg
    call WriteString
    call Crlf
st_wait:
    call WaitMsg
    ret
st_empty:
    mov edx, OFFSET nomsg
    call WriteString
    call Crlf
    call WaitMsg
    ret
searchByTeacher ENDP


searchBySection PROC USES ebx esi edi
    call Clrscr
    cmp recordcount, 0
    je ss_empty

    call showAvailableSections

ss_read:
    mov edx, OFFSET secmsg
    call WriteString
    mov edx, OFFSET search_str
    mov ecx, 9
    call ReadString
    cmp eax, 0
    jne ss_input_ok
    mov edx, OFFSET emptysectionerr
    call WriteString
    call Crlf
    jmp ss_read
ss_input_ok:
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

    mov currentRecordPtr, esi
    mov currentRecordIndex, ebx
    call isFirstCourseMeeting
    cmp eax, 1
    jne ss_next
    mov esi, currentRecordPtr
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

showAvailableSections PROC USES eax ebx ecx edx esi edi
    mov edx, OFFSET availableSectionsTitle
    call WriteString
    call Crlf
    mov availableOuter, 0
avs_outer:
    mov eax, availableOuter
    cmp eax, recordcount
    jae avs_done
    mov eax, availableOuter
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea esi, [esi+sectionoff]
    mov availablePtr, esi
    mov availableInner, 0
    mov availableDuplicate, 0
avs_inner:
    mov eax, availableInner
    cmp eax, availableOuter
    jae avs_print
    mov eax, availableInner
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea esi, [esi+sectionoff]
    mov edi, availablePtr
    call compareStr
    cmp eax, 1
    je avs_is_duplicate
    inc availableInner
    jmp avs_inner
avs_is_duplicate:
    mov availableDuplicate, 1
avs_print:
    cmp availableDuplicate, 1
    je avs_next
    mov esi, availablePtr
    mov edx, esi
    call WriteString
    call Crlf
avs_next:
    inc availableOuter
    jmp avs_outer
avs_done:
    call Crlf
    ret
showAvailableSections ENDP

showAvailableTeachers PROC USES eax ebx ecx edx esi edi
    mov edx, OFFSET availableTeachersTitle
    call WriteString
    call Crlf
    mov availableOuter, 0
avt_outer:
    mov eax, availableOuter
    cmp eax, recordcount
    jae avt_done
    mov eax, availableOuter
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea esi, [esi+teacheroff]
    mov availablePtr, esi
    mov availableInner, 0
    mov availableDuplicate, 0
avt_inner:
    mov eax, availableInner
    cmp eax, availableOuter
    jae avt_print
    mov eax, availableInner
    imul eax, recordsize
    mov esi, OFFSET records
    add esi, eax
    lea esi, [esi+teacheroff]
    mov edi, availablePtr
    call compareStr
    cmp eax, 1
    je avt_is_duplicate
    inc availableInner
    jmp avt_inner
avt_is_duplicate:
    mov availableDuplicate, 1
avt_print:
    cmp availableDuplicate, 1
    je avt_next
    mov esi, availablePtr
    mov edx, esi
    call WriteString
    call Crlf
avt_next:
    inc availableOuter
    jmp avt_outer
avt_done:
    call Crlf
    ret
showAvailableTeachers ENDP

; Return 1 only for the first weekly meeting of a course in the selected section.
isFirstCourseMeeting PROC USES ebx esi edi
    mov creditScanIndex, 0
ifcm_loop:
    mov eax, creditScanIndex
    cmp eax, currentRecordIndex
    jae ifcm_first
    mov esi, OFFSET records
    mov eax, creditScanIndex
    imul eax, recordsize
    add esi, eax
    lea esi, [esi+sectionoff]
    mov edi, OFFSET search_str
    call compareStr
    cmp eax, 1
    jne ifcm_next
    mov esi, OFFSET records
    mov eax, creditScanIndex
    imul eax, recordsize
    add esi, eax
    mov edi, currentRecordPtr
    lea esi, [esi+courseoff]
    lea edi, [edi+courseoff]
    call compareStr
    cmp eax, 1
    je ifcm_not_first
ifcm_next:
    inc creditScanIndex
    jmp ifcm_loop
ifcm_first:
    mov eax, 1
    ret
ifcm_not_first:
    xor eax, eax
    ret
isFirstCourseMeeting ENDP


filterByDay PROC USES ebx esi
    call Clrscr
    cmp recordcount, 0
    je fd_empty

fd_input:
    mov edx, OFFSET dmsg
    call WriteString
    call ReadInt

    cmp eax, 1
    jge fd_day_min
    mov edx, OFFSET dayerr
    call WriteString
    call Crlf
    jmp fd_input
fd_day_min:
    cmp eax, 5
    jle fd_day_valid
    mov edx, OFFSET dayerr
    call WriteString
    call Crlf
    jmp fd_input
fd_day_valid:

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
    cmp eax, MAX_RECORDS
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
