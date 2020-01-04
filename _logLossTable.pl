#!/usr/bin/perl

use warnings;
use strict;


my $input;
open($input, "<", "./d/log.txt") or die "Fail to read log.txt";

my $output;
open($output, ">", "./d/log-LOSS-table.csv") or die "Fail to open ./d/log-LOSS-table.csv";
print $output "iterations,,avg loss,rate,seconds,images\n";

while(my $line = <$input>){

    #  19554: 0.192147, 0.212046 avg loss, 0.000020 rate, 11.324029 seconds, 2502912 images
    if($line =~ /avg loss/){
        $line =~ s/:/,/g;
        $line =~ s/avg//g;
		$line =~ s/loss//g;
		$line =~ s/rate//g;
		$line =~ s/seconds//g;
		$line =~ s/images//g;
        $line =~ s/ //g;
        
        print $output $line;		
	}
}

close($output);
close($input);