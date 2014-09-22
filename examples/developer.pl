#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Apigee::Edge;
use Data::Dumper;

die "ENV APIGEE_ORG/APIGEE_USR/APIGEE_PWD is required." unless $ENV{APIGEE_ORG} and $ENV{APIGEE_USR} and $ENV{APIGEE_PWD};
my $apigee = Apigee::Edge->new(
    org => $ENV{APIGEE_ORG},
    usr => $ENV{APIGEE_USR},
    pwd => $ENV{APIGEE_PWD}
);

my $developer = $apigee->get_developer('fayland@gmail.com') or die $apigee->errstr;
print Dumper(\$developer);

1;