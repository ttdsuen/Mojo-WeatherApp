package WeatherApp::Controller::Weather;
use Mojo::Base 'Mojolicious::Controller';
use List::Util qw/min max/;

sub get_p {
  my $ua = shift;
  my $promise = Mojo::Promise->new;
  $ua->get(@_ => sub {
    my ($ua, $tx) = @_;
    my $err = $tx->error;
    if   (!$err || $err->{code}) { $promise->resolve($tx) }
    else                         { $promise->reject($err->{message}) }
  });
  return $promise;
}

sub cities {
  my $self = shift;

  my $payload = $self->jsonxs->decode($self->req->body);
  if (
    ref($payload) eq 'HASH' &&
    exists $payload->{'cities'} &&
    ref($payload->{'cities'}) eq 'ARRAY') {

    # check each element in the cities array is a scalar
    foreach my $city (@{$payload->{'cities'}}) {
      if (ref($city) ne '') {
        return $self->render(json => {
          success => \0, message => "invalid request payload"
        }, status => 400);
      }
    }
    my $num_cities = scalar @{$payload->{'cities'}};

    # no cities specified, nothing to do, just return 200
    return $self->render(
      json => { success => \1, results => {} }, status => 200
    ) if $num_cities == 0;

    my $main_url = sprintf("%s?appid=%s&q=",
      $self->app->config->{'weather_api'}->{'url'},
      $self->app->config->{'weather_api'}->{'key'}
    );
    my $e = Mojo::EventEmitter->new;
    my $max_concur_req = $self->app->config->{'max_concur_req'};

    my $i = 0;

    my $r = {};

    $e->on(runbatch => sub {
      my $tasks = [];
      for (my $j=0; $j <= min($max_concur_req, $num_cities); ++$j) {
        last if $i >= $num_cities;
        push @$tasks, get_p(
          $self->ua, $main_url . $payload->{'cities'}->[$i++]
        );
      }
      Mojo::Promise->all(@$tasks)->then(sub {
        foreach my $res (@_) {
          my $res = $res->[0]->res->json;
          $r->{$res->{'name'}} = $res;
        }
        if ($i < $num_cities) {
          $e->emit(runbatch => 1);
        } else {
          $self->render(json => {
            success => \1, results => $r
          }, status => 200);
        } 
      })->catch(sub {
        my $err = shift;
        warn "Something went wrong: $err";
        if ($i < $num_cities) {
          $e->emit(runbatch => 1);
        }
      })->wait;
    });
    $e->emit(runbatch => 1) if $num_cities > 0;
  } else {
    $self->render(json => {
      success => \0, message => 'invalid request payload'
    }, status => 400);
  }
  $self->render_later;
}

1;
