## need: genome, annotation and subset only protein-coding genes on selected chromosomes (female)

## location
cd A_input/ref

## gather genome and annotation
# get genome
wget ftp://ftp.ensemblgenomes.org/pub/metazoa/release-39/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.dna_sm.toplevel.fa.gz
gzip -d Drosophila_melanogaster.BDGP6.dna_sm.toplevel.fa.gz
mv Drosophila_melanogaster.BDGP6.dna_sm.toplevel.fa ref.fa
# get annotation
wget ftp://ftp.ensemblgenomes.org/pub/metazoa/release-39/gtf/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.39.gtf.gz
gzip -d Drosophila_melanogaster.BDGP6.39.gtf.gz
mv Drosophila_melanogaster.BDGP6.39.gtf ref.gtf

## subset chr from genome
# genereate chr file
echo -e "2L\n2R\n3L\n3R\n4\nX" > sel.chr
# idx genome and extract selection
samtools faidx ref.fa
xargs samtools faidx ref.fa < sel.chr > refsel.fa

## subset transcripts from annotation
# by chromosome location
awk 'NR == FNR { line[$0]; next } $1 in line { print $0 }' sel.chr ref.gtf > refsel.gtf_tmp
# by protein-coding feature
cat refsel.gtf_tmp | grep 'gene_biotype "protein_coding"' > refsel.pc.gtf_tmp
# tmp manips: format and finalisation
cat ref.gtf | grep '^#' > ref.gtf.head_tmp; cat ref.gtf.head_tmp refsel.pc.gtf_tmp > refsel.gtf

## transcript file: fasta format
gffread refsel.gtf -g refsel.fa -w refsel.gtf.fa

## rm bullshit
rm *_tmp

## quick stats
cat refsel.gtf.fa | grep '^>' | wc -l
# 30440 transcripts
cat refsel.gtf.fa | grep '^>' | cut -f2 -d ' ' | sort | uniq | wc -l
# 13890 genes
