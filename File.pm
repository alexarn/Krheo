package Krheo::File;
use strict;
use warnings;
use Symbol;
use Krheo::Object;

sub in {
    my ($class, $filename ) = @_;

    my $fh = gensym();
    open( $fh, "<$filename" )
        || die "could not open $filename for reading: $!";

    our $line_no = 0;

    sub strippedline {
	$line_no++;
	return undef if ( eof( $_[0] ) );
	my $line = readline( $_[0] );
	$line =~ s/[\r\n\s]+$//;    # remove trailing whitespace and CRLF
	$line =~ s/^\s+//;          # remove leading whitespace
	return ' ' if ( $line =~ /^[#;]/ );    # skip/delete comments
	return $line || ' ';    # empty lines are a single space
    }

    my $config;
    my ( $append, $type, $current, $in_definition ) = ( '', '', {}, undef );
    while ( my $line = strippedline($fh) ) {

        # skip empty lines
        next if ( $line eq ' ' );

        # append saved text to the current line
        if ($append) {
            if ( $append !~ / $/ && $line !~ /^ / ) { $append .= ' ' }
            $line   = $append . $line;
            $append = undef;
        }

        if ( $line =~ /}(\s*)$/ ) {
            $in_definition = undef;

           # continue parsing after closing object with text following the '}'
            $append = $1;
            next;
        }

        # beginning of object definition
        elsif ( $line =~ /define\s+(\w+)\s*{?(.*)$/ ) {
            $type = $1;
            if ($in_definition) {
                die "Error: Unexpected start of object definition in file "
                    . "'$filename' on line $line_no.  Make sure you close "
                    . "preceding objects before starting a new one.\n";
            }
            elsif ( !type_is_valid($type) ) {
                die
                    "Error: Invalid object definition type '$type' in file '$filename' on line $line_no.\n";
            }
            else {
		$current = Krheo::Object->new($type);
                push( @{ $config->{ $type . '_list' } }, $current );
                $in_definition = 1;
                $append        = $2;

                next;
            }
        }

        # save whatever's left in the buffer for the next iteration
        elsif ( !$in_definition ) {
            $append = $line;
            next;
        }

        # this is an attribute inside an object definition
        elsif ($in_definition) {
            $line =~ s/\s*;(.*)$//;

            my ( $key, $val ) = split( /\s+/, $line, 2 );
	    push @{ $current->{attr} }, { key => $key, val => $val, comment => $1 };
        }
        else {
            die "Error: Unexpected token in file '$filename' on line $line_no.\n";
        }
    }

    if ($in_definition) {
        die "Error: Unexpected EOF in file '$filename' on line $line_no - check for a missing closing bracket.\n";
    }

    close($fh);

    return $config;
}

sub type_is_valid {
    my $type =shift;
    my @valids = ('service', 'host', 'hostgroup');
    foreach (@valids) {
	return 1 if $type eq $_;
    } 
    return 0;
}
1;
