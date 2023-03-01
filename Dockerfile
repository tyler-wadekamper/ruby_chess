FROM ruby:3.1

COPY Gemfile* .

RUN bundle install

COPY . .

EXPOSE 8080

CMD ["./ttyd.x86_64", "-p", "8080", "ruby", "play_chess.rb"]