Getting started with Exodus development

1. Install Delphi7.  Make sure to install the Indy components.
2. Set up CVS.
   a) Make sure you *don't* use cygwin CVS.  It will munge CR/LFs.
   b) set CVS_RSH=ssh
3. Checkout Exodus source code:
   a) If you have a CVS account on jabberstudio.org, use:
        cvs -z3 -d:ext:developername@jabberstudio.org:/home/cvs co exodus
   b) If you want to do anonymous CVS use:
        cvs -z3 -d:pserver:anoncvs@jabberstudio.org:/home/cvs login
      Hit the <ENTER> key when prompted for a password.
      Then do:
        cvs -z3 -d:pserver:anoncvs@jabberstudio.org:/home/cvs co exodus
4. Start Delphi 7.
5. Install the exodus components.
   a) Unzip .\components\tntUnicode.zip and install the _D70.dpk package.
   a) Open .\exodus\components\ExComponents.dpk
   b) Click "install"
6. Open Exodus.dpr
7. Compile
8. Disable annoying exceptions
   a) Tools/Debugger Options/Language Exceptions
   b) Add
   c) EConvertError
9. Run


