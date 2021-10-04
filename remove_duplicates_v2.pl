#!/usr/bin/perl

# This perl script is used to remove replicated reads. 
# If the 50 first bases of the forward read and the 50 first bases of the reverse read are identical between several pairs, it only keeps the first pair of reads.


# Input files : files containing the sequences of the forward and reverse reads before the dereplication
open (Ffastq_forward, "< $ARGV[0]");
open (Ffastq_reverse, "< $ARGV[1]");
# Output files : files containing the sequences of the forward and reverse reads after the dereplication
open outputF , ">$ARGV[2]";
open outputR , ">$ARGV[3]";


%sequenceF = ();
%strandF = ();
%qualityF = ();
%firstBasesF = ();
%sequenceR = ();
%strandR = ();
%qualityR = ();
%firstBasesR = ();
%concat = ();

$i = 1;

# Reads forward reads

while ($ligne1 = <Ffastq_forward>) {
	if ($i == 1) {
		if ($ligne1 =~ /^(\S+).*\n/) {
		$id = $1;
		$i++;
		}
	}
	elsif ($i == 2) {
		if ($ligne1 =~ /^(\S+)\n/) {
		$seq = $1;
		$i++;
		}
	}
	elsif ($i == 3) {
		if ($ligne1 =~ /^(\S+)\n/) {
		$str = $1;
		$i++;
		}
	}
	elsif ($i == 4) {
		if ($ligne1 =~ /^(\S+)\n/) {
			$qual = $1;
			$sequenceF{$id} = $seq;
			$strandF{$id} = $str;
			$qualityF{$id} = $qual;
			$firstBasesF{$id} = substr($seq, 0, 50);
			$i = 1;
		}
	}
}

# Reads reverse reads

while ($ligne1 = <Ffastq_reverse>) {
	if ($i == 1) {
		if ($ligne1 =~ /^(\S+).*\n/) {
		$id = $1;
		$i++;
		}
	}
	elsif ($i == 2) {
		if ($ligne1 =~ /^(\S+)\n/) {
		$seq = $1;
		$i++;
		}
	}
	elsif ($i == 3) {
		if ($ligne1 =~ /^(\S+)\n/) {
		$str = $1;
		$i++;
		}
	}
	elsif ($i == 4) {
		if ($ligne1 =~ /^(\S+)\n/) {
			$qual = $1;
			$sequenceR{$id} = $seq;
			$strandR{$id} = $str;
			$qualityR{$id} = $qual;
			$firstBasesR{$id} = substr($seq, 0, 50);
			$i = 1;
		}
	}
}

# Processing

foreach $e (keys %firstBasesF) {
	$concat{$firstBasesF{$e} . $firstBasesR{$e}} = $concat{$firstBasesF{$e} . $firstBasesR{$e}} . "_____" . $e;
}

# Prints outputs

foreach $e (keys %concat) {
	@tab = split ("_____", $concat{$e});
	print (outputF $tab[1] . "\n" . $sequenceF{$tab[1]} . "\n" . $strandF{$tab[1]} . "\n" . $qualityF{$tab[1]} . "\n");
	print (outputR $tab[1] . "\n" . $sequenceR{$tab[1]} . "\n" . $strandR{$tab[1]} . "\n" . $qualityR{$tab[1]} . "\n");
}

