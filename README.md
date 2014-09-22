# NAME

Apigee::Edge - Apigee.com 'Edge' management API.

# SYNOPSIS

    use Apigee::Edge;

    my $apigee = Apigee::Edge->new(
      org => 'apigee_org',
      usr => 'your_email',
      pwd => 'your_password'
    );

# DESCRIPTION

Apigee::Edge is an object-oriented interface to facilitate management of Developers and Apps using the Apigee.com 'Edge' management API. see [http://apigee.com/docs/api-services/content/api-reference-getting-started](http://apigee.com/docs/api-services/content/api-reference-getting-started)

# METHODS

## new

- org

    required. organization name.

- usr

    required. login email

- pwd

    required. login password

- endpoint

    optional. default to https://api.enterprise.apigee.com/v1

## Apps

[http://apigee.com/docs/api/apps-0](http://apigee.com/docs/api/apps-0)

### get\_app

    my $app = $apigee->get_app($app_id);

### get\_apps\_by\_family

    my $app_ids = $apigee->get_apps_by_family($family);

### get\_apps\_by\_keystatus

    my $app_ids = $apigee->get_apps_by_keystatus($keystatus);

### get\_apps\_by\_type

    my $app_ids = $apigee->get_apps_by_type($type);

### get\_apps

    my $app_ids = $apigee->get_apps();

### Developers

[http://apigee.com/docs/api/developers-0](http://apigee.com/docs/api/developers-0)

### create\_developer

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

### delete\_developer

    my $developer = $apigee->delete_developer('fayland@binary.com') or die $apigee->errstr;

### get\_developer

    my $developer = $apigee->get_developer('fayland@binary.com') or die $apigee->errstr;

### get\_app\_developers

    my $developers = $apigee->get_app_developers($app_name);

### get\_developers

    my $developers = $apigee->get_developers();

### set\_developer\_status

    my $status = $apigee->set_developer_status($email, $status);

### update\_developer

    my $developer = $apigee->update_developer(
        "email" => 'fayland@binary.com', # primary key

        # update parts
        "firstName" => "Fayland",
        "lastName" => "Lam",
    );

## request

The underlaying method to call Apigee when you see something is missing.

    $self->request('GET', "/organizations/$org_name/apps/$app_id");
    $self->request('DELETE', "/organizations/$org_name/developers/" . uri_escape($email));
    $self->request('POST', "/organizations/$org_name/developers", %args);
    $self->request('PUT', "/organizations/$org_name/developers/" . uri_escape($email), %args);

# AUTHOR

Binary.com <fayland@binary.com>

# COPYRIGHT

Copyright 2014- Binary.com

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
