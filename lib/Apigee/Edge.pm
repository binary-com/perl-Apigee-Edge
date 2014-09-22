package Apigee::Edge;

use strict;
use warnings;
our $VERSION = '0.01';

use Carp;
use Mojo::JSON;
use Mojo::UserAgent;
use Mojo::Util qw(b64_encode);
use URI::Escape;

use vars qw/$errstr/;
sub errstr { $errstr }

sub new {
    my $class = shift;
    my %args  = @_ % 2 ? %{$_[0]} : @_;

    for (qw/org usr pwd/) {
        $args{$_} || croak "Param $_ is required.";
    }

    $args{endpoint} ||= 'https://api.enterprise.apigee.com/v1';
    $args{timeout}  ||= 30; # for ua timeout

    return bless \%args, $class;
}

sub __ua {
    my $self = shift;

    return $self->{ua} if exists $self->{ua};

    my $ua = Mojo::UserAgent->new;
    $ua->max_redirects(3);
    $ua->inactivity_timeout($self->{timeout});
    $ua->proxy->detect; # env proxy
    $ua->cookie_jar(0);
    $ua->max_connections(100);
    $self->{ua} = $ua;

    return $ua;
}

## Developer http://apigee.com/docs/api/developers-0

sub get_developer {
    my $self = shift;
    my ($email) = @_;

    $self->__request('GET', "/organizations/" . $self->{org} . "/developers/" . $email);
}


sub __request {
    my ($self, $method, $url, %params) = @_;

    my $ua = $self->__ua;
    my $header = {
        Authorization => 'Basic ' . b64_encode($self->{usr} . ':' . $self->{pwd}, '')
    };
    $header->{'Content-Type'} = 'application/json' if %params;
    my @extra = %params ? (json => \%params) : ();
    my $tx = $ua->build_tx($method => $self->{endpoint} . $url => $header => @extra);
    $tx->req->headers->accept('application/json');

    $tx = $ua->start($tx);
    if ($tx->res->headers->content_type =~ 'application/json') {
        return $tx->res->json;
    }
    if (! $tx->success) {
        $errstr = $tx->error->{message};
        return;
    } else {
        return $tx->res;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Apigee::Edge - Apigee.com 'Edge' management API.

=head1 SYNOPSIS

  use Apigee::Edge;

=head1 DESCRIPTION

Apigee::Edge is an object-oriented interface to facilitate management of Developers and Apps using the Apigee.com 'Edge' management API. see L<http://apigee.com/docs/api-services/content/api-reference-getting-started>

=head1 AUTHOR

Binary.com E<lt>fayland@binary.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Binary.com

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
