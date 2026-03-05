# Analyze Text Using Basic Regular Expressions

### regex means Regular Expression(s)

Used for advanced text searching. In earlier lessons, we relied on simple search patterns for precise text pieces (such as passwords). But as search conditions become more complex, regex helps to refine those queries. For instance, if you need to extract all IP addresses (e.g., 203.102.3.5) from hundreds of application files, a naive pattern that only looks for numbers separated by periods might accidentally capture values like 5.23 that don’t represent valid IP addresses.

Just like in mathematics where you can define conditions for an integer (for example, when x is greater than 3 and less than 8 so that x is 4, 5, 6, or 7), regex lets you specify and combine conditions to form patterns that match only the text meeting those criteria.

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

To match whole words rather than sub-strings within larger words, leverage grep’s -w option:

## grep -r 'c.t' /etc/
 there must be exactly one character in between c & t ... 'c..t' would match exactly 2 characters in between

For a recursive search with whole word matching, use:

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

Be aware that the asterisk can also make the preceding character optional. For instance, the pattern 0* will match lines regardless of whether the digit 0 is present:

## grep -r '0*' /etc

but this also shows lines that contain no zeros at all because the * lets the previous character exist one or more times ... but also zero times!

so we need another operator that forces the element to exist one time or many more

# 0+ --> 000

## grep -r '0+' /etc

meta characters lose their special meaning ... so the + sign isn't an operator ... it's a literal plus sign

so we need to use the \ versions of them:

To search for lines where the digit 0 appears one or more times, use the plus operator (+). Note that grep’s Basic Regular Expressions (BRE) require you to escape the plus sign:

## grep -r '0\+' /etc


It's really hard to keep track of ... so use Extended Regex Operators intead

Using Extended Regular Expressions with grep’s -E option eliminates the need for escaping the plus sign.
When working with grep, consider using the -E option for Extended Regular Expressions to simplify your patterns and avoid confusion with escaped characters.

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


if we want to find either enabled or disabled use the or operator:

## egrep -r 'enabled|disabled' /etc

### Ranges or Sets

## egrep -r 'c[au]t' /etc/

## egrep -r '/dev/[a-z]*' /etc/

## egrep -r '/dev/[a-z]*[0-9]' /etc

## egrep -r '/dev/[a-z]*[0-9]?' /etc/
the digit at the end is optional with the ? operator 

### Subexpresssions 

## egrep -r '/dev/([a-z]*[0-9]?)*' /etc/

## egrep -r '/dev/(([a-z]|[A-Z])*[0-9]?)*' /etc

## egrep -r 'https[^:]' /etc/

## egrep -r 'http[^s:]' /etc/

### [^]: Negated Ranges or Sets

## egrep -r '/[^a-z]' /etc/

Understanding how to strategically place operators like ^ and $ for anchoring searches, . for matching any character, and * or + for repetitions is key to building efficient regular expre

** regexr.com **


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

