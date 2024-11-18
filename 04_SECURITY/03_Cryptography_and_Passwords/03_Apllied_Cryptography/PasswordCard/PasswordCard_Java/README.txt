This is the README file for the PasswordCard source code and executable
distribution.


COPYRIGHT

This file is part of PasswordCard.

PasswordCard is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PasswordCard is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PasswordCard.  If not, see <http://www.gnu.org/licenses/>.

Copyright 2010, 2011 pepsoft.org.


SOURCE CODE

This file contains the algorithm used on the web site
http://www.passwordcard.org/ to generate PasswordCards, in the form of Java
source code (in the src directory), and a compiled Java jar file
(PasswordCard.jar). It is intended to ensure that if the web site were ever to
disappear, it will still be possible to regenerate existing PasswordCards or
generate new ones by reimplementing the algorithm or using the provided code.

This code is released as open source under the GPL version 3 license, a copy of
which you can find in the COPYING file. This means that if you use it in your
own project and you distribute that project, your project must be open source
using the GPL license as well!


RUNNING THE CODE

You will need to have Java installed in order to run this code, which you can
get here: http://www.java.com/.

Note that this code is not intended as a tool for daily usage or a replacement
for the web site. It is only intended as a demonstration of how to use the code
and as a backup of last resort. If the web site ever does disappear, the hope is
that this code will be used to create a new tool or web site to replace it.
Because of this the tool is extremely rudimentary.

To run it, change the current directory to the directory containing
PasswordCard.jar and execute the following command:

java -jar PasswordCard.jar <card number> [ --digitArea ] [ -- includeSymbols ]

Where <card number> is the hexadecimal card number printed on the card, and
--digitArea and --includeSymbols are optional parameters respectively to include
an area containing only digits on the card and to include symbols on the card
in addition to letters and digits.

The contents of the card will be written to standard out. If you want to capture
them in a file you can use the redirection operator by appending something like
this to the command line given above:

> passwordcard.txt


CHARACTER ENCODING

The source code files, including this README file, are encoded with UTF-8. Take
this into account when opening them, or when trying to compile them! The javac
command has an -encoding parameter with which you can indicate the encoding of
the source file.

Similarly, the demonstration code described above also uses the UTF-8 encoding
for its output. If your terminal or console settings are not configured for
UTF-8, the output may appear distorted. It is best to capture the output to a
file, as described above.


FONT

To print a card correctly you would need a non-proportional font containing at
least all the symbols used by PasswordCard. The font used by the web site is
the FreeMono font from the GNU FreeFont project, which can be downloaded here:
http://ftp.gnu.org/gnu/freefont/


COLOURS

The web site colours the lines of the password card as follows:

header: white
line 1: white
line 2: grey
line 3: red
line 4: green
line 5: yellow
line 6: blue
line 7: magenta
line 8: cyan


EXAMPLE

As an example, here are the contents of card "0". You can use this to check
whether your implementation of the algorithm is correct, or whether your Java
VM implements the API in the same way as the Sun VM:

□$☹☀☂?◩▲○◐¿△£■¡☁☺⊙¥♥★€�●♦!♣♫♠
STQ2eBewh5fEz2QEH3JRXwPS8AwFY
BsrSxpsm4LC5mHGSRjzwrzzSaXnzk
nCWFTV5ZqmBeQqR7tYSkAGNm7KT84
BFqQddghELZbk4cH5JzLpzBgt9A8s
X5AdQqdYNrsavscz7KCPphs2qWH4T
FSt6F4v4AH3bmP4759uCLYBhgZY29
yHYKhLYkyJkfgMUUhzmV4EeMuTtS2
dMVVfaYwQ3wcdZH94cpbjJYgYTKWL

And here is card "0" with symbols and numeric area enabled:

□$☹☀☂?◩▲○◐¿△£■¡☁☺⊙¥♥★€�●♦!♣♫♠
#T32<Bzw35%E%23Ec3aRHwCSDA5FT
9s3S6pTmhLg5#H/S+jxwxz>SfXYz>
yC7F$VmZmm)eyqr7WYbkQGPmzKH8w
5F&QJd[hNLjbm4DH5J}L/zKg)9U8<
78615163378868055589553016828
17991217181439203253132044852
98800632442892945030702203420
62553387062569327054648988566