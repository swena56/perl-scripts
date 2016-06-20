#!/usr/bin/perl -w
# parseCSV.pl by Andrew Swenson

use warnings;
use 5.18.0;
use Data::Dumper;

#practice csv data found at: https://support.spatialkey.com/spatialkey-sample-csv-data/
#http://spatialkeydocs.s3.amazonaws.com/FL_insurance_sample.csv.zip
#http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv
#http://samplecsvs.s3.amazonaws.com/SalesJan2009.csv
#http://samplecsvs.s3.amazonaws.com/TechCrunchcontinentalUSA.csv

say "Here is a demo on parsing some insurance data in CSV file";
my $filename = "FL_insurance_sample.csv";
say "File: ", $filename;

#put data in array
open FH, $filename || die("file does not exist- try downloading it");
 my @lines = <FH>;
close FH;

#lets make a hash array to put the csv data in
my @insuranceData;

say "number of lines: " , scalar @lines;  #In this situation there is only 1 line

say "Processing data ..... please wait";
foreach my $line ( @lines)
{
	#hmm how will I use regex to get each section of data
	#seems like the data is formated like such: 
	#663066,FL,PINELLAS COUNTY,0,163297.54,0,0,163297.54,165963.86,0,0,0,0,28.031706,-82.654648,Residential,Wood,1
	#id, state, city, int, float, int, int, float, float, int, int, int, int, float, float, house_type, int
	#everything is separated by commas, and the data does not seem to contain commas.
	#my @array = map { split /,/ } grep { !/^,/ && !/,$/ && /,/ } split
	#policyID,statecode,county,eq_site_limit,hu_site_limit,fl_site_limit,fr_site_limit,tiv_2011,tiv_2012,eq_site_deductible,hu_site_deductible,fl_site_deductible,fr_site_deductible,point_latitude,point_longitude,line,construction,point_granularity

	#chomp $line;
	
	#warn "Line could not be parsed $line";
	my @fields = split "," , $line;		

	say "Number of Fields: " , scalar (@fields);
	#there are 18 fields per line

	my $index = 0;
	for(my $i=0; $i<=18; $i++)
	{
			

	}
	foreach my $f (@fields)
	{
		#say $f;
	}
	#my %columnHash = ( 'statecode' =>  $fields[1]);
	
	#push (@insuranceData, @fields);
	

	
	#print $line;
}
say "Done";
Dumper(\@insuranceData);