**1. Introduction to UNIX** 
----
UNIX is an operating system which was first developed in the 1960s, and has been under constant development ever since. By operating system, we mean the suite of programs which make the computer work. It is a stable, multi-user, multi-tasking system for servers, desktops and laptops.
UNIX systems also have a graphical user interface (GUI) similar to Microsoft Windows which provides an easy to use environment. However, knowledge of UNIX is required for operations which aren't covered by a graphical program, or for when there is no windows interface available, for example, in a telnet session.

[`Types of UNIX`](https://www.softwaretestinghelp.com/unix-vs-linux/)
There are many different versions of UNIX, although they share common similarities. The most popular varieties of UNIX are Sun Solaris, GNU/Linux, and MacOS X.

[`The UNIX operating system`](https://www.softwaretestinghelp.com/unix-introduction)
The UNIX operating system is made up of three parts; the kernel, the shell and the programs.

The kernel
>The kernel of UNIX is the hub of the operating system: it allocates time and memory to programs and handles the filestore and communications in response to system calls.

The shell
>The shell acts as an interface between the user and the kernel. When a user logs in, the login program checks the username and password, and then starts another program called the shell. The shell is a command line interpreter (CLI). It interprets the commands the user types in and arranges for them to be carried out. The commands are themselves programs: when they terminate, the shell gives the user another prompt (% on our systems).

>Filename Completion - By typing part of the name of a command, filename or directory and pressing the [Tab] key, the tcsh shell will complete the rest of the name automatically. If the shell finds more than one name beginning with those letters you have typed, it will beep, prompting you to type a few more letters before pressing the tab key again.

>History - The shell keeps a list of the commands you have typed in. If you need to repeat a command, use the cursor keys to scroll up and down the list or type history for a list of previous commands.

The programs
>The OS provides an environment that enables users to execute other programs efficiently. Comprising of a set of system programs, the operating system functions include storage management, file handling, memory management, CPU and device scheduling and management, error handling, process control and more

**1.1 UNIX architecture**  \
Here is a basic block diagram of a Unix system − \
![Disk Diagram of Unix System](https://www.tutorialspoint.com/unix/images/unix_architecture.jpg) \
The main concept that unites all the versions of Unix is the following four basics −
- *Kernel* − The kernel is the heart of the operating system. It interacts with the hardware and most of the tasks like memory management, task scheduling and file management.
- *Shell* − The shell is the utility that processes your requests. When you type in a command at your terminal, the shell interprets the command and calls the program that you want. The shell uses standard syntax for all commands. C Shell, Bourne Shell and Korn Shell are the most famous shells which are available with most of the Unix variants. 
- *Commands and Utilities* − There are various commands and utilities which you can make use of in your day to day activities. cp, mv, cat and grep, etc. are few examples of commands and utilities. There are over 250 standard commands plus numerous others provided through 3rd party software. All the commands come along with various options. 
- *Files and Directories* − All the data of Unix is organized into files. All files are then organized into directories. These directories are further organized into a tree-like structure called the filesystem

**1.2 System boot** \
If you have a computer which has the Unix operating system installed in it, then you simply need to turn on the system to make it live.
As soon as you turn on the system, it starts booting up and finally it prompts you to [log into the system](https://www.tutorialspoint.com/unix/images/unix_architecture.jpg), which is an activity to log into the system and use it for your day-to-day activities  

**2.LINUX vs Windows**
-------
Mac OS uses a UNIX core. Your switch from Mac OS to Linux will be relatively smooth. \
It's the Windows users who will need some adjusting. In this tutorial will introduce the Linux OS and compare it with Windows.

**2.1 Windows vs LINUX file system**  \
In Microsoft Windows, files are stored in folders on different data drives like C: D: E: . \
But, in Linux, files are ordered in a tree structure starting with the root directory.\
This root directory can be considered as the start of the file system, and it further branches out various other subdirectories. The root is denoted with a forward slash '/'.\
A general [tree file system](https://www.geeksforgeeks.org/wp-content/uploads/unix.png) on your UNIX may look like this.
![Tree structure](https://www.guru99.com/images/FolderStructure.png)  
