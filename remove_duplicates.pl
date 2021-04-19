#!/usr/bin/perl

open (Fastq_forward, "< $ARGV[0]") || die "Probleme d'ouverture : $!" ;
open (Fastq_reverse, "< $ARGV[1]") || die "Probleme d'ouverture : $!" ;
open OutputF , ">$ARGV[2]";
open OutputR , ">$ARGV[3]";


# Uses as input fastq
# Removes forward reads when their first hundred nucleotide are identical and retains the first longest of such reads.
# Removes reverse reads when their first hundred nucleotide are identical and retains the first longest of such reads.
# Keeps all reads that have both forward and reverse present.

%sequence_F = ();
%quality_F = ();
%length_F = ();
%duplicate_F = ();

%sequence_R = ();
%quality_R = ();
%length_R = ();
%duplicate_R = ();

%keep_F = ();
%keep_R = ();


$i = 1;


# Reads forward reads

print "Reading forward reads...\n";

while ($line = <Fastq_forward>) {
	if ($i == 1) {
		if ($line =~ /^(\S+).*\n/) {
			$id = $1;
			$i++;
		}
	}
	elsif ($i == 2) {
		if ($line =~ /(.+)\n/) {
			$seq = $1;
			$sequence_F{$id} = $seq;
			$length_F{$id} = length($seq);
			$duplicate_F{substr($seq, 0, 100)} = $duplicate_F{substr($seq, 0, 100)} . "_____" . $id;
			$i++;
		}
	}
	elsif ($i == 3) {
		if ($line =~ /(.+)\n/) {
			$i++;
		}
	}
	elsif ($i == 4) {
		if ($line =~ /(.+)\n/) {
			$qual = $1;
			$quality_F{$id} = $qual;
			$i = 1;
		}
	}
}

close Fastq_forward;


$i = 1;

# Reads reverse reads

print "Reading reverse reads...\n";

while ($line = <Fastq_reverse>) {
	if ($i == 1) {
		if ($line =~ /^(\S+).*\n/) {
			$id = $1;
			$i++;
		}
	}
	elsif ($i == 2) {
		if ($line =~ /(.+)\n/) {
			$seq = $1;
			$sequence_R{$id} = $seq;
			$length_R{$id} = length($seq);
			$duplicate_R{substr($seq, 0, 100)} = $duplicate_R{substr($seq, 0, 100)} . "_____" . $id;
			$i++;
		}
	}
	elsif ($i == 3) {
		if ($line =~ /(.+)\n/) {
			$i++;
		}
	}
	elsif ($i == 4) {
		if ($line =~ /(.+)\n/) {
			$qual = $1;
			$quality_R{$id} = $qual;
			$i = 1;
		}
	}
}

close Fastq_reverse;



# Processes forward reads

print "Processing forward reads...\n";

foreach $e (keys %duplicate_F) {
	@tab = split ("_____", $duplicate_F{$e});
	$final_choice = "";
	$final_length = 0;
	foreach $f (@tab) {
		if ($length_F{$f}>=$final_length) {
			$final_choice = $f;
			$final_length = $length_F{$f};
		}
	}
	$keep_F{$final_choice} =  $final_choice . "\n" . $sequence_F{$final_choice} . "\n\+\n" . $quality_F{$final_choice} . "\n";
}



# Processes reverse reads

print "Processing reverse reads...\n";

foreach $e (keys %duplicate_R) {
	@tab = split ("_____", $duplicate_R{$e});
	$final_choice = "";
	$final_length = 0;
	foreach $f (@tab) {
		if ($length_R{$f}>=$final_length) {
			$final_choice = $f;
			$final_length = $length_R{$f};
		}
	}
	$keep_R{$final_choice} =  $final_choice . "\n" . $sequence_R{$final_choice} . "\n\+\n" . $quality_R{$final_choice} . "\n";
}


# Prints outputs

print "Printing output files...\n";

foreach $e (keys %keep_F) {
	if ($keep_R{$e} ne "") {
		print (OutputF $keep_F{$e});
		print (OutputR $keep_R{$e});
	}
}




