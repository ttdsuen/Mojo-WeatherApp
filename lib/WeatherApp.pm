package WeatherApp;
use Mojo::Base 'Mojolicious';
use Cpanel::JSON::XS;
use Mojo::Promise;
use Mojo::UserAgent;


# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});

  # Helpers
  $self->helper(jsonxs => sub {
    Cpanel::JSON::XS->new->utf8->allow_nonref }
  );
  $self->helper(json_http_hdr => sub {
    return {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    };
  });

  # Router
  my $r = $self->routes;

  my $api_v1 = $r->any('weather/api/v1');

  $api_v1->get('/cities')->name('get-weather-by-cities')->to(
    controller => 'weather', action => 'cities'
  );
}

1;
