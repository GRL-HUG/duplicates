# duplicates

Uses forward and reverse reads fastq files as input

perl remove_duplicates.pl <Forward_reads_input_file> <Reverse_reads_input_file> <Forward_reads_output_file> <Reverse_reads_output_file>

Removes forward reads when their first hundred nucleotide are identical and retains the first longest of such reads.
Removes reverse reads when their first hundred nucleotide are identical and retains the first longest of such reads.
Keeps all reads that have both forward and reverse present.
