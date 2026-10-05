FROM ruby:3.2

RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 2.4.19 \
    && bundle _2.4.19_ install

COPY . .

EXPOSE 4000

CMD ["bundle", "_2.4.19_", "exec", "jekyll", "serve", "-H", "0.0.0.0", "-w", "--config", "_config.yml,_config_docker.yml"]
