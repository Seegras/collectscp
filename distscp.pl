#!/usr/bin/perl
#
# distrubutes a file onto one place on all cssh-clusters.
# 
# Author:   Peter Keel <seegras@discordia.ch>
# Date:     2008-07-01?
# Revision: 2020-06-05
# Version:  0.2
# License:  Artistic License 2.0 or MIT License or GPLv2 
# URL:      http://seegras.discordia.ch/Programs/
#
use strict;
use Getopt::Long;
use Pod::Usage;

# Default Config
my $serverlist = '~/.clusterssh/clusters';
my $serverset = 'all';
# Globals 
my $needshelp;
my $containsat;
my @hosts;
my $host;

&Getopt::Long::Configure( 'pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions(
    'clusters|l=s'      => \$serverlist,
    'set|s=s'           => \$serverset,
    'help|h'            => \$needshelp,
);

if ($needshelp) {
    pod2usage(1);
}

die "Usage: $0 <local-path> <remote-path>\n" unless($ARGV[1]);

my $localfile = $ARGV[0];
my $remotepath = $ARGV[1];

open(my $in_file,"<","$serverlist") || die "Cannot open $serverlist for input\n";
while(<$in_file>){
    @content = split(/ /);
    if ($content[0] eq $serverset) {
        @hosts = @content;
    }
    if ($content[1]=~m/\@/) {
        $containsat = 1; 
    } 
}
close $in_file;

if (! @hosts) {
die "Set of Servers $serverset not found.\n"; 
}

foreach my $host (@hosts) {
    if ($host ne @hosts[0]) {
        chomp $host;
        if ($containsat) {
            $host=~s/root\@//; 
        }
        system("scp -r $localfile root\@$host:$remotepath")
    }
}

__END__

=head1 NAME

distscp - Distributes files by scp to Servers from /etc/clusters

=head1 SYNOPSIS

distscp [options] <file ...> <remote-path>

 Options:
   --help help message
   --clusters specify clusters file
   --set specify set of servers to use

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--clusters>

Specify an /etc/clusters-style list with servers to use.

=item B<--set>

Specify a set of servers in a serverlist to use.

=back

=head1 DESCRIPTION

B<This program> will distribute files by scp to a specified set of servers.
It takes a file or directory as argument, and a path to which it will copy
this file onto each server. 

=cut
