# UniSlot
COAL LAB PROJECT
# UniSlot: University Class Timetable Manager

## Project Overview

UniSlot is a MASM assembly language program for managing university class timetables. It uses the Irvine32 library for console input and output, and provides separate Admin and Student panels. Class records are stored in a binary data file so timetable information can be loaded again when the program starts.

## Data Model

Each timetable record stores the course name, teacher, room, section, day, time slot, credit hours, daily break position, course type, and section enrollment.

One record represents one scheduled class meeting. A course that meets multiple times per week therefore appears in multiple records, with the same course and section information and a different day or slot.

The supplied starter dataset contains 50 unique courses, 25 sections, 200 students, and 200 weekly class-meeting records. Section enrollments range from 6 to 10 students, below the program’s maximum of 40 per section. The dataset includes courses such as Data Structures, Discrete Structures, COAL, Linear Algebra, Programming Fundamentals, Theory of Automata, and Applied Physics.

## Scheduling Rules

- The timetable supports weekdays Monday through Friday and up to 8 class slots per section per day.
- Each class lasts 50 minutes. The daily break is 50 minutes, and classes have a 5-minute buffer between adjacent slots.
- The break position is selected after slot 3, 4, or 5, which keeps uninterrupted class runs to at most 5.
- A 3-credit course has 3 weekly meetings, a 2-credit course has 2, and a 1-credit course has 1. The supplied dataset follows this pattern, and validation prevents adding meetings beyond the course’s credit count.
- Different sections can have classes at the same time when they use different rooms and teachers. The program checks for conflicts involving the same section, teacher, or room.
- Core courses allow up to 3 credit hours, normal courses up to 2, and labs 1.

## Admin Features

The Admin Panel is password-protected and supports adding, editing, and deleting class meetings. The admin view shows the current counts against the limits of 25 sections and 50 unique courses, along with the section-name format. Available course and section names are displayed during add, edit, and delete actions.

Editing and deleting locate a class by section, course, day, and slot rather than displaying the full record list. The slot determines the class time. Input checks provide messages for invalid days, slots, break positions, course types, credit hours, and student counts.

## Student Features

Students can view a section’s timetable in a compact weekday-by-slot grid. Each unique course in that section receives one course ID, reused for all its weekly meetings; the key below the grid lists each course once.

The Student Panel also supports searching by course, section, or teacher, and filtering by day. Course and section searches display available names first. Teacher search displays the available teacher names first.

## File Storage

`unislot.dat` begins with a record count followed by fixed-size binary records matching the MASM structure. The program loads the file at startup and saves admin changes back to it. The file must be in the program’s working folder, commonly the folder containing the built executable.

## Implementation Note

The supplied dataset contains the required weekly meeting counts for each course. During manual entry, validation prevents exceeding a course’s credit-based meeting count, but it does not require an admin to enter every required weekly meeting before saving.

The latest source has not been compiled in this workspace because MASM and Irvine32 are unavailable here.
