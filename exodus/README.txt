Getting started with Exodus development

1. Install Delphi6.  Make sure to install the Indy components.
2. Set up CVS.
   a) Make sure you *don't* use cygwin CVS.  It will munge CR/LFs.
   b) set CVS_RSH=ssh
2. Check out exodus.
   cvs -z3 -d:ext:developername@jabberstudio.org:/home/cvs co exodus
4. Start delphi
5. Load the exodus components.
   a) Unzip .\components\tntUnicode.zip and install the _D60.dpk package.
   a) Open .\exodus\components\ExComponents.dpk
   b) Click "install"
6. Open Exodus.dpr
7. Compile
8. Disable annoying exceptions
   a) Tools/Debugger Options/Language Exceptions
   b) Add
   c) EConvertError
9. Run
