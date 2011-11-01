#!/usr/bin/perl

use strict;
use warnings;
use Krheo::File;
use Krheo::Utils;
use Symbol;
use Data::Dumper;
use Getopt::Long;

my ( $infos_file, $config_file, $template_file );

GetOptions (
    'infos|i=s' => \$infos_file,
    'conf|c=s' => \$config_file,
    'template|t=s' => \$template_file,
);

if ( !$infos_file || !$config_file || !$template_file ) {
    die "missing argument";
}

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
