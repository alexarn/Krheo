package Krheo::Utils;
use strict;
use warnings;
use Krheo::Object;
use Data::Dumper;

sub to_do {
    my $file = shift;

    my $todo;
    my $lines = parse_infos_file($file);

    my $ip = shift(@$lines);
    my $hostname = shift(@$lines);
    my $c_letter = shift(@$lines);

    my $obj = Krheo::Object->new('host');
    $obj->{attr} = [ 
	{ key => "use", val => "windows-server" },
	{ key => "host_name", val => $hostname },
	{ key => "alias", val => $hostname },
	{ key => "address", val => $ip },
	{ key => "hostgroups", val => "windows-servers" },
    ];

    push @{ $todo->{host_list} }, $obj;

    foreach my $letter ( @$lines ) {
	my $service = Krheo::Object->new('service');
	$service->{attr} = [ 
	    { key => "use", val => "generic-service" },
	    { key => "host_name", val => $hostname },
	    { key => "service_description", val  => "$letter:\\ Drive Space" },
	    { key => "check_command", val => "check_nt!USEDDISKSPACE!-l " . lc($letter) . " -w 80 -c 90" },
	];
	push @{ $todo->{service_list} }, $service;
    }
    return $todo;
}

sub parse_infos_file {
    my $file = shift;

    my @lines;
    open( FH, "<$file" )
        || die "could not open $file for reading: $!";
    while (<FH>) {
	chomp;
	$_ =~ s/\r//g;
	push @lines, $_;
    }
    return \@lines;
}
1;
