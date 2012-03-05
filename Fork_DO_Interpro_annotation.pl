#!/usr/bin/perl -w

use strict;
use warnings;
use Parallel::ForkManager;

my $filename = $ARGV[0];
my $genome = $ARGV[1];
my $LOGFILE = "/home/rackham/astral/logs/";
open FILE, "<$filename" or die $!;
my @seqs;
while (<FILE>){
	if ($_ =~ /^>(\S+)/){
		push @seqs,$1;
	}
}
print "read file\n";
my $manager = new Parallel::ForkManager( 20 );
my $t = scalar(@seqs);
my $o = 1;
foreach my $seq (@seqs){
	print "$o from $t\n";
	$o++;
		unless (-e "$LOGFILE"."up_$seq".".log") {
		$manager->start and next;
		my $command = "perl DO_Interpro_annotation.pl $seq up $genome > $LOGFILE"."r2up_$seq".".log";
      	system( $command );
      	$manager->finish;
		}
}
