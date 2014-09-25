requires 'Mojo::UserAgent';
requires 'URI::Escape';
requires 'URI::Split';

on test => sub {
    requires 'Test::More', '0.96';
};
