#!/bin/perl -w

use strict;
$::USER = 'hildjj@jabberstudio.org';

do "dopts.pl";

chdir "exodus" or die;

e("perl version.pl build");
e("perl build.pl");
e("cvs ci -m \"Daily build\" version.h version.nsi");
e("scp -C setup.exe plugins/*.zip  $::USER:/var/projects/exodus/www/daily/stage");
e("ssh $::USER \"cd /var/projects/exodus/www/daily/stage; chmod 644 *; mv setup.exe ..; mv *.zip ../../plugins\"");

print "\n\nSUCCESS!\n";

sub e {
  my $cmd = shift;
  print "$cmd\n";
  system $cmd and exit;
}
