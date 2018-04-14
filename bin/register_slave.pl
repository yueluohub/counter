#!/usr/bin/perl 
use Getopt::Long qw(:config pass_through);

my $fname = "";
my $tool_loc = "$ENV{TOOL_DIR}";

GetOptions(
  "infname|script|f=s" => \$fname,
  "tool_loc|tool|l=s" =>\$tool_loc,
);

unless ($fname) {
  if ($#ARGV >= 0) {
    $fname = $ARGV[0];
  } else {
    print "Usage: register_slave.pl -f regster_definition_file_name [-l tool_folder_location]\n";
    die;
  }
}

$cmd = "perl -I \"$tool_loc/perl_modules\" $tool_loc/register_slave/register_slave.pl $fname";
print "---\n$cmd\n---\n";

system($cmd);

system("mv -v *.htm $ENV{TCROOT}/doc");
# system("mv -v *.xml $ENV{TCROOT}/doc");
# system("mv -v *.svd $ENV{TCROOT}/doc");
system("mv -v *.tcl $ENV{TCROOT}/scripts");
