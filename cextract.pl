#!/usr/bin/env perl
use Modern::Perl;
use Getopt::Std;
use Image::ExifTool qw(:Public);

my %args;
getopts('vo:', \%args);
my $song = shift or die "Usage: $0 [-v] [-o file] song\n";
my $info = ImageInfo($song); # hash ref of tag->value
my $type = $info->{PictureMimeType};

die "Couldn't find embedded image\n" unless $type;

my $outname = $args{o} || 'cover';
$outname .= '.' . (split '/', $type)[1]; # grab the jpeg|gif|png of MimeType

if($args{v}) {
    say "Found image-type: $type";
    say "Writing to $outname";
}

open my $fh, '>', $outname or die "open: $!";
print $fh ${ $info->{Picture} };
close $fh;
