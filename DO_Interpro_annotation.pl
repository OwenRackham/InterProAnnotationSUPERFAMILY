
#!/usr/bin/perl -wT

use strict;
use warnings;

use CGI qw/:standard/;
use DBI;
use lib '/home/rackham/modules/';
use rackham;
use Digest::MD5 qw(md5);
use Data::Dumper;

my ( $dbh, $sth );
$dbh = rackham::DBConnect('superfamily');

my $seqid = $ARGV[0];
my $genome = $ARGV[1];
my $fo = $ARGV[2];
my $marginal = 1;
my $TEMPDIR = '/home/rackham/astral/assfiles';
my $file = "$seqid".".xml";
my $digest;
my $sth2=$dbh->prepare( "select sequence from genome_sequence,protein where protein.protein = genome_sequence.protein and protein.seqid = '$seqid' and protein.genome='$genome';" );
	$sth2->execute;
	while ( my @temp2 = $sth2->fetchrow_array ) {
		$digest = md5($temp2[0]);
	}

open ALI, '>', "$TEMPDIR/$fo/$file" or die "Cannot open $TEMPDIR/$genome/$file".": $!\n";
print ALI "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
          "<signature-library-release-matches xmlns=\"http://www.ebi.ac.uk/schema/interpro\"",
          "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"",
          "xsi:schemaLocation=\"http://www.ebi.ac.uk/schema/interpro/interpro-5.0.xsd\">\n",
          "<signature-library-release library=\"SCOP\" version=\"1.73\" />\n",
    	  "<protein>\n";
print ALI "<sequence md5=\"$digest\"></sequence>\n";
print ALI " <xref db=\"UniProt\" id=\"$seqid\" name=\"0\"/>\n";
print ALI "<matches>\n";   


my $s = $dbh->prepare("SELECT ass.evalue, ass.region, ass.model, ass.sf, t1.description, align.alignment, comb_index.comb, 
						family.evalue, family.px, family.fa, t2.description, genome_sequence.length,protein.protein,align.modstart
                      FROM align, ass, des AS t1, des AS t2, comb, family, protein, genome_sequence, comb_index
                      WHERE ass.auto = align.auto AND
                      protein.protein = genome_sequence.protein AND
                            comb.comb_id=comb_index.id AND
                            protein.protein = comb.protein AND
                            protein.protein = ass.protein AND
                            ass.auto = family.auto AND
                            protein.seqid = '$seqid' AND
                            ass.sf = t1.id AND
                            family.fa = t2.id AND
                            protein.genome = '$genome' AND
                            ass.evalue <= $marginal
                      ORDER BY ass.evalue;");
$s->execute;                 
my $domain_no = 1;
my %domain_details;
while ( my @temp = $s->fetchrow_array ) {
	$domain_details{$domain_no}{'evalue'} = $temp[0];
	my $region = $temp[1];
	$domain_details{$domain_no}{'region'} = $region;
	$domain_details{$domain_no}{'model'} = $temp[2];
	$domain_details{$domain_no}{'sf'} = $temp[3];
	$domain_details{$domain_no}{'description'} = $temp[4];
	$domain_details{$domain_no}{'alignment'} = $temp[5];
	$domain_details{$domain_no}{'comb_index'} = $temp[6];
	$domain_details{$domain_no}{'family_evalue'} = $temp[7];
	$domain_details{$domain_no}{'px'} = $temp[8];
	$domain_details{$domain_no}{'fa'} = $temp[9];
	$domain_details{$domain_no}{'description'} = $temp[10];
	$domain_details{$domain_no}{'length'} = $temp[11]; 
	$domain_details{$domain_no}{'protein'} = $temp[12]; 
	$domain_details{$domain_no}{'modstart'} = $temp[13];
	my $confidence = 100 - (100*$temp[0]);
	$domain_details{$domain_no}{'confidence'} = $confidence;
    my $sth2=$dbh->prepare( "select name from des where id =$temp[8];" );
	$sth2->execute;
	while ( my @temp2 = $sth2->fetchrow_array ) {
		$domain_details{$domain_no}{'closest_structure'} = $temp2[0];
	}
	
	
	$domain_no++;
}
foreach my $domain_no (keys %domain_details){
my $length = 0;
	$length++ while($domain_details{$domain_no}{'alignment'} =~ m/\p{Uppercase}/g);
	$length++ while($domain_details{$domain_no}{'alignment'} =~ m/-/g);
	my $modend = $domain_details{$domain_no}{'modstart'} + $length;
	my @aligned = split(/,/,$domain_details{$domain_no}{'region'});
	print ALI "<hmmer3-match evalue=\"$domain_details{$domain_no}{'evalue'}\" confidence=\"$domain_details{$domain_no}{'confidence'}\">\n",
              "<signature ac=\"$domain_details{$domain_no}{'sf'}\" name= \"$domain_details{$domain_no}{'description'}\" created=\"\" updated=\"\"/>\n",
        	  "<locations>\n";
	foreach my $align (@aligned){
		my @stst = split(/-/,$align);
		my $start = $stst[0];
		my $stop = $stst[1];
        print ALI "<hmmer3-location start=\"$start\" end=\"$stop\"\n",
                  "hmm-start=\"$domain_details{$domain_no}{'modstart'}\" hmm-end=\"$length\"\n",
                  "hmm-length=\"0\" score=\"0\" evalue=\"$domain_details{$domain_no}{'evalue'}\"/> \n";	
	}
	print ALI "</locations>\n",
              "</hmmer3-match>\n";

}   


print ALI "</matches>\n</protein>\n</signature-library-release-matches>\n";

close ALI;

 
