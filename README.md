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
        $developer_email,
        {
            "firstName" => "Fayland",
            "lastName" => "Lam",
        }
    );

## Apps: Developer

[http://apigee.com/docs/api/apps-developer](http://apigee.com/docs/api/apps-developer)

### change\_app\_status

    my $app = $apigee->change_app_status($developer_email, $app_name);

### create\_developer\_app

    my $app = $apigee->create_developer_app(
        $developer_email,
        {
            "name" => "Test App",
            "apiProducts" => [ "{apiproduct1}", "{apiproduct2}", ...],
            "keyExpiresIn" => "{milliseconds}",
            "attributes" => [
                {
                    "name" => "DisplayName",
                    "value" => "{display_name_value}"
                },
                {
                    "name" => "Notes",
                    "value" => "{notes_for_developer_app}"
                },
                {
                    "name" => "{custom_attribute_name}",
                    "value" => "{custom_attribute_value}"
                }
            ],
            "callbackUrl" => "{url}",
        }
    );

### delete\_developer\_app

    my $app = $apigee->delete_developer_app($developer_email, $app_name);

### get\_developer\_app

    my $app = $apigee->get_developer_app($developer_email, $app_name);

### get\_developer\_apps

    my $apps = $apigee->get_developer_apps($developer_email);

### update\_developer\_app

    my $app = $apigee->update_developer_app($developer_email, $app_name, {
        # update part
    });

### regenerate\_developer\_app\_key

    my $app = $apigee->regenerate_developer_app_key($developer_email, $app_name, {
        # update part
    });

### get\_count\_of\_developer\_app\_resource

    my $count = $apigee->get_count_of_developer_app_resource($developer_email, $app_name, $entity_name);

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
