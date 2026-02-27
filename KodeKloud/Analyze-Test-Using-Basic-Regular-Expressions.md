# Analyze Text Using Basic Regular Expressions

### regex means Regular Expression(s)

For more complex search instructions, we can specify some conditions, tie them all together, and our search pattern only matches what perfectly fits within those conditions

Regex Operators:
## ^
## $
## .
## *
## +
## {}
## ?
## |
## []
## ()
## [^]


## grep '^#' /etc/login.defs
looks for all lines that begin with a # pound sign
 
## grep -v '^#' /etc/
combine with grep's option to invert (-v) results ... it becomes more useful ... this shows lines that don't begin with a # sign
useful it a file with hundreds of comments 

## grep '^PASS' /etc/
this looks for a line that starts exactly with these 4 letters

## grep '7' /etc/login.defs
shows a bunch of 7's 

## grep -w '7$' /etc/login.defs
 this will search for the last character on the line
 -w match only what contatins a single 7 digit at the end of the line 

## grep 'mail$' /etc/ligin/.defs

** to easily remember the locations of the operators:
## if the line begins with operator the ^ should be placed at the beginning of your search pattern 
## if the line ends with operator the $ goes at the end of your search pattern

## anywhere you put a '.' in your expression it will match any character in that spot:

## grep -r 'c.t' /etc/
 there must be exactly one character in between c & t ... 'c..t' would match exactly 2 characters in between

## grep -wr 'c.t' /etc/
 matches whole words

## grep '\.' /etc/login.defs
 to excape a special character you add a '\' to the expression

## grep -r 'let*r' /etc
let* -> lettt
* the * allows the previous element to:
- be ommitted entirely
- appear only once
- or appear 2 or more times

## -r '/.*/' /etc
search for characters that begin with a / and have 0 or more characters between then end with another / 
the period matches any one character and it says the previous element can exist zero or 1,2, or many more times ... this lets any sequence of characters to exist between those two / /


any sequence of characters where zero appers one or more times ... we might be tempted to use something like this:

## grep -r '0*' /etc

but this also shows lines that contain no zeros at all because the * lets the previous character exist one or more times ... but also zero times!

so we need another operator that forces the element to exist one time or many more

# 0+ --> 000

## grep -r '0+' /etc

meta characters lose their special meaning ... so the + sign isn't an operator ... it's a literal plus sign

so we need to use the \ versions of them:

## grep -r '0\+' /etc


It's really hard to keep track of ... so use Extended Regex Operators intead

## grep -Er '0+' /etc/ 
or 
## egrep -r '0+' /etc/


to find all strings that contain at least 3 zeros ... use the {} operator ... the first value represents the minimum amount of repetitions for the previous element ... the second specifies the maximum amount of repetitions

## grep -r '0{3,}' /etc/

to find all strings that contain one ... followed by at most 3 zeros ... add the first one in the search pattern then follow that with a zero digit ... then add our regular expression ... this time in reverse ... we omit to specify a minimum in the first field but we specify our maximum number of repititions in the second field ... this will also match ones followed by no zeros ... since we didn't choose any specific minimum amount of repetitions:

##  egrep -r '10{,3}' /etc/


to find all strings that contain exactly 3 zeros ... we use the operator in a different way ... just place one value in between the curly brackets:

## egrep -r '0{3}' /etc

the question mark character will let the previous element exist precisely zero or 1 times

## egrep -r 'disabled?' /etc


 


  



ro6ert@ro6bx:~/Documents/LINUX/KodeKloud/Analyze-Text-Using-Basic-Regular-Expressions$ ls
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-10.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-11.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-12.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-13.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-1.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-2.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-3.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-4.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-5.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-6.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-7.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-8.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators-9.png
Analyze-Text-Using-Basic-Regular-Expressions_Regex-Operators.png

