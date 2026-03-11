# Lab - Shell Scripting and Tools

You may work in groups up to 3 for this lab. You will submit 3 shell scripts on Gradescope and complete this week's exit ticket. Those with Windows machines are encouraged to form groups with and pair program with those with Unix and Unix-like (e.g., Mac/Linux) machines.

This is a long written lab, but an in-class demo will cover most of the written materials (here for your reference). Feel free to skip to the "Start Here" section after you've seen the demo.

TL;DR recommended flow:

1. Open the built-in (or your preferred) terminal application
2. Follow along for the live demo
3. Skip down to the exercises, read and understand the bash scripts you're supposed to write
4. Read the exercise and submission requirements

## Learning Goals

- Become familiar with the file system in unix-like operating systems.
- Use the shell instead of the usual graphical user interface to achieve basic operations.
- Put these shell commands into a `bash` scripting language.
- Be exposed to a number of shell tools that cover several of the most common tasks that you will be constantly performing in the command line.

## Key terms and concepts

- `File system` - a method and data structure that the operating system uses to control how data are stored and retrieved. The file system is responsible for organizing files and directories.
- `Shell` - a computer program that exposes an operating system's services to a user or other programs. In general, operating system shells use either a textual, command-line interface (CLI) or a graphical user interface (GUI). It is named a shell because it is the outermost layer around the operating system. Guess what the innermost layer is called? Kernel 😊
- `Scripting languages` - programming languages used to manipulate, customize, and automate processes. Scripting languages are usually interpreted at runtime rather than compiled. For example, (normally) a `Java` program would need to be compiled but a scripting language, like `bash`, `JavaScript`, or `Python` do not.
- `stdin`, `std`, `stderr` - three [standard streams](https://en.wikipedia.org/wiki/Standard_streams) that are established when you run a command in a Unix-like system. Standard input or `stdin` is a stream from which a program *reads* its input data. This is usually associated with the keyboard. Text output from the command to the shell is delivered via the standard out or `stdout` stream. Error messages are sent through the standard error or `stderr` stream.

## The Shell

### What the shell?

Computers these days have a variety of interfaces for executing commands;
fanciful graphical user interfaces, voice interfaces, and even AR/VR are
everywhere. These are great for 80% of use-cases, but they are often
fundamentally restricted in what they allow you to do — you cannot press a
button that isn't there or give a voice command that hasn't been programmed. To
take full advantage of the tools your computer provides, we have to go
old-school and drop down to a textual command-line interface: The Shell.

Nearly all platforms have a shell in one form or another, and many of them have
several shells for you to choose from. While they may vary in the details, at
their core they are all roughly the same: they allow you to run programs, give
them input, and inspect their output in a semi-structured way.

In this lab, we will focus on the Bourne Again SHell, or "bash" for short. To be
more accurate, since the lab machines run macOS, we will use `zsh` which is an
extended version of `bash`.

To open a shell *prompt* (where you can type commands), you first need a *terminal*.

- If you are on macOS (either your personal laptop or the lab machines), go on launchpad and look for the application `Terminal`. Alternatively, you can install [iTerm2](https://iterm2.com/), a better terminal (this is what Prof. Li uses/recommends!).
- If you are on Windows, you can use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/) or a Linux virtual machine to use Unix-style command-line tools.
- Linux distributions come with a variety of terminals and shells. Let us know if you need help finding one on your Linux machine.

### Using the shell

Note: We will be doing a demo of this in class.

When you launch your terminal, you will see a *prompt* that often looks a little like this if you are on `bash`:

```console
apaa2017@APAA2017-MAC21~$
```

or this if you are on `zsh` (our case, most likely)

```console
apaa2017@APAA2017-MAC21 ~ %
```

**Side note:** To make sure you're running an appropriate shell, you can try the command `echo $SHELL` (just type the command and hit return/Enter). It should say something like `/bin/bash` or `/usr/bin/zsh`

This is the main textual interface to the shell. In the example above, it tells us that I am user `apaa2017` on the machine `APAA2017-MAC21` and that my "current working directory" (i.e. where I currently am within the file system) is `~` (short for "home"). At this prompt, you can type a *command*, which will then be interpreted by the shell.

Try the following command which runs the program `date`. You should see something similar:

```console
apaa2017@APAA2017-MAC21 ~ % date
Wed Mar 7 21:12:21 PST 2024
apaa2017@APAA2017-MAC21 ~ %
```

Here, we executed the `date` program, which (perhaps unsurprisingly)
prints the current date and time. The shell then asks us for another
command to execute. We can also execute a command with *arguments*, e.g.,:

```console
apaa2017@APAA2017-MAC21 ~ % echo hello
hello
```

In this case, we told the shell to execute the program `echo` with the
argument `hello`. The `echo` program simply prints out its arguments,
just like the `print` or `System.out.println` methods work in Python and Java.
The shell parses the command by splitting it by whitespace, and then
runs the program indicated by the first word, supplying each subsequent
word as an argument that the program can access.

Note that we did not need quotes around the argument since it was a single word.
If you want to provide an argument that contains spaces or other special
characters (e.g., a directory named `My Photos`), you can either quote the
argument with `'` or `"` (e.g., `"My Photos"`), or escape just the relevant
characters with `\` (e.g., `My\ Photos`).

But how does the shell know how to find the `date` or `echo` programs? Well, the
shell is a programming environment, just like Python or Java, and so it has
variables, conditionals, loops, and functions (coming soon!). When you run
commands in your shell, you are really writing a small bit of code that your
shell interprets. If the shell is asked to execute a command that doesn't match
one of its programming keywords, it consults an *environment variable* called
`$PATH` that lists which directories the shell should search for programs when
it is given a command. Type the following to see what your `$PATH` environment
variable contains (it will probably be different than mine):

```console
apaa2017@APAA2017-MAC21 ~ % echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

When we run the `date` command, the shell sees that it should execute
the program `date`, and then searches through the `:`-separated list of
directories in `$PATH` for a file by that name. When it finds it, it
runs it (assuming the file is *executable*; more on that later). We can
find out which file is executed for a given program name using the
`which` (or `type`) program.

```console
apaa2017@APAA2017-MAC21 ~ % which date
/bin/date
```

We can also bypass `$PATH` entirely by typing the *path* to the file we want to execute.

```console
apaa2017@APAA2017-MAC21 ~ % /bin/date
Wed Mar 7 21:25:21 PST 2024
```

### Navigating the file system in the shell

A path on the shell is a delimited list of directories; separated by `/`
on Linux and macOS and `\` on Windows. On Linux and macOS, the path `/`
is the "root" of the file system, under which all directories and files
lie, whereas on Windows there is one root for each disk partition (e.g.,
`C:\`). We will generally assume that you are using a Linux or macOS filesystem
in CS62.

A path that starts with `/` is called an *absolute* path. Any other path is a
*relative* path. Relative paths are relative to the current working directory,
which we can see with the `pwd` command and change with the `cd` command.

In a path, `.` refers to the current directory and `..` to its parent directory:

```console
apaa2017@APAA2017-MAC21 ~ % pwd
/Users/apaa2017
apaa2017@APAA2017-MAC21 ~ % cd /Users
apaa2017@APAA2017-MAC21 /Users % pwd
/Users
apaa2017@APAA2017-MAC21 /Users % cd ..
apaa2017@APAA2017-MAC21 / % pwd
/
apaa2017@APAA2017-MAC21 / % cd ./Users
apaa2017@APAA2017-MAC21 /Users % pwd
/Users
apaa2017@APAA2017-MAC21 /Users % cd apaa2017
apaa2017@APAA2017-MAC21 ~ %  pwd
/Users/apaa2017
apaa2017@APAA2017-MAC21 ~ %  ../../bin/date
Wed Mar 7 22:12:21 PST 2024
```

Notice that our shell prompt kept us informed about what our current
working directory was. You can configure your prompt to show you all
sorts of useful information, which we will cover in a later lab.

In general, when we run a program, it will operate in the current
directory unless we tell it otherwise. For example, it will usually
search for files there, and create new files there if it needs to.

To see what lives in a given directory, we use the `ls` command:

```console
apaa2017@APAA2017-MAC21 ~ % ls
Applications
Desktop
Documents
Downloads
Movies
Music
Pictures
Public
apaa2017@APAA2017-MAC21 ~ % cd ..
apaa2017@APAA2017-MAC21 /Users % ls
apaa2017
apaa2017@APAA2017-MAC21 /Users % cd ..
apaa2017@APAA2017-MAC21 / %  ls
Applications
Library
System
Users
Volumes
bin
cores
dev
etc
home
opt
private
sbin
tmp
usr
var
```

Unless a directory is given as its first argument, `ls` will print the
contents of the current directory. Most commands accept *flags* and
*options* (flags with values, more of this later) that start with `-` to modify their
behavior.  For example, `ls -l` uses a long listing format:

```console
apaa2017@APAA2017-MAC21 / % ls -l /Users
drwxr-xr-x  58 apaa2017  staff  1856 Jul 25 21:35 apaa2017
```

This gives us a bunch more information about each file or directory
present. First, the `d` at the beginning of the line tells us that
`apaa2017` is a directory. If it were `-`, it would denote a simple file.

Then follow three groups of three characters (`rwx`). These indicate what
permissions the **user** who owns the file (in my case, `apaa2017`, generally
abbreviated as `u`), the group who owns the file (in my case, `staff`, generally
abbreviated as `g`), and everyone else (other, generally abbreviated as `o`)
respectively have on the relevant item.

A `-` indicates that the given category (user, group, or other) does not have
the given permission. Above, only the owner is allowed to modify (`w`) the
`apaa2017` directory (i.e., add/remove files in it). To enter a directory, a
user must have "search" (represented by "execute": `x`) permissions on that
directory (and its parents). To list its contents, a user must have read (`r`)
permissions on that directory. For files, the permissions are as you would
expect.

Now try:

```console
apaa2017@APAA2017-MAC21 / % ls -l /bin
```

Notice that nearly all the files in `/bin` have the `x` permission set for the
last group (other), "everyone else", so that anyone can execute those programs.

If you want to quickly jump to your home directory, you can use the tilde.

```console
apaa2017@APAA2017-MAC21 / % cd ~
apaa2017@APAA2017-MAC21 ~ %  pwd
/Users/apaa2017
```

If you want to quickly jump to the root, you can use the slash.

```console
apaa2017@APAA2017-MAC21 ~ %  cd /
apaa2017@APAA2017-MAC21 / %  pwd
/
```

If you want to go to your previous working directory, you can use the dash.

```console
apaa2017@APAA2017-MAC21 / % cd -
~
apaa2017@APAA2017-MAC21 ~ %  pwd
/Users/apaa2017
```

Some other handy programs to know about at this point are

- `mv` (to rename/move a file),
- `cp` (to copy a file),
- `rm` (to delete a file), and
- `mkdir` (to make a new directory).

If you ever want more information about a program's arguments, inputs, outputs,
or how it works in general, give the `man` program a try. It takes as an
argument the name of a program, and shows you its *manual page*. Press `q` to
exit and use arrow keys up and down to scroll. For example, try:

```console
apaa2017@APAA2017-MAC21 / %  man ls
```

### Basic bash commands

Here is a list of some of the most commonly used bash commands. Note that some commands, such as `touch`, are used slightly different in practice than they were intended. Below you will see the most commonly used purposes:

- `pwd`: Print the current working directory.
- `cd <directory>`: Change the working directory to the one specified
- `ls <files>`: List the files specified
- `ls <directory>`: List the files in the named directory. An empty directory specification means the current directory.
- `mkdir <directory>`: Create a new directory with the specified name.
- `touch <file>`: Create a new file with the specified name.
- `rm <files>`: Delete the specified files.
- `rm -rf <directory>` Delete the specified directory, its contents, and (recursively) all the
subdirectories.
- `cp <source> <destination>`: Copy one file to another.
- `cp <files> <destination_directory>`: Copy one or more files to another directory.
- `mv <old_name> <new_name>`: Move or rename a file.
- `mv <files> <destination_directory>`: Move files to another directory, preserving their names.
- `echo <message>`: Print message to the terminal.
- `cat <file>`: Print the contents of a file to the
terminal window.
- `grep <pattern> <file>`: Search for a pattern in a file.
- `chmod`: Change the permissions of a file or directory. More next lab.
- `sudo`: Run a command with administrative privileges (assuming you are on your own computer).
- `history`: Show a list of previously executed commands.
- `javac <files>`: Compile the specified source files (`.java`) into bytecode (`.class`). It requires the `.java` extension at the end of the file(s).
- `java <class>`: Run the `main` method in the specified class. In contrast with `javac`, with `java`, you should *not* specify the extension `.class`.

### Connecting programs

In the shell, programs have three primary "streams" associated with them: their
standard input stream (`stdin`, associated with the number 0) and two output
streams: the standard output stream (`stdout`, associated with the number 1) and
the standard error stream (`stderr`, associated with the number 2).

When the program tries to read input, it reads from the input stream, and when
it prints something, it prints to its output stream, if things have gone right,
or the error stream if an error has occurred.

Normally, a program's input and output are both your terminal. That is, your
keyboard as input and your screen as output. However, we can also rewire those
streams! The simplest forms of redirection is `< file`,  `> file`, and `>>
file`. These let you rewire the input and output streams of a program to a file
respectively:

- `command < file.txt`  Redirect the contents of `file.txt` to the standard input input of `command`
- `command > file.txt`  Redirect the output of `command` to the file `file.txt`, overwriting its contents
- `command >> file.txt` Redirect the output of `command` to the **end** of `file.txt`, appending to its contents

For example:

```console
apaa2017@APAA2017-MAC21 / % cd ~
apaa2017@APAA2017-MAC21 ~ %  echo Hello > hello.txt
apaa2017@APAA2017-MAC21 ~ %  cat hello.txt
Hello
apaa2017@APAA2017-MAC21 ~ %  echo "Hello again :D" >> hello.txt
apaa2017@APAA2017-MAC21 ~ %  cat hello.txt
Hello
Hello again :D
```

Demonstrated in the example above, `cat` is a program that con`cat`enates
files. When given file names as arguments, it prints the contents of each of
the files in sequence to its output stream.

`wc` is a command that allows you to count the lines, words, and characters in a file. For example

```console
apaa2017@APAA2017-MAC21 ~ %  wc hello.txt
       2       4       21 hello.txt
``````

Which shows that there are 2 lines, 4 words, and 21 characters (it counts the new line character at the end of each line).

If you want to count only the lines, you would use `wc -l`

```console
apaa2017@APAA2017-MAC21 ~ %  wc -l hello.txt
       2  hello.txt
``````

If you want to isolate the number 2, you can use input redirection:

```console
apaa2017@APAA2017-MAC21 ~ %  wc -l < hello.txt
       2
``````

Note that there is a difference in the output produced by the two forms of the
`wc` command. In the first case, the name of the file `hello.txt` is listed with
the line count; in the second case, it is not. In the first case, `wc` knows
that it is reading its input from the *file* `hello.txt`. In the second case, it
only knows that it is reading its input from standard input so it does not
display a file name.

Where this kind of input/output redirection really shines is in the use of
*pipes*. The `|` operator lets you "chain" programs such that the output of one
is the input of another:

```console
apaa2017@APAA2017-MAC21 ~ %  ls -l / | tail -n1
lrwxr-xr-x@  1 root  wheel    11 Feb  9 01:39 var -> private/var
```

What we just did was list (command `ls`) all the files contained in the root
directory (`/`) in the long format (using the flag `-l`). We then piped (`|`)
the output of `ls -l /` into the `tail` command. The `tail` command displays the
last part of a file. The flag `-n1` specifies that we are requesting only the
last 1 line (similarly, `-n2` would be the last two lines).

**(End of live demo part 1)**

## Start Here: Shell Scripting

So far we have seen how to execute commands in the shell, redirect input and output (`>`, `>>`, and `<`) and pipe them together (`|`). However, in many scenarios you will want to perform a series of commands and make use of control-flow expressions like conditionals or loops. Shell scripts are the answer to this next step in complexity. Essentially, we will be creating a special file that will contain our commands and any complex logic that dictate how our program works.

### How to Create and Execute Bash Scripts

By naming convention, bash scripts are stored in files which end with the extension `.sh`. However, bash scripts can run perfectly fine without the `.sh` extension. The way that the interpreter knows that they are bash scripts is the [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) line at the top of the script.

Shebang is a combination of bash (`#`) and bang (`!`) followed by the bash shell path. This is the first line of the script. Shebang tells the shell to execute it via `bash` shell. Shebang is simply an absolute path to the `bash` interpreter.

You can find your bash shell path (which may vary from the one below) using the command:

```console
apaa2017@APAA2017-MAC21 % which bash
/bin/bash
```

Below is an example of the shebang statement that would go to the top of our script given this absolute path:

```bash
#!/bin/bash
```

Formatting is important here. The shebang must be on the very first line of the file (line 2 won't do, even if the first line is blank). There must also be no spaces before the `#` or between the `!` and the path to the interpreter.

Most people like advanced editors like `vim` or `emacs` (which I encourage you to try) but because there is a steep learning curve we will use `nano` which is much more familiar to beginners.

Try the following:

```console
apaa2017@APAA2017-MAC21 % nano simple_hello.sh
```

This should pop up the `nano` text editor and you can write in it the contents of the `simple_hello.sh` script file.

Proceed with copy/pasting the following text

```bash
#!/bin/bash
echo "Hello World"
# Comments start with the pound sign and they are ignored
```

Press the `Control` key (`^`) + the key `X`, and when prompted to confirm, press the key `Y` and Enter/return.

Run the script by typing

```console
apaa2017@APAA2017-MAC21 % bash simple_hello.sh
```

Now that our demo has ended, please read/skim the following sections which will help you complete your three exercises.

### Globbing and ranges

Part of `bash`'s power comes from its ability to carry out file name expansion in a process known as *globbing*. Globbing is a process whereby certain special "wildcard" symbols are expanded into a matching set of filenames.

- Wildcards - Whenever you want to perform some sort of wildcard matching, you can use `?` and `*` to match one or any amount of characters respectively. For instance, given files `foo`, `foo1`, `foo2`, `foo10` and `bar`, the command `rm foo?` will delete `foo1` and `foo2` whereas `rm foo*` will delete all but `bar`.

- Curly braces `{}` - Whenever you have a common substring in a series of commands, you can use curly braces for `bash` to expand this automatically into a "range". This comes in very handy when moving or converting files.

```bash
convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files

mkdir foo bar
touch foo/x bar/y
# This creates files foo/x, foo/y, bar/x, bar/y

touch {foo,bar}/{a..h}
# This creates files foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
```

### Working with variables

To assign variables in `bash`, use the syntax `foo=bar`, where `foo` is the identifier of the variable and `bar` the contents associated with it. Note that `foo = bar` will not work since it is interpreted as calling the `foo` program with arguments `=` and `bar`! In general, in shell scripts, the space character will perform argument splitting. This behavior can be confusing to use at first, so always check for that. Indenting of code is another area of formatting that is important. We will come back to that later on.

We access the value of the variable with `$foo`. See the example below carefully:

```bash
apples=4
echo apples
#prints apples
echo $apples
#prints 4
oranges=apples
echo $oranges
#prints apples
oranges=$apples
echo $oranges
#prints 4
```

Strings in `bash` can be defined with the `'` and `"` delimiters, but they are not equivalent. Strings delimited with `'` are literal strings and will not substitute variable values, whereas `"` delimited strings will. Type the following on your terminal:

```bash
apples=4
echo "I have $apples apples"
# prints I have 4 apples
echo 'I have $apples apples'
# prints I have $apples apples
```

Using an exclamation point (`!`) within a string can be tricky, because it's actually a bash special character. You can get around this either by using single quotes (`'!'`) or by escaping the exclamation point (`\!`).

Command substitution allows us to take the output of a command or program (what would normally be printed to the screen) and save it as the value of a variable. To do this we place it within parentheses, preceded by a $ sign.

```console
apaa2017@APAA2017-MAC21 ~ % ls
cs62-lab01...
apaa2017@APAA2017-MAC21 ~ % myvar=$(ls)
apaa2017@APAA2017-MAC21 ~ % echo $myvar
cs62-lab01...
```

Note that if you want to perform an arithmetic expression and then assign the result to a variable, you would need to use `$((...))`. For example:

```bash
apples=4
oranges=$apples
fruit=$(($apples+$oranges))
echo "I have $fruit fruit"
# prints I have 8 fruit
```

This isn't really arithmetic but it can be quite useful. If you want to find out the length of a variable (how many characters) you can do `${#variable}`

```bash
a='Hello World'
echo ${#a}
#prints 11
b=4953
echo ${#b}
#prints 4
```

### Reading User Input

If we would like to ask the user for input, then we use a command called `read`. This command takes the input and saves it into a variable: `read variable`. You can also read multiple variables, i.e. `read variable1 variable2`, etc.

```bash
#!/bin/bash
# Ask the user for their name
echo Hello, who am I talking to?
read varname
echo It\'s nice to meet you $varname
```

You are able to alter the behavior of `read` with a variety of command line options. (See the `man` page for `read` to see all of them.) Two commonly used options are `-p` which allows you to specify a prompt and `-s` which makes the input silent. This can make it easy to ask for a username and password combination like the example below:

```bash
#!/bin/bash
# Ask the user for login details
read -p 'Username: ' uservar
read -sp 'Password: ' passvar
echo
echo Thank you $uservar, we now have your login details.
```

Above, we include the prompt within quotes so we can have a space included with it. Otherwise the user input will start straight after the last character of the prompt which isn't ideal from a readability point of view.

If I had saved the above script in `login.sh`, here's an example of how it would work.

```console
apaa2017@APAA2017-MAC21 ~ % bash login.sh
Username: cecil
Password:
Thank you cecil, we now have your login details.
```

### Special variables

Unlike other scripting languages, `bash` uses a variety of special variables to refer to arguments, error codes, and other relevant variables. Below is a list of some of them. [A comprehensive list of special characters can be found here](https://tldp.org/LDP/abs/html/special-chars.html).

- `$0` - Name of the script
- `$1` to `$9` - Arguments to the script. `$1` is the first argument and so on.
- `$@` - All the arguments passed to the script
- `$#` - Number of arguments passed to script
- `$?` - Return exit code of the previous command
- `$$` - Process identification number (PID) for the current script (more in the next lab)
- `!!` - Entire last command, including arguments. A common pattern is to execute a command only for it to fail due to missing permissions; you can quickly re-execute the command with sudo by doing `sudo !!`
- `$_` - Last argument from the last command. If you are in an interactive shell, you can also quickly get this value by typing `Esc` followed by `.` or `Alt+.`
- `$USER` - The username of the user running the script.
- `$HOSTNAME` - The hostname of the machine the script is running on.
- `$SECONDS` - The number of seconds since the script was started.
- `$RANDOM` - Returns a different random number each time is it referred to.
- `$LINENO` - Returns the current line number in the Bash script.

Commands will often return output using `stdout`, errors through `stderr`, and a return code to report errors in a more script-friendly manner. The return code or exit status is the way scripts/commands have to communicate how execution went. A value of 0 usually means everything went OK; anything different from 0 means an error occurred.

### Control flow

As with most programming languages,  `bash` supports control flow techniques including `if`, `while`, and `for`.

#### if statements

The syntax for `if` is:

```bash
if [ <some test> ]
then
  <commands>
elif [ <some test> ]
then
  <different commands>
else
  <other commands>
fi
```

The square brackets ( `[` and `]` ) in the if statement above are actually a reference to the command `test`. This means that all of the operators that `test` allows may be used here as well. Look up the `man` page for `test` to see all of the possible operators (there are quite a few) but some of the more common ones are listed below.

##### Common operators

| Operator                | Description                                                            |
| ----------------------- | ---------------------------------------------------------------------- |
| `!` EXPRESSION          | The EXPRESSION is false.                                               |
| `-n` STRING             | The length of STRING is greater than zero.                             |
| `-z` STRING             | The length of STRING is zero (i.e., it is empty).                      |
| STRING1 `=` STRING2     | STRING1 is equal to STRING2                                            |
| STRING1 `!=` STRING2    | STRING1 is not equal to STRING2                                        |
| INTEGER1 `-eq` INTEGER2 | INTEGER1 is numerically equal to INTEGER2                              |
| INTEGER1 `-gt` INTEGER2 | INTEGER1 is numerically greater than INTEGER2                          |
| INTEGER1 `-lt` INTEGER2 | INTEGER1 is numerically less than INTEGER2                             |
| `-d` FILE               | FILE exists and is a directory.                                        |
| `-e` FILE               | FILE exists.                                                           |
| `-r` FILE               | FILE exists and the read permission is granted.                        |
| `-s` FILE               | FILE exists and its size is greater than zero (i.e., it is not empty). |
| `-w` FILE               | FILE exists and the write permission is granted.                       |
| `-x` FILE               | FILE exists and the execute permission is granted.                     |

`=` is slightly different to `-eq`. For example, `[ 001 = 1 ]` will return false as `=` does a string comparison (i.e., checks character for character if they are the same), whereas `-eq` does a numerical comparison meaning `[ 001 -eq 1 ]` will return true. When we refer to `FILE` above we are actually meaning a path. Remember that a path may be absolute or relative and may refer to a file or a directory. Because `[ ]` is just a reference to the command `test`, we may experiment and trouble shoot with `test` on the command line to make sure our understanding of its behavior is correct, e.g.,

```console
apaa2017@APAA2017-MAC21 ~ % test 001 = 1
apaa2017@APAA2017-MAC21 ~ % echo $?
1
apaa2017@APAA2017-MAC21 ~ % test 001 -eq 1
apaa2017@APAA2017-MAC21 ~ % echo $?
0
apaa2017@APAA2017-MAC21 ~ % touch myfile
apaa2017@APAA2017-MAC21 ~ % test -s myfile
apaa2017@APAA2017-MAC21 ~ % echo $?
1
apaa2017@APAA2017-MAC21 ~ % ls /etc > myfile
apaa2017@APAA2017-MAC21 ~ % test -s myfile
apaa2017@APAA2017-MAC21 ~ % echo $?
0
```

Hint: The variable `$?` holds the exit status of the previously run command (in this case `test`). 0 means TRUE (or success). 1 = FALSE (or failure).

Let's create a file called `if_statements.sh` using `nano` that contains the following script. The flag `-n` says to not print the trailing newline character. Remember, `read <variable>` is a command that reads our input and stores it in `variable`.

```bash
#!/bin/bash

echo -n "Enter a number: "
read count
# we could have accomplished the same thing with read -p "Enter a number: " count
if [ $count -eq 100 ]
then
  echo "Count is 100"
elif [ $count -gt 100 ]
then
  echo "Count is greater than 100"
else
  echo "Count is less than 100"
fi
```

Save the file and run it (run directly `bash if_statements.sh` if you don't want to use `chmod` and then `./if_statements.sh`).

Sometimes we only want to do something if multiple conditions are met. Other times we would like to perform the action if one of several condition is met. We can accommodate these with boolean operators:

- **and** - `&&`
- **or** - `||`

For instance maybe we only want to perform an operation if the file is readable and has a size greater than zero:

```bash
#!/bin/bash
# "and" example
if [ -r $1 ] && [ -s $1 ]
then
  echo This file is useful.
fi
```

Maybe we would like to perform something slightly different if the user is either alexandra or dave:

```bash
#!/bin/bash
# "or" example
if [ $USER == 'alexandra' ] || [ $USER == 'dave' ]
then
  ls -alh
else
  ls
fi
```

#### while statements

The syntax for `while` is:

```bash
while [ <some test> ]
do
  <commands>
done
```

Save the following example in a file called `while_statement.sh` and execute it:

```bash
#!/bin/bash

x=1
while [ $x -le 5 ]
do
  echo "Welcome $x times"
  x=$(($x + 1))
done
```

#### for loops

The syntax for `for` is:

```bash
for var in <list>
do
  <commands>
done
```

Save the following example in a file called `for_statement.sh` and execute it:

```bash
#!/bin/bash

elements="Hydrogen Helium Lithium Beryllium"

for element in $elements
do
  echo "Element: $element"
done
```

You can use the sequence expression to specify a range of numbers or characters by defining a start and the end point of the range. The sequence expression takes the following form `{start..end}`.

Save the following example in a file called `for_range_statement.sh` and execute it:

```bash
#!/bin/bash

for value in {10..0}
do
  echo $value
done
```

There is also another form of for loop that looks closer to what we are used to with languages like Java:

```bash
for (( initialization; test; step ))
do
  commands
done
```

Save the following example in a file called `for_java_style_statement.sh` and execute it:

```bash
#!/bin/bash

for ((i=1; i<=5; i++))
do
  echo "Welcome $i times"
done
```

You can also use `break` and `continue` statements.

### Functions

`bash` also has functions that take arguments and can operate with them.

The syntax is

```bash
function_name () {
  commands
}
```

There is also a more explicit version:

```bash
function function_name {
  commands
}
```

Here is a simple function example. Remember, `$1` is the first argument to the script/function.

```bash
#!/bin/bash
greetings () {
  echo "Hello, $1"
}
```

```console
greetings "Cecil Sagehen"
# will print Hello, Cecil Sagehen
```

In other programming languages it is common to have arguments passed to the function listed inside the brackets `()`. In `bash`, parentheses are there only for decoration and you never put anything inside them. The function definition (the actual function itself) must appear in the script before any calls to the function.

Here is another example of a function named `mcd` that creates a directory and `cd`s into it. (Remember `man` is your friend if you are not familiar with a certain command or its arguments.)

```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

Try calling

```console
mcd test_dir
pwd
cd ..
ls -l
rm -r test_dir
ls -l
```

Most other programming languages have the concept of a return value for functions, a means for the function to send data back to the original calling location. Bash functions don't allow us to do this. They do however allow us to set a return status. Similar to how a program or command exits with an exit status which indicates whether it succeeded or not. We use the keyword `return` to indicate a return status. Typically a return status of 0 indicates that everything went successfully. A non zero value indicates an error occurred.

## Shell Tools

### Finding how to use commands

At this point, you might be wondering how to find the flags for the commands  such as `ls -l`, `mv -i` and `mkdir -p`. More generally, given a command, how do you go about finding out what it does and its different options? You could always start googling, but since Unix predates StackOverflow, there are built-in ways of getting this information.

You can use the `man` command. Short for manual, [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html) provides a manual page (called manpage) for a command you specify. For example, `man rm` will output the behavior of the `rm` command along with the flags that it takes. Even non-native commands that you install will have manpage entries if the developer wrote them and included them as part of the installation process.

Sometimes man-pages can provide overly detailed descriptions of the commands, making it hard to decipher what flags/syntax to use for common use cases. [TLDR pages](https://tldr.sh/) are a nifty complementary solution that focuses on giving example use cases of a command so you can quickly figure out which options to use. For instance, I find myself referring back to the tldr pages for [`tar`](https://tldr.inbrowser.app/pages/common/tar) and [`ffmpeg`](https://tldr.inbrowser.app/pages/common/ffmpeg) way more often than the man-pages.

### Finding files

One of the most common repetitive tasks that every programmer faces is finding files or directories. All Unix-like systems come packaged with [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html), a great shell tool to find files. `find` will recursively search for files matching some criteria. Some examples:

```bash
# Find all (sub)directories named src in the current directory
find . -name src -type d
# Find all java files that have a folder named src in their path in the current directory
find . -path '*/src/*.java' -type f
# Find all files modified in the last day in the current directory
find . -mtime -1
# Find all zip files with size in range 500k to 10M  in the current directory
find . -size +500k -size -10M -name '*.zip'
```

Beyond listing files, `find` can also perform actions over files that match your query.
This property can be incredibly helpful to simplify what could be fairly monotonous tasks.

```bash
# Delete all files with .tmp extension
find . -name '*.tmp' -exec rm {} \;
# Find all PNG files and convert them to JPG
find . -name '*.png' -exec convert {} {}.jpg \;
```

### Finding code

Finding files by name is useful, but quite often you want to search based on file *content*. A common scenario is wanting to search for all files that contain some pattern, along with where in those files said pattern occurs. To achieve this, most Unix-like systems provide [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html), a generic tool for matching patterns from the input text which we saw during the last lab. `grep` is an incredibly valuable shell tool that we will cover in greater detail during the data wrangling lab.

For now, know that `grep` has many flags that make it a very versatile tool. Some I frequently use are `-v` for in**v**erting the match, i.e. print all lines that do **not** match the pattern, `-l` for showing the file name, not the result itself, `-i` for ignoring case (makes the search slower). When it comes to quickly searching through many files, you want to use `-r` since it will **r**ecursively go into directories and look for files for the matching string.

```bash
grep -rl 'import java.util' .
# search recursively all subdirectories of current directory for files that contain the string "import java.util"
grep -rvl 'import java.util' .
# search recursively all subdirectories of current directory for files that DO NOT contain the string "import java.util"
```

### Finding shell commands

So far we have seen how to find files and code, but as you start spending more time in the shell, you may want to find specific commands you typed at some point. The first thing to know is that typing the up arrow will give you back your last command, and if you keep pressing it you will slowly go through your shell history.

The `history` command will let you access your shell history programmatically. It will print your shell history to the standard output. If we want to search there we can pipe that output to `grep` and search for patterns. `history | grep find` will print commands that contain the substring `find`.

In most shells, you can make use of `Ctrl+r` to perform backwards search through your history. After pressing `Ctrl+r`, you can type a substring you want to match for commands in your history. As you keep pressing it, you will cycle through the matches in your history.

## Exercises

Here are a few exercises to practice (and learn some more) skills for shell scripting. You are encouraged to work in groups. You are encouraged to search around for help (e.g., extracting the day of the week from the `date` command). You are allowed to use LLMs if desired for simple unit tasks like that, but you cannot generate your full script from an LLM. You must be able to explain your code to your TAs at check off.

1. `greeting.sh`: Write a bash script that asks the user for their name, takes in input from the command line, welcomes them, and prints the day of the week.

  ```console
  bash greeting.sh
  What is your name?
  Jingyi
  Hello, Jingyi! Today is Wednesday.
  ```

1. `counter.sh`: Write a bash script that counts the number of files in the current directory given a file extension. We encourage you write this in the `/counter` directory, which has 4 `.txt` files and 2 `.png` files to test. (Hint: You will likely need a loop and an if statement.)

  ```console
  # Make sure you `cd` into the correct directory for this to happen!
  bash counter.sh
  Enter a file extension (e.g., txt, sh, java):
  txt
  There are 2 .txt files in the current directory.
  ```

1. `temperature.sh`: Write a bash script that takes in a number and C/F and returns that number in the other unit. E.g, inputting 0C will return 32F. For your convenience, the formula from C to F is `(C × 9/5) + 32 = F` and F to C is `(F − 32) × 5/9 = C`. The converted temperature should print with 2 decimal points. (Hint: the `bc` command may be helpful here, as will writing separate functions for each conversion.)

  ```console
  bash temperature.sh
  Enter a temperature (e.g., 100F or 37C):
  47F
  47F = 8.33C
  ```

Once you have these working scripts, submit them on Gradescope and ask a TA to get checked off. Feel free to ask for help! Also do the [mid-semester feedback form](https://docs.google.com/forms/d/e/1FAIpQLScI3OHQcESjlb_m7euIyjCgcP59J0HmpS10VBUuF8SLijxiwQ/viewform).

### Grading

You will be graded based on the following criteria:

| Criterion                                                      | Points |
| :------------------------------------------------------------- | :----- |
| Autograder                                                     | 3      |
| This week's [exit ticket](https://forms.gle/GNoBRZCjwH7SuoMT6) | 1      |
| **Total**                                                      | **4**  |

### Optional exercises

Here are some additional exercises from when this lab was two 3-hour long sessions! Feel free to do them to master your shell scripting!

1. A good place to start is to create a simple script which will accept some command line arguments and echo out some details about them (e.g., how many are there, what is the second one etc.).
2. Now let's create a script which will take a filename as its first argument and create a dated copy of the file. e.g., if our file was named file1.txt it would create a copy such as 2025-04-16_file1.txt. (To achieve this you will probably want to play with command substitution and the command `date`. Look into `strftime` for formatting specifications)
3. Create a `bash` script which will accept a file as a command line argument and analyze it in certain ways. e.g., you could check if the file is executable or writable. You should print a certain message if true and another if false.
4. Write a `bash` script which will take a single command line argument (a directory) and will print each entry in that directory. If the entry is a file it will print its size. If the entry is a directory it will print how many items are in that directory. Hint: Look into the command `du`.
5. Create a `bash` script that takes as an argument a directory and then finds all files older than four weeks and writes their filenames into a text file whose filename is given a second argument.

## Extra - Permissions & chmod

Right now, your files should have the following permissions `-rw-r--r` (you have read/write access, group and others have only read access). If you are on a lab computer, in order to execute the script, we will need to change these permissions so that everyone can execute it.

Permissions come in 3 groups of 3: user (`u`), group (`g`), and others (`o`); these are for read (`r`), write (`w`), and execute (`x`). This information could be represented using 9 bits. Unix-like systems use a numbering system called octal where numerals range from 0 to 7 and take up 3 bits per numeral, thus allowing us to write a permission using 3 octal numerals. That is:

| Octal | Binary |
| ----- | ------ |
| 7     | `111`  |
| 6     | `110`  |
| 5     | `101`  |
| 4     | `100`  |
| 3     | `011`  |
| 2     | `010`  |
| 1     | `001`  |
| 0     | `000`  |

With our new numbering scheme, we can reinterpret our sequences of permissions as:

| Permissions | Octal-triplet |
| ----------- | ------------- |
| `rwxrwxrwx` | 777           |
| `rwxr-xr-x` | 755           |
| `rw-r--r--` | 644           |
| `rw-------` | 600           |

For example, `rwx` (all permissions) for the user would be `rwx------` or 700;  `rwx` for the user and the group would be `rwxrwx---` or 770;  `rwx` (all permissions) for everyone would be `rwxrwxrwx` or 777.

To change permissions, we would use the `chmod` command. You have a number of options to invoke `chmod`, as shown in the following examples:

```bash
# Set all 9 bits
chmod 777 simple_hello.sh
# Give yourself full permissions, and read/execute permissions to everyone else:
chmod 755 simple_hello.sh
# Set all three execute bits, keep everything else:
chmod +x simple_hello.sh
# Reset all three execute bits, keep everything else:
chmod -x simple_hello.sh
# Add write permissions for the group, keep everything else as is:
chmod g+w simple_hello.sh
```

We will use one of the first two options. For example:

```bash
chmod 755 simple_hello.sh
```

Once you have execute (`x`) privileges, you can run a script using any of these methods:

```bash
sh simple_hello.sh
bash simple_hello.sh
./simple_hello.sh
```

(Technically, you can use the first two even without execute privileges).

## Acknowledgments

This lab has been adapted from the missing semester course offered at MIT. Certain material has been adapted from Wikipedia and other online resources, such as [Bash Scripting Tutorial](https://ryanstutorials.net/bash-scripting-tutorial).
