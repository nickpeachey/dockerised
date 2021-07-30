FROM ruby:3.0.1-buster

ENV RAILS_ROOT /project


# Install Yarn.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

WORKDIR $RAILS_ROOT

ENV RAILS_ENV production
ENV SECRET_KEY_BASE = 'IjHEyce51HrHS40u5XR1NgGsIckM71H4dl9S2g2/B4wB9TV07P2XJOAuiq0t3YLLmoTC3sX3eP7CZmRvO+ifvphN23Y76asPJkrhVzKR5k1+geQAFQa0OKPvepUlAdtALvZE4/XPniVlToiIeOG7Uy8lgIohKR86hDWtP3rMTZvB2jdnIajs+DdoTVBmF9J0AwPRK/r8UXOtW60aCdBWSPwSpsIqcoz1RIQXfyCQl4Coobdz6zd7hagHHcPNTDH47wTs0/CGfGXbkhlUTdvGAEP/L6NQL1OL7qIaJmJRfQhL8Qldb+fSvo4OlMJsJ0yMFTV3BXxBgTNKJDn1+qN/stgYWuuO3bbwf14tM0f520rPnNHY5FuOCqDIhiVkeyrRDQ2SIyjx71Meu8c5YtcqCpm6q0S4Ht+oJqXx--4AjoB3waSlPnEdQa--c+ubO+6aT7uiKONOYIgCGQ=='

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install --jobs 20 --retry 5 --without development test

COPY package.json package.json
COPY yarn.lock yarn.lock

RUN yarn install --check-files

COPY . .

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s"]