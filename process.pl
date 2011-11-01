#!/usr/bin/perl

use strict;
use warnings;
use Krheo::File;
use Krheo::Utils;
use Symbol;
use Data::Dumper;

my $infos_file = "/home/alex/nico/infos";
my $tmpl = "/home/alex/nico/Krheo/tmpl/nagios.tmpl";
my $config_file = "/home/alex/nico/windows.cfg";

my $todo = Krheo::Utils::to_do($infos_file);

my $config = Krheo::File->in($config_file);

open( TMPL, "<$tmpl" ) || die "could not open $tmpl for reading: $!";
my $new;
while (<TMPL>) {
    $new .= $_;
}

foreach my $type_list ( keys %$config ) {
    my $content = "";
    $content .= $_->dmp for @{ $config->{$type_list} };
    $content .= $_->dmp for @{ $todo->{$type_list} };

    $new =~ s/<<$type_list>>/$content/;
}
print $new;
