#!/usr/bin/perl -w

sub usage() {
  print "usage: $0 maj|min|sp|build\r\n";
  exit 64;  
}
	
if ($#ARGV != 0)  {
  usage();
}
open VF, "version.h";
$_ = <VF>;
close VF;

/#define\s+[A-Z]+\s+(\d+),(\d+),(\d+),(\d+)/;
my $maj   = $1;
my $min   = $2;
my $sp    = $3;
my $build = $4;

if ($ARGV[0] eq "maj") { $maj++; }
elsif ($ARGV[0] eq "min") { $min++; }
elsif ($ARGV[0] eq "sp") { $sp++; }
elsif ($ARGV[0] eq "build") { $build++; }
else { usage(); }

open VF, ">version.h";
print VF <<"EOF";
#define EXVERSION        $maj,$min,$sp,$build
#define EXVERSIONSTR     "$maj,$min,$sp,$build\\0"
EOF
close VF;

print "$maj.$min.$sp.$build\n";

