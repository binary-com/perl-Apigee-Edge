package Apigee::Edge;

use strict;
use warnings;
our $VERSION = '0.01';

use Carp;
use Mojo::JSON;
use Mojo::UserAgent;
use Mojo::Util qw(b64_encode);
use URI::Escape qw/uri_escape/;

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
sub create_developer {
    my $self = shift;
    my %args  = @_ % 2 ? %{$_[0]} : @_;
    $self->__request('POST', "/organizations/" . $self->{org} . "/developers", %args);
}

sub get_developer {
    my $self = shift;
    my ($email) = @_;
    $self->__request('GET', "/organizations/" . $self->{org} . "/developers/" . uri_escape($email));
}

sub delete_developer {
    my $self = shift;
    my ($email) = @_;
    $self->__request('DELETE', "/organizations/" . $self->{org} . "/developers/" . uri_escape($email));
}

sub get_app_developers {
    my $self = shift;
    my ($app) = @_;
    $self->__request('GET', "/organizations/" . $self->{org} . "/developers?app=" . uri_escape($app));
}

sub get_developers {
    my $self = shift;
    $self->__request('GET', "/organizations/" . $self->{org} . "/developers");
}

sub set_developer_status {
    my ($self, $email, $status);
    $self->__request('GET', "/organizations/" . $self->{org} . "/developers/" . uri_escape($email) . "?action=" . uri_escape($status));
}

sub update_developer {
    my $self = shift;
    my %args  = @_ % 2 ? %{$_[0]} : @_;
    my $email = delete $args{email} or croak "email is required.";
    $self->__request('POST', "/organizations/" . $self->{org} . "/developers/" . uri_escape($email), %args);
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
    }

    $errstr = "Unknown Response.";
    return;
}

1;
__END__

=encoding utf-8

=head1 NAME

Apigee::Edge - Apigee.com 'Edge' management API.

=head1 SYNOPSIS

  use Apigee::Edge;

  my $apigee = Apigee::Edge->new(
    org => 'apigee_org',
    usr => 'your_email',
    pwd => 'your_password'
  );

=head1 DESCRIPTION

Apigee::Edge is an object-oriented interface to facilitate management of Developers and Apps using the Apigee.com 'Edge' management API. see L<http://apigee.com/docs/api-services/content/api-reference-getting-started>

=head2 METHODS

=head3 new

=over 4

=item * org

required. organization name.

=item * usr

required. login email

=item * pwd

required. login password

=item * endpoint

optional. default to https://api.enterprise.apigee.com/v1

=back

=head3 Developer

L<http://apigee.com/docs/api/developers-0>

=head4 create_developer

    my $developer = $apigee->create_developer(
        "email" => 'fayland@binary.com',
        "firstName" => "Fayland",
        "lastName" => "Lam",
        "userName" => "fayland.binary",
        "attributes" => [
            {
                "name" => "Attr1",
                "value" => "V1"
            },
            {
                "name" => "A2",
                "value" => "V2.v2"
            }
        ]
    );

=head4 delete_developer

    my $developer = $apigee->delete_developer('fayland@binary.com') or die $apigee->errstr;

=head4 get_developer

    my $developer = $apigee->get_developer('fayland@binary.com') or die $apigee->errstr;

=head4 get_app_developers

    my $developers = $apigee->get_app_developers($app_name);

=head4 get_developers

    my $developers = $apigee->get_developers();

=head4 set_developer_status

    my $status = $apigee->set_developer_status($email, $status);

=head4 update_developer

    my $developer = $apigee->update_developer(
        "email" => 'fayland@binary.com', # primary key

        # update parts
        "firstName" => "Fayland",
        "lastName" => "Lam",
    );

=head1 AUTHOR

Binary.com E<lt>fayland@binary.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Binary.com

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
