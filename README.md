# Mojo App using EventEmitter/Promise with OpenWeather API

Weather WebApp using Mojolicious, Mojo::EventEmitter and Mojo::Promise with OpenWeather API

## Getting Started

### Prerequisites

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

### Installing

Assuming Ubuntu,

Install build tools,
```
# apt-get install -y build-essential
```

Install libssl-dev, libz-dev
```
# apt-get install -y libssl-dev libz-dev
```

Install perlbrew,
```
$ curl -L https://install.perlbrew.pl | bash
$ . perl5/perlbrew/etc/bashrc
```

Install perl-5.28.2,
```
$ perlbrew install perl-5.28.2
$ perlbrew switch perl-5.28.2
```

Install Mojolicious,
```
$ curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious
```

Install cpanm,
```
$ curl -L https://cpanmin.us | perl - App::cpanminus
```

Install Cpanel::JSON::XS, EV, IO::Socket::Socks Net::DNS::Native Role::Tiny Future::AsyncAwait IO::Socket::SSL
```
$ cpanm Cpanel::JSON::XS, EV, IO::Socket::Socks Net::DNS::Native Role::Tiny Future::AsyncAwait IO::Socket::SSL
```


## Authors

* **Daniel Suen**

