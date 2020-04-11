use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $json_http_hdr = {
  "Content-Type" => "application/json",
  "Accept" => "application/json"
};


my $t = Test::Mojo->new('WeatherApp');
$t->get_ok(
  $t->app->url_for('get-weather-by-cities') => $json_http_hdr => json => {
    "cities" => [ "Aurora,CA", "Dartmouth,CA", "Toronto,CA" ]
  })->status_is(200)
    ->json_is('/success', Mojo::JSON->true)
    ->json_has('/results')
    ->json_has('/results/Aurora')
    ->json_has('/results/Dartmouth')
    ->json_has('/results/Toronto');

$t->get_ok(
  $t->app->url_for('get-weather-by-cities') => $json_http_hdr => json => {
    "cities" => []
  })->status_is(200)
    ->json_is('/success', Mojo::JSON->true)
    ->json_has('/results')
    ->json_is('/results', {});

$t->get_ok(
  $t->app->url_for('get-weather-by-cities') => $json_http_hdr => json => {
    "cities" => [ { "foo" => "bar" } ]
  })->status_is(400)
    ->json_is('/success', Mojo::JSON->false)
    ->json_has('/message');

done_testing();
