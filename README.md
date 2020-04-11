# Mojo App using EventEmitter/Promise with OpenWeather API

Weather WebApp Demo with Mojolicious and OpenWeather API

## Motivation

Over my long IT career, I've been doing a lot of different things. The bad part of this
is that after figuring out how to do one thing, after leaving behind for a while, I
do not remember things in details anymore. As part of this, I try to document some code
patterns in GitHub so that if I need to do something similar in future, I can always
go back and quickly get something up and running.

This one is about using Mojolicious to develop webapp. I started using Mojolicious back
in 2015, and back then there was no `Mojo::Promise`. I revisited it recently, and I try
to write some code based on it as well as `Mojo::EventEmitter` to try to maximize the
concurrency in making multiple external non-blocking calls under some
concurrency constraints (i.e. do not exceed N number of external non-blocking calls).
This result of this design is a more robust web service that is less susceptible to
incoming requests that need many external non-blocking calls.

## Framework Used

My Perl/Mojolicious development platform is,

```

CORE
  Perl        (v5.28.2, linux)
  Mojolicious (8.36, Supervillain)

OPTIONAL
  Cpanel::JSON::XS 4.09+   (4.19)
  EV 4.0+                  (4.33)
  IO::Socket::Socks 0.64+  (0.74)
  IO::Socket::SSL 2.009+   (2.068)
  Net::DNS::Native 0.15+   (0.22)
  Role::Tiny 2.000001+     (2.001004)
  Future::AsyncAwait 0.36+ (0.39)

This version is up to date, have fun!

```

## Installation

Assuming Ubuntu,

```
# apt-get install -y build-essential libssl-dev libz-dev
$ curl -L https://install.perlbrew.pl | bash
$ . perl5/perlbrew/etc/bashrc
$ perlbrew install perl-5.28.2
$ perlbrew switch perl-5.28.2
$ curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious
$ curl -L https://cpanmin.us | perl - App::cpanminus
$ cpanm Cpanel::JSON::XS, EV, IO::Socket::Socks Net::DNS::Native Role::Tiny Future::AsyncAwait IO::Socket::SSL
```

## Tests

```
$ prove -lv t
t/basic.t .. 
ok 1 - GET http://127.0.0.1:46635/weather/api/v1/cities
ok 2 - 200 OK
ok 3 - exact match for JSON Pointer "/success"
ok 4 - has value for JSON Pointer "/results"
ok 5 - has value for JSON Pointer "/results/Aurora"
ok 6 - has value for JSON Pointer "/results/Dartmouth"
ok 7 - has value for JSON Pointer "/results/Toronto"
ok 8 - GET http://127.0.0.1:46635/weather/api/v1/cities
ok 9 - 200 OK
ok 10 - exact match for JSON Pointer "/success"
ok 11 - has value for JSON Pointer "/results"
ok 12 - exact match for JSON Pointer "/results"
ok 13 - GET http://127.0.0.1:46635/weather/api/v1/cities
ok 14 - 400 Bad Request
ok 15 - exact match for JSON Pointer "/success"
ok 16 - has value for JSON Pointer "/message"
1..16
ok
All tests successful.
```

## Sample Usage

I use Hypnotoad to run the webapp,

```
$ hypnotoad ./script/weather_app 
Server available at http://127.0.0.1:3000
```

Sample request and response,

```
$ curl -d '{"cities":["Los Angeles,US"]}' -X GET http://127.0.0.1:3000/weather/api/v1/cities
```
```json
{"results":{"Los Angeles":{"base":"stations","clouds":{"all":40},"cod":200,"coord":{"lat":34.05,"lon":-118.24},"dt":1586633539,"id":5368361,"main":{"feels_like":288.69,"humidity":63,"pressure":1016,"temp":291.16,"temp_max":293.71,"temp_min":288.15},"name":"Los Angeles","sys":{"country":"US","id":3971,"sunrise":1586611562,"sunset":1586658069,"type":1},"timezone":-25200,"visibility":16093,"weather":[{"description":"scattered clouds","icon":"03d","id":802,"main":"Clouds"}],"wind":{"deg":214,"speed":3.94}}},"success":true}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Authors

* **Daniel Suen**

## License
[MIT](https://choosealicense.com/licenses/mit/)
