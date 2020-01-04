#!/usr/bin/perl
use strict;
use warnings;

my $outputName = "./d/map_" . dtStr();

my $dir;
opendir($dir, "./d/weights") or die "fail to open weights dir";
my @fileNames = sort readdir($dir);
closedir($dir);

for my $weight (@fileNames){
    next if $weight eq '.';
    next if $weight eq '..';
    next if $weight !~ /\.weights$/i;

    print $weight . "\n";
    writeTxt( "\n" . '>' .  $weight, $outputName . ".txt");

    my $cmd = "./darknet detector map d/obj.data d/yolov3-tiny_obj.cfg d/weights/" . $weight . " >>" . $outputName . ".txt";	
    my $echo = system($cmd);
}

# now find the information from outputName
my $detail;
my $abstract;
my $csv;
open($detail, ">", $outputName.'.detail.txt');
open($abstract, ">", $outputName . '.abstract.txt');
open($csv, ">", $outputName . '.csv');

my $f;
open($f, "<", $outputName . ".txt");

my @keys = ("iterator", "forconf_thresh","precision", "recall", "averageIoU", "F1-score", "TP", "FP", "FN", "mAP");
print $csv join(',', @keys, "\n");

my %result = ();
while( my $line=<$f>){

	if($line =~ /^>/){
		print $detail $line;
		print $abstract $line;
		my $s = $line;
		if($s =~ /(\d+)\./){
			$result{"iterator"} = $1;
		}
	}
	if($line =~ / mean average precision/) {
		print $detail $line;
		print $abstract $line;
		
		# mean average precision (mAP@0.25) = 0.496869, or 49.69 %
		if($line =~ /= (.*),/){
		    $result{"mAP"} = $1;
		}
				
		for(my $i=0; $i<@keys; $i++){
		    if(exists $result{$keys[$i]}){
			    print $csv $result{$keys[$i]}, ",";
			}
			else{
			    print $csv ",";
			}		
		}
		
		print $csv "\n";		
		
		%result = ();
	}  
	if($line =~ /^class_id/) {
		print $detail $line;
	}   
	if($line =~ /^ for conf_thresh/) {
		print $detail $line;
		
				
		my $s = $line;
		chomp($s);
		my @paras = split(/,/, $s);
		for my $para (@paras){
            my ($k, $v) = split(/=/, $para);
            $k =~ s/ //g;	
            $v =~ s/ //g;
            if($k ne "" && $v ne ""){
			    $result{$k} = $v;				
			}			
		}	
	}   
}

close($f);
close($detail);
close($abstract);
close($csv);

sub dtStr {

    my $dt = $_[0] || 0;

    if ( $dt eq 0 ) {
        $dt = time();
    }

    my @timelist = localtime($dt);
    $timelist[5] += 1900;
    $timelist[4]++;

    return sprintf(
        "%04d%02d%02d_%02d%02d%02d",
        $timelist[5], $timelist[4], $timelist[3],
        $timelist[2], $timelist[1], $timelist[0]
    );
}

sub writeTxt{

    my $s = shift;
	my $fname = shift;
	
    my $f;
    open($f, ">>", $fname);
    print $f $s . "\n";
    close($f);
}
