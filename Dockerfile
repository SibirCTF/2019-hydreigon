FROM ruby:latest

# Create home directory
ENV HOME /home/app

RUN apt-get update > /dev/null && apt-get install postgresql postgresql-client -y

# Set home directory
WORKDIR $HOME

# Configure required environmentproduction
ENV HANAMI_ENV production

# Set and expose PORT environmental variable
EXPOSE 2300

# Install package manager
RUN gem install bundler

# Copy all files
COPY . ./

# Install all production dependencies
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install -j `nproc` --without=test development

#make assets
RUN hanami assets precompile

CMD puma -e production
