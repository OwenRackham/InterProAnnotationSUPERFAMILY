#!/usr/bin/perl -w

use strict;
use warnings;

print "bakers:1/10 \n";
my $cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/bakersyeast.fa bakersyeast";
system($cmd);
print "fission:2/10 \n";
$cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/fissionyeast.fa fissionyeast";
system($cmd);
print "human:3/10 \n";
$cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/human.fa human";
system($cmd);
print "plas:4/10 \n";
my $cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/plasmodium.fa plasmodium";
system($cmd);
print "worm:5/10 \n";
$cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/worm.fa worm";
system($cmd);
print "arab:6/10 \n";
$cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/arabidopsis.fa arabidopsis";
system($cmd);
print "ecoli:7/10 \n";
$cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/ecoli.fa ecoli";
system($cmd);
print "fly:8/10 \n";
$cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/fly.fa fly";
system($cmd);
print "mouse:9/10 \n";
$cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/mouse.fa mouse";
system($cmd);
print "staph:10/10 \n";
$cmd = "perl Fork_DO_Interpro_annotation.pl /home/rackham/projects/data/genomes/staphylococcus.fa staphylococcus";
system($cmd);

