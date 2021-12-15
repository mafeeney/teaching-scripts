#!
#takes as imput  .txt files with the DNA sequence in one line (saved as .fasta files but with the FASTA header deleted)
#returns file with potential primer sequences for mcqs about primer design

#first loop through all the files in the current working directory and get the first 20 nt (p1) and last 20 nt (p2) for each sequence
#write these to new text files named $FILEp1 and $FILEp2
for FILE in *.fasta;
do
#p1 is the first 20 nt of the sequence in the file
p1="$(head -c 20 $FILE)"
echo "$p1" >> "$FILE"p1.txt 
#p2 is the  last 20 nt of sequence
p2="$(tail -c 20 $FILE)" 
echo "$p2" >> "$FILE"p2.txt 

#now reverse these p1 and p2 sequences, write to new files
#1p is p1 reversed 
echo "$p1" | rev >> "$FILE"1p.txt
#2p is p2 reversed 
echo "$p2" | rev  >> "$FILE"2p.txt


#now find the complement of p1, p2, 1p, and 2p each using tr (ATCG --> TAGC)
#p1c is the complement of p1
cat "$FILE"p1.txt | tr 'ATCG' 'TAGC' >> "$FILE"p1c.txt

#p2c is the complement of p2
cat "$FILE"p2.txt | tr 'ATCG' 'TAGC' >> "$FILE"p2c.txt

#1pc is the complement of 1p
cat "$FILE"1p.txt | tr 'ATCG' 'TAGC' >> "$FILE"1pc.txt

#2pc is the complement of 2p
cat "$FILE"2p.txt | tr 'ATCG' 'TAGC' >> "$FILE"2pc.txt

echo "$FILE" finished, all potential primer sequences generated


#generate a txt file with selected primer combinations for MCQs on five separate lines - redirect to a new file called FILEmcqchoices.txt

echo a. "$(cat "$FILE"p1.txt)" + "$(cat "$FILE"p2.txt)" >> "$FILE"mcqchoices.txt 
echo b. "$(cat "$FILE"p1.txt)" + "$(cat "$FILE"2p.txt)" >> "$FILE"mcqchoices.txt 
echo c. "$(cat "$FILE"p1c.txt)" + "$(cat "$FILE"p2.txt)" >> "$FILE"mcqchoices.txt
echo d. "$(cat "$FILE"p1.txt)" + "$(cat "$FILE"2pc.txt)" >> "$FILE"mcqchoices.txt
echo e. "$(cat "$FILE"1pc.txt)" + "$(cat "$FILE"p2c.txt)" >> "$FILE"mcqchoices.txt

echo "$FILE" mcq choices generated

#also generate a summary file containing all 8 possible primer sequences
#first label the sequences for clarity, using echo to add the primer name to the file

echo "p1" >>  "$FILE"p1.txt

echo "p2" >>  "$FILE"p2.txt

echo "1p" >> "$FILE"1p.txt

echo "2p" >>  "$FILE"2p.txt

echo "p1c" >>  "$FILE"p1c.txt

echo "p2c" >>  "$FILE"p2c.txt

echo "1pc" >>  "$FILE"1pc.txt

echo "2pc" >> "$FILE"2pc.txt

#generate a txt file named $FILEprimers that has all eight labelled sequences
cat "$FILE"p1.txt "$FILE"p2.txt "$FILE"1p.txt "$FILE"2p.txt "$FILE"p1c.txt "$FILE"p2c.txt "$FILE"1pc.txt "$FILE"2pc.txt  >> "$FILE"primers.txt
echo "$FILE" primer file written

done
