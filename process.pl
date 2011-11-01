#!/usr/bin/perl

use strict;
use warnings;
use Krheo::File;
use Symbol;
use Data::Dumper;

my $infos_file = "infos";
my $tmpl = "/home/alex/nico/Krheo/tmpl/nagios.tmpl";
my $config_file = "/home/alex/nico/windows.cfg";

my $config = Krheo::File->in($config_file);

# work to do

open( TMPL, "<$tmpl" ) || die "could not open $tmpl for reading: $!";
my $new;
while (<TMPL>) {
    $new .= $_;
}

foreach my $type_list ( keys %$config ) {
    my $content = "";
    $content .= $_->dmp for @{ $config->{$type_list} };
    $new =~ s/<<$type_list>>/$content/;
}
print $new;
