FROM ruby:2.1-onbuild
EXPOSE 80
CMD ["rackup", "-p", "80", "-o", "0.0.0.0"]
