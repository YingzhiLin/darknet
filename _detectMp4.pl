#!/usr/bin/perl
use strict;
use warnings;

print "Usage: ./_detectMp4.pl ./d/weights/yolo-obj_1400.weights 0.65 \n";

exit 0 if @ARGV < 2;
my $weight = $ARGV[0];
my $thresh = $ARGV[1];

my $dir;
opendir($dir, './d/test') or die 'Fail to open ./d/test/';
my @files = readdir($dir);
closedir($dir);

for my $file (@files){
    next if $file !~ /\.mp4$/;

    my $dirRoot = './d/output';
    mkdir($dirRoot) if not -e $dirRoot;
	
    my $dirOut = $dirRoot . '/' . $file;
    mkdir($dirOut) if not -e $dirOut;

    my $cmd = ' ./darknet detector demo d/obj.data d/yolo-obj.cfg ' . $weight . ' -i 0 -thresh '.$thresh.' -prefix '. $dirOut .'/ d/test/' . $file;
    system($cmd);
}
