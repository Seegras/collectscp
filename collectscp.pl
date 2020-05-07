#!/usr/bin/perl
#
# collects one file (each) from all cssh-clusters and renames them locally
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
my $rename;
my $needshelp;
my $containsat;
my @hosts;
my $host;
my $file;
my $dir;
my $localfile;

&Getopt::Long::Configure( 'pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions(
                'clusters|l=s'           => \$serverlist,
                'set|s=s'                => \$serverset,
                'rename|r'               => \$rename,
                'help|h'                 => \$needshelp,
);

if ($needshelp) {
    pod2usage(1);
}

die "Usage: $0 <remote-path> <local-path>\n" unless($ARGV[1]);

my $remotepath = $ARGV[0];
my $localpath = $ARGV[1];

open(my $in_file,"<","$serverlist") || die "Cannot open $serverlist for input\n";
while(<$in_file>){
    my @content = split(/ /);
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
        #print("$host\n");
    }
}

foreach my $host (@hosts) {
    if ($host ne @hosts[0]) {
        chomp $host;
        if ($containsat) {
            $host=~s/root\@//; 
        }
        if ($rename) {
            ($dir, $file) = $remotepath =~ m/(.*\/)(.*)$/;
            $localfile = "/$file-$host";
        }
        system("scp -r root\@$host:$remotepath $localpath$localfile")
    }
}


__END__

=head1 NAME

collectscp - collects files by scp from Servers from /etc/clusters

=head1 SYNOPSIS

collectscp [options] <remote-path>  <local-path> 

 Options:
   --help help message
   --clusters specify clusters file
   --set specify set of servers to use
   --rename append servername to local files

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--clusters>

Specify an /etc/clusters-style list with servers to use.

=item B<--set>

Specify a set of servers in a serverlist to use.

=item B<--rename>

Renames local file/directory by appending the hostname. This is useful
if the filenames are all the same on each server. 

=back

=head1 DESCRIPTION

B<This program> will collect files by scp from a specified set of servers.
It takes a file or directory as argument, and a path from which it will copy
this file from each server to a local directory. 

=cut
